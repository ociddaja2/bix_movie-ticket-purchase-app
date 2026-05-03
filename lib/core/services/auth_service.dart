// lib/core/services/auth_service.dart
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bixcinema/core/services/firebase_service.dart';
import 'package:bixcinema/core/models/user_model.dart';

class AuthService {
  static UserModel? cachedUser;

  // login dengan email atau phone number
  static Future<Map<String, dynamic>> signIn({
    required String emailOrPhone,
    required String password,
  }) async {
    try {
      String email = emailOrPhone;
      
      // Cek apakah input adalah nomor telepon
      if (!emailOrPhone.contains('@')) {
        // Input adalah nomor telepon, cari email terkait
        final foundEmail = await FirebaseService.getUserEmailByPhoneNumber(emailOrPhone);
        
        if (foundEmail == null) {
          return {
            'success': false,
            'error': 'Nomor telepon tidak terdaftar. Silakan daftar terlebih dahulu.',
          };
        }
        email = foundEmail;
      }

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

  // register
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

  // logout
  static Future<void> signOut() async {
    await FirebaseService.signOut();
    cachedUser = null;
  }

  // get current user
  static Future<UserModel?> getCurrentUser() async {
    try {
      final authUser = FirebaseService.getCurrentAuthUser();
      if (authUser == null) return null;

      return await FirebaseService.getCurrentUser(authUser.uid);
    } catch (e) {
      return null;
    }
  }

  // auth state changes stream
  static Stream<User?> authStateChanges() {
    return FirebaseService.authStateChanges();
  }

  // get cached user
  static UserModel? getCachedUser() {
    return cachedUser;
  }

  // forgot password
  static Future<Map<String, dynamic>> forgotPassword({
    required String emailOrPhone,
  }) async {
    try {
      await FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: true);

      String email = emailOrPhone;
      
      // Cek apakah input adalah nomor telepon
      if (!emailOrPhone.contains('@')) {
        // Input adalah nomor telepon, cari email terkait
        final foundEmail = await FirebaseService.getUserEmailByPhoneNumber(emailOrPhone);
        
        if (foundEmail == null) {
          return {
            'success': false,
            'error': 'Nomor telepon tidak terdaftar.',
          };
        }
        email = foundEmail;
      }

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      return {
        'success': true,
        'message': 'Link reset password telah dikirim ke email Anda.',
      };
    } catch (e) {
      print('Error in forgotPassword: $e');
      return {
        'success': false,
        'error': e.toString().replaceAll('Exception: ', ''),
      };
    }
  }
}