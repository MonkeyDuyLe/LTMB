import 'package:sqflite/sqflite.dart';
import 'package:test_project/CK/db/DatabaseHelper.dart';
import 'package:test_project/CK/model/user.dart';
import 'package:test_project/CK/model/task.dart';
import 'package:uuid/uuid.dart';

class Repository {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  // User CRUD
  Future<void> createUser(User user) async {
    final db = await dbHelper.database;
    await db.insert('users', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<User?> getUser(String id) async {
    final db = await dbHelper.database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) return User.fromMap(maps.first);
    return null;
  }

  Future<void> updateUser(User user) async {
    final db = await dbHelper.database;
    await db.update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<void> deleteUser(String id) async {
    final db = await dbHelper.database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  Future<User?> loginUser(String username, String password) async {
    final db = await dbHelper.database;
    final maps = await db.query('users',
        where: 'username = ? AND password = ?', whereArgs: [username, password]);
    if (maps.isNotEmpty) return User.fromMap(maps.first);
    return null;
  }

  // Task CRUD
  Future<void> createTask(Task task) async {
    final db = await dbHelper.database;
    await db.insert('tasks', task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Task?> getTask(String id) async {
    final db = await dbHelper.database;
    final maps = await db.query('tasks', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) return Task.fromMap(maps.first);
    return null;
  }

  Future<void> updateTask(Task task) async {
    final db = await dbHelper.database;
    await db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<void> deleteTask(String id) async {
    final db = await dbHelper.database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Task>> searchTasks({
    String? keyword,
    String? status,
    int? priority,
    String? category,
    String? userId, // Thêm userId để lọc cho User thường
    bool isAdmin = false, // Thêm isAdmin để kiểm tra vai trò
  }) async {
    final db = await dbHelper.database;
    String query = 'SELECT * FROM tasks';
    List<String> whereClauses = [];
    List<dynamic> whereArgs = [];

    if (!isAdmin && userId != null) {
      // User thường chỉ thấy task được gán cho họ
      whereClauses.add('assignedTo = ?');
      whereArgs.add(userId);
    }

    if (keyword != null && keyword.isNotEmpty) {
      whereClauses.add('(title LIKE ? OR description LIKE ?)');
      whereArgs.add('%$keyword%');
      whereArgs.add('%$keyword%');
    }
    if (status != null) {
      whereClauses.add('status = ?');
      whereArgs.add(status);
    }
    if (priority != null) {
      whereClauses.add('priority = ?');
      whereArgs.add(priority);
    }
    if (category != null) {
      whereClauses.add('category = ?');
      whereArgs.add(category);
    }

    if (whereClauses.isNotEmpty) {
      query += ' WHERE ${whereClauses.join(' AND ')}';
    }

    final maps = await db.rawQuery(query, whereArgs);
    return maps.map((map) => Task.fromMap(map)).toList();
  }

  Future<List<User>> getAllUsers() async {
    final db = await dbHelper.database;
    final maps = await db.query('users');
    return maps.map((map) => User.fromMap(map)).toList();
  }
}