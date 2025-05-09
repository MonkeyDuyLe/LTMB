import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/task_model.dart';

class ApiService {
  final String baseUrl = 'https://your-backend-api.com/api';
  String? _token;

  void setToken(String token) {
    _token = token;
  }

  Future<List<TaskModel>> getTasks({String? status, String? category}) async {
    try {
      final uri = Uri.parse('$baseUrl/tasks')
          .replace(queryParameters: {'status': status, 'category': category});
      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $_token'},
      );
      if (response.statusCode == 200) {
        List jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((task) => TaskModel.fromJson(task)).toList();
      }
      throw Exception('Failed to load tasks');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<TaskModel> createTask(TaskModel task) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tasks'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode(task.toJson()),
      );
      if (response.statusCode == 201) {
        return TaskModel.fromJson(jsonDecode(response.body));
      }
      throw Exception('Failed to create task');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/tasks/${task.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode(task.toJson()),
      );
      if (response.statusCode == 200) {
        return TaskModel.fromJson(jsonDecode(response.body));
      }
      throw Exception('Failed to update task');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/tasks/$id'),
        headers: {'Authorization': 'Bearer $_token'},
      );
      if (response.statusCode != 204) {
        throw Exception('Failed to delete task');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}