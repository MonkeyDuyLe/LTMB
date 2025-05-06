import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:test_project/CK/model/task.dart';
import 'package:test_project/CK/model/user.dart';
import 'package:test_project/CK/db/reposotory.dart';
import 'package:intl/intl.dart';

class TaskFormScreen extends StatefulWidget {
  final User currentUser;
  final Task? task;

  const TaskFormScreen({required this.currentUser, this.task});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _attachmentController = TextEditingController();
  String _status = 'To do';
  int _priority = 1;
  DateTime? _dueDate;
  String? _assignedTo;
  List<String> _attachments = [];
  final Repository _repo = Repository();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _status = widget.task!.status;
      _priority = widget.task!.priority;
      _dueDate = widget.task!.dueDate;
      _assignedTo = widget.task!.assignedTo;
      _categoryController.text = widget.task!.category ?? '';
      _attachments = widget.task!.attachments ?? [];
    }
    // Nếu là user thường và tạo task mới, mặc định gán cho chính họ
    if (widget.currentUser.role == 'user' && widget.task == null) {
      _assignedTo = widget.currentUser.id;
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final task = Task(
          id: widget.task?.id ?? const Uuid().v4(),
          title: _titleController.text,
          description: _descriptionController.text,
          status: _status,
          priority: _priority,
          dueDate: _dueDate,
          createdAt: widget.task?.createdAt ?? DateTime.now(),
          updatedAt: DateTime.now(),
          assignedTo: _assignedTo,
          createdBy: widget.currentUser.id,
          category: _categoryController.text.isEmpty ? null : _categoryController.text,
          attachments: _attachments.isEmpty ? null : _attachments,
          completed: widget.task?.completed ?? false,
        );

        if (widget.task == null) {
          await _repo.createTask(task);
        } else {
          await _repo.updateTask(task);
        }
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save task: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task == null ? 'New Task' : 'Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                value!.isEmpty ? 'Title is required' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) =>
                value!.isEmpty ? 'Description is required' : null,
              ),
              DropdownButtonFormField<String>(
                value: _status,
                items: ['To do', 'In progress', 'Done', 'Cancelled']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => setState(() => _status = value!),
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              DropdownButtonFormField<int>(
                value: _priority,
                items: [1, 2, 3]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e.toString())))
                    .toList(),
                onChanged: (value) => setState(() => _priority = value!),
                decoration: const InputDecoration(labelText: 'Priority'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Due Date'),
                controller: TextEditingController(
                  text: _dueDate != null
                      ? DateFormat('yyyy-MM-dd').format(_dueDate!)
                      : '',
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() => _dueDate = date);
                  }
                },
                readOnly: true,
              ),
              FutureBuilder<List<User>>(
                future: _repo.getAllUsers(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final users = widget.currentUser.role == 'admin'
                        ? snapshot.data! // Admin thấy tất cả người dùng
                        : [widget.currentUser]; // User thường chỉ thấy chính họ
                    return DropdownButtonFormField<String>(
                      value: _assignedTo,
                      items: [
                        const DropdownMenuItem(value: null, child: Text('None')),
                        ...users
                            .map((user) => DropdownMenuItem(
                          value: user.id,
                          child: Text(user.username),
                        ))
                            .toList(),
                      ],
                      onChanged: (value) => setState(() => _assignedTo = value),
                      decoration: const InputDecoration(labelText: 'Assigned To'),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              TextFormField(
                controller: _attachmentController,
                decoration: InputDecoration(
                  labelText: 'Attachment URL',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (_attachmentController.text.isNotEmpty) {
                        setState(() {
                          _attachments.add(_attachmentController.text);
                          _attachmentController.clear();
                        });
                      }
                    },
                  ),
                ),
              ),
              if (_attachments.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Attachments:'),
                    ..._attachments
                        .asMap()
                        .entries
                        .map((entry) => Row(
                      children: [
                        Expanded(child: Text(entry.value)),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => setState(
                                () => _attachments.removeAt(entry.key),
                          ),
                        ),
                      ],
                    ))
                        .toList(),
                  ],
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _attachmentController.dispose();
    super.dispose();
  }
}