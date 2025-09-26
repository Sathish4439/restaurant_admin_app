class User {
  final int id;
  final String name;
  final String email;
  final String password;
  final String role;
  final String imageUrl;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.imageUrl,
    required this.role, // default
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now(); // default

  /// Convert JSON to User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      role: json['role'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  /// Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static final User nullUser = User(
    id: 0,
    name: "NA",
    email: "NA",
    password: "NA",
    imageUrl: "NA",
    role: "NA",
  );
}
