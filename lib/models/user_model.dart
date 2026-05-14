class UserModel {
  final int id;
  final String name;
  final String username;
  final String roleName;
  final String className;
  final String token;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.roleName,
    required this.className,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};
    final role = user['role'] ?? {};
    final cls = user['class'] ?? {};

    return UserModel(
      id: user['id'] ?? 0,
      name: user['name'] ?? '',
      username: user['username'] ?? '',
      roleName: role['name'] ?? '',
      className: cls['name'] ?? '',
      token: json['token'] ?? '',
    );
  }
}
