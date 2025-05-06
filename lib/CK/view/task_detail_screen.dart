import 'package:flutter/material.dart';
import 'package:test_project/CK/model/task.dart';
import 'package:test_project/CK/model/user.dart';
import 'package:test_project/CK/db/reposotory.dart';
import 'package:test_project/CK/view/task_form_screen.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  final User currentUser;

  const TaskDetailScreen({required this.task, required this.currentUser});

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final Repository _repo = Repository();
  late Task _task;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  @override
  Widget build(BuildContext context) {
    final canEdit = widget.currentUser.role == 'admin' ||
        widget.currentUser.id == _task.assignedTo ||
        widget.currentUser.id == _task.createdBy;

    return Scaffold(
      appBar: AppBar(
        title: Text(_task.title),
        actions: [
          if (canEdit)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskFormScreen(
                      currentUser: widget.currentUser,
                      task: _task,
                    ),
                  ),
                ).then((value) {
                  if (value == true) {
                    Navigator.pop(context, true);
                  }
                });
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${_task.description}'),
            Text('Status: ${_task.status}'),
            Text('Priority: ${_task.priority}'),
            Text('Due Date: ${_task.dueDate?.toString() ?? 'N/A'}'),
            Text('Assigned To: ${_task.assignedTo ?? 'N/A'}'),
            Text('Created By: ${_task.createdBy}'),
            Text('Category: ${_task.category ?? 'N/A'}'),
            Text('Completed: ${_task.completed ? 'Yes' : 'No'}'),
            if (_task.attachments != null && _task.attachments!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Attachments:'),
                  ..._task.attachments!.map((link) => Text(link)),
                ],
              ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: _task.status,
              items: ['To do', 'In progress', 'Done', 'Cancelled']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: canEdit
                  ? (value) async {
                try {
                  final updatedTask = _task.copyWith(status: value!);
                  await _repo.updateTask(updatedTask);
                  setState(() {
                    _task = updatedTask;
                  });
                  Navigator.pop(context, true);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update status: $e')),
                  );
                }
              }
                  : null, // Vô hiệu hóa nếu không có quyền
            ),
          ],
        ),
      ),
    );
  }
}