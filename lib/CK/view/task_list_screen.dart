import 'package:flutter/material.dart';
import 'package:test_project/CK/model/task.dart';
import 'package:test_project/CK/model/user.dart';
import 'package:test_project/CK/db/reposotory.dart';
import 'package:test_project/CK/view/task_detail_screen.dart';
import 'package:test_project/CK/view/task_form_screen.dart';

class TaskListScreen extends StatefulWidget {
  final User currentUser;
  const TaskListScreen({required this.currentUser});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final Repository _repo = Repository();
  final _searchController = TextEditingController();
  String? _statusFilter;
  int? _priorityFilter;
  String? _categoryFilter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButton<String?>(
                hint: const Text('Status'),
                value: _statusFilter,
                items: ['To do', 'In progress', 'Done', 'Cancelled', null]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e ?? 'All')))
                    .toList(),
                onChanged: (value) => setState(() => _statusFilter = value),
              ),
              DropdownButton<int?>(
                hint: const Text('Priority'),
                value: _priorityFilter,
                items: [1, 2, 3, null]
                    .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e?.toString() ?? 'All'),
                ))
                    .toList(),
                onChanged: (value) => setState(() => _priorityFilter = value),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<Task>>(
              future: _repo.searchTasks(
                keyword: _searchController.text,
                status: _statusFilter,
                priority: _priorityFilter,
                category: _categoryFilter,
                userId: widget.currentUser.role == 'user' ? widget.currentUser.id : null,
                isAdmin: widget.currentUser.role == 'admin',
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final tasks = snapshot.data!;
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return TaskItem(
                        task: tasks[index],
                        repo: _repo,
                        currentUser: widget.currentUser,
                        onUpdate: () => setState(() {}),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskDetailScreen(
                                task: tasks[index],
                                currentUser: widget.currentUser,
                              ),
                            ),
                          ).then((value) {
                            if (value == true) setState(() {});
                          });
                        },
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskFormScreen(currentUser: widget.currentUser),
          ),
        ).then((value) {
          if (value == true) setState(() {});
        }),
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class TaskItem extends StatefulWidget {
  final Task task;
  final Repository repo;
  final User currentUser;
  final VoidCallback onTap;
  final VoidCallback onUpdate;

  const TaskItem({
    required this.task,
    required this.repo,
    required this.currentUser,
    required this.onTap,
    required this.onUpdate,
  });

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  late Task _task;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(_task.title),
        subtitle: Text('Status: ${_task.status} | Priority: ${_task.priority}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: _task.completed,
              onChanged: (value) async {
                try {
                  final updatedTask = _task.copyWith(completed: value!);
                  await widget.repo.updateTask(updatedTask);
                  setState(() {
                    _task = updatedTask;
                  });
                  widget.onUpdate();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update task: $e')),
                  );
                }
              },
            ),
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
                  if (value == true) widget.onUpdate();
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirm Delete'),
                    content: const Text('Are you sure you want to delete this task?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  try {
                    await widget.repo.deleteTask(_task.id);
                    widget.onUpdate();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete task: $e')),
                    );
                  }
                }
              },
            ),
          ],
        ),
        onTap: widget.onTap,
      ),
    );
  }
}