import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/task_model.dart';
import '../service/api_service.dart';
import 'package:uuid/uuid.dart';

class TaskFormScreen extends StatefulWidget {
  final TaskModel? task;

  TaskFormScreen({this.task});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _status = 'To do';
  int _priority = 1;
  DateTime? _dueDate;
  String? _category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task == null ? 'Add Task' : 'Edit Task')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: widget.task?.title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) =>
                value!.isEmpty ? 'Enter title' : null,
                onChanged: (value) => _title = value,
              ),
              TextFormField(
                initialValue: widget.task?.description,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) =>
                value!.isEmpty ? 'Enter description' : null,
                onChanged: (value) => _description = value,
              ),
              DropdownButtonFormField<String>(
                value: _status,
                items: ['To do', 'In progress', 'Done', 'Cancelled']
                    .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status),
                ))
                    .toList(),
                onChanged: (value) => setState(() => _status = value!),
                decoration: InputDecoration(labelText: 'Status'),
              ),
              DropdownButtonFormField<int>(
                value: _priority,
                items: [1, 2, 3]
                    .map((priority) => DropdownMenuItem(
                  value: priority,
                  child: Text('Priority $priority'),
                ))
                    .toList(),
                onChanged: (value) => setState(() => _priority = value!),
                decoration: InputDecoration(labelText: 'Priority'),
              ),
              TextButton(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    setState(() => _dueDate = selectedDate);
                  }
                },
                child: Text(_dueDate == null
                    ? 'Select Due Date'
                    : _dueDate.toString()),
              ),
              TextFormField(
                initialValue: widget.task?.category,
                decoration: InputDecoration(labelText: 'Category'),
                onChanged: (value) => _category = value,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final apiService =
                      Provider.of<ApiService>(context, listen: false);
                      final task = TaskModel(
                        id: widget.task?.id ?? Uuid().v4(),
                        title: _title,
                        description: _description,
                        status: _status,
                        priority: _priority,
                        dueDate: _dueDate,
                        createdAt:
                        widget.task?.createdAt ?? DateTime.now(),
                        updatedAt: DateTime.now(),
                        createdBy: 'current_user_id', // Replace with actual user ID
                        completed: widget.task?.completed ?? false,
                      );
                      if (widget.task == null) {
                        await apiService.createTask(task);
                      } else {
                        await apiService.updateTask(task);
                      }
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
                child: Text(widget.task == null ? 'Add Task' : 'Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}