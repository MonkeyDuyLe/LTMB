import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/task_model.dart'; // Corrected import path (use lowercase 'models')
import '../service/api_service.dart'; // Corrected import path (use lowercase 'services')
import 'package:app_05/User/view/task_detail_screen.dart'; // Corrected import path (use lowercase 'screens')
import '../view/task_form_screen.dart'; // Corrected import path (use lowercase 'screens')
import '../widget/task_item_widger.dart'; // Added import for TaskItemWidget

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String? _filterStatus;
  String? _filterCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Implement filter dialog
            },
          ),
        ],
      ),
      body: FutureBuilder<List<TaskModel>>(
        future: Provider.of<ApiService>(context)
            .getTasks(status: _filterStatus, category: _filterCategory),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final tasks = snapshot.data ?? [];
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskItemWidget(task: task);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TaskFormScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}