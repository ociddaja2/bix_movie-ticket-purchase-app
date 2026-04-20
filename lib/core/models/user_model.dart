class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String phoneNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
  });


  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      createdAt: (json['created_at']?.toDate()) ?? DateTime.now(),
      updatedAt: (json['updated_at']?.toDate()) ?? DateTime.now(),
    );
  }
}

Map<String, dynamic> userToJson(UserModel user) {
  return {
    'id': user.id,
    'name': user.name,
    'email': user.email,
    'password': user.password,
    'phone_number': user.phoneNumber,
    'created_at': user.createdAt.toIso8601String(),
    'updated_at': user.updatedAt.toIso8601String(),
  };
}