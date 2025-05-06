import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._();

  static DatabaseHelper get instance => _instance ??= DatabaseHelper._();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'task_manager.db');
    return await openDatabase(
      path,
      version: 2, // Tăng version để chạy onUpgrade
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id TEXT PRIMARY KEY,
            username TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL,
            email adv TEXT NOT NULL UNIQUE,
            createdAt DATETIME NOT NULL,
            lastActive DATETIME NOT NULL,
            role TEXT NOT NULL DEFAULT 'user' -- Thêm cột role
          )
        ''');
        await db.execute('''
          CREATE TABLE tasks (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            status TEXT NOT NULL,
            priority INTEGER NOT NULL,
            dueDate DATETIME,
            createdAt DATETIME NOT NULL,
            updatedAt DATETIME NOT NULL,
            assignedTo TEXT,
            createdBy TEXT NOT NULL,
            category TEXT,
            attachments TEXT,
            completed INTEGER NOT NULL,
            FOREIGN KEY (assignedTo) REFERENCES users(id) ON DELETE SET NULL,
            FOREIGN KEY (createdBy) REFERENCES users(id) ON DELETE CASCADE
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE users ADD COLUMN role TEXT NOT NULL DEFAULT "user"');
        }
      },
    );
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}