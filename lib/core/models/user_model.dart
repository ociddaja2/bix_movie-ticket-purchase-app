import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String phoneNumber;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  final String role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.avatarUrl,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,

    required this.role,
  });


  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: (json['created_at']?.toDate()) ?? DateTime.now(),
      updatedAt: (json['updated_at']?.toDate()) ?? DateTime.now(),

      role: json['role'] as String? ?? 'user',
    );
  }

  static fromFirebaseUser(User user) {}
}

Map<String, dynamic> userToJson(UserModel user) {
  return {
    'id': user.id,
    'name': user.name,
    'email': user.email,
    'password': user.password,
    'phoneNumber': user.phoneNumber,
    'avatarUrl': user.avatarUrl,
    'created_at': user.createdAt.toIso8601String(),
    'updated_at': user.updatedAt.toIso8601String(),

    'role': user.role,
  };
}