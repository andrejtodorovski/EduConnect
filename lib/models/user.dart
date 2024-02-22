class MyUser {
  final String id;
  final String username;
  final String password;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String role; // tutor ili student
  final String imageUrl;

  MyUser(
      {required this.id,
      required this.username,
      required this.password,
      required this.firstName,
      required this.lastName,
      required this.role,
      required this.phoneNumber,
      this.imageUrl = 'No image'});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
    };
  }

  static MyUser fromJson(Map<String, dynamic> json) {
    return MyUser(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      role: json['role'],
      phoneNumber: json['phoneNumber'],
      imageUrl: json['imageUrl'] ?? 'No image'
    );
  }
}
