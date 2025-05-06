class User {
  final String id;
  final String username;
  final String password;
  final String email;
  final DateTime createdAt;
  final DateTime lastActive;
  final String role; // Thêm role

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.email,
    required this.createdAt,
    required this.lastActive,
    this.role = 'user', // Mặc định là user
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
      'lastActive': lastActive.toIso8601String(),
      'role': role,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      email: map['email'],
      createdAt: DateTime.parse(map['createdAt']),
      lastActive: DateTime.parse(map['lastActive']),
      role: map['role'] ?? 'user', // Đảm bảo tương thích với dữ liệu cũ
    );
  }
}