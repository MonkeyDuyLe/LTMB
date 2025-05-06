import 'package:flutter/material.dart';
import 'package:test_project/CK/db/DatabaseHelper.dart';
import 'package:test_project/CK/view/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Khởi tạo database trước khi chạy ứng dụng
    await DatabaseHelper.instance.database;
  } catch (e) {
    print('Error initializing database: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}