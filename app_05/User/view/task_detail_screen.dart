import 'package:flutter/material.dart';
import '../model/task_model.dart';
import 'package:provider/provider.dart';
import '../service/api_service.dart';

class TaskDetailScreen extends StatelessWidget {
  final TaskModel task;

  TaskDetailScreen({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(task.title)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${task.description}'),
            Text('Status: ${task.status}'),
            Text('Priority: ${task.priority}'),
            Text('Due Date: ${task.dueDate?.toString() ?? 'N/A'}'),
            Text('Category: ${task.category ?? 'N/A'}'),
            Text('Attachments: ${task.attachments?.join(', ') ?? 'None'}'),
            ElevatedButton(
              onPressed: () async {
                try {
                  await Provider.of<ApiService>(context, listen: false).updateTask(
                    TaskModel(
                      id: task.id,
                      title: task.title,
                      description: task.description,
                      status: task.status,
                      priority: task.priority,
                      dueDate: task.dueDate,
                      createdAt: task.createdAt,
                      updatedAt: DateTime.now(),
                      assignedTo: task.assignedTo,
                      createdBy: task.createdBy,
                      category: task.category,
                      attachments: task.attachments,
                      completed: !task.completed,
                    ),
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: Text(task.completed ? 'Mark Incomplete' : 'Mark Complete'),
            ),
          ],
        ),
      ),
    );
  }
}