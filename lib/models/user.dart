class User {
  final String id;
  final String username;
  final String password;
  final String name;
  final String role; // tutor ili student

  User({required this.id, required this.username, required this.password, required this.name, required this.role});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'name': name,
      'role': role,
    };
  }

  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      name: json['name'],
      role: json['role'],
    );
  }
}
