import 'package:flutter/material.dart';
import '../model/task_model.dart';
import '../view/task_detail_screen.dart';

class TaskItemWidget extends StatelessWidget {
  final TaskModel task;

  TaskItemWidget({required this.task});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.title),
      subtitle: Text('Priority: ${task.priority} | Status: ${task.status}'),
      trailing: Icon(
        task.completed ? Icons.check_circle : Icons.circle_outlined,
        color: task.completed ? Colors.green : Colors.grey,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TaskDetailScreen(task: task),
          ),
        );
      },
    );
  }
}