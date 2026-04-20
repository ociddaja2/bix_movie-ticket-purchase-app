// lib/core/services/auth_service.dart
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bixcinema/core/services/firebase_service.dart';
import 'package:bixcinema/core/models/user_model.dart';

class AuthService {
  static UserModel? cachedUser;

  // ============= LOGIN =============
  static Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await FirebaseService.signInWithEmailPassword(
        email: email,
        password: password,
      );

      // Fetch user data dari Firestore
      final userData = await FirebaseService.getCurrentUser(userCredential.user!.uid);
      
      // Cache user data
      cachedUser = userData;

      return {
        'success': true,
        'user': userData,
        'message': 'Login berhasil',
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString().replaceAll('Exception: ', ''),
      };
    }
  }

  // ============= REGISTER =============
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    try {
      // Cek email sudah ada
      // final emailAlreadyExists = await FirebaseService.emailExists(email);
      // if (emailAlreadyExists) {
      //   return {
      //     'success': false,
      //     'error': 'Email sudah terdaftar',
      //   };
      // }

      final userCredential = await FirebaseService.registerWithEmailPassword(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
      );

      // Fetch user data baru
      final userData = await FirebaseService.getCurrentUser(userCredential.user!.uid);
      cachedUser = userData;

      return {
        'success': true,
        'user': userData,
        'message': 'Registrasi berhasil. Silakan login.',
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString().replaceAll('Exception: ', ''),
      };
    }
  }

  // ============= LOGOUT =============
  static Future<void> signOut() async {
    await FirebaseService.signOut();
    cachedUser = null;
  }

  // ============= GET CURRENT USER =============
  static Future<UserModel?> getCurrentUser() async {
    try {
      final authUser = FirebaseService.getCurrentAuthUser();
      if (authUser == null) return null;

      return await FirebaseService.getCurrentUser(authUser.uid);
    } catch (e) {
      return null;
    }
  }

  // ============= AUTH STATE STREAM =============
  static Stream<User?> authStateChanges() {
    return FirebaseService.authStateChanges();
  }

  // ============= GET CACHED USER =============
  static UserModel? getCachedUser() {
    return cachedUser;
  }
}