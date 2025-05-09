import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:test_project/CK/db/reposotory.dart';
import 'package:test_project/CK/model/user.dart';
import 'package:test_project/CK/view/task_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLogin = true;
  String? _selectedRole = 'user';
  final Repository _repo = Repository();
  final String _adminPassword = 'admin123';

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (_isLogin) {
          final user = await _repo.loginUser(
            _usernameController.text,
            _passwordController.text,
          );
          if (user != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TaskListScreen(currentUser: user),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid credentials')),
            );
          }
        } else {
          if (_selectedRole == 'admin' &&
              _passwordController.text != _adminPassword) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid admin password')),
            );
            return;
          }

          final user = User(
            id: const Uuid().v4(),
            username: _usernameController.text,
            password: _passwordController.text,
            email: _emailController.text,
            createdAt: DateTime.now(),
            lastActive: DateTime.now(),
            role: _selectedRole!,
          );
          await _repo.createUser(user);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TaskListScreen(currentUser: user),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('LoginScreen built');
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) =>
                value!.isEmpty ? 'Username is required' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value!.length < 6
                    ? 'Password must be at least 6 characters'
                    : null,
              ),
              if (!_isLogin) ...[
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) =>
                  !value!.contains('@') ? 'Invalid email' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: const InputDecoration(labelText: 'Role'),
                  items: ['user', 'admin']
                      .map((role) => DropdownMenuItem(
                    value: role,
                    child: Text(role == 'user' ? 'User' : 'Admin'),
                  ))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedRole = value),
                  validator: (value) =>
                  value == null ? 'Please select a role' : null,
                ),
                if (_selectedRole == 'admin')
                  const Text(
                    'Admin role requires password: admin123',
                    style: TextStyle(color: Colors.red),
                  ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(_isLogin ? 'Login' : 'Register'),
              ),
              TextButton(
                onPressed: () => setState(() => _isLogin = !_isLogin),
                child: Text(
                  _isLogin ? 'Create an account' : 'Already have an account?',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}