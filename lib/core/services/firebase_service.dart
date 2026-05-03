// lib/core/services/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bixcinema/core/models/user_model.dart';

class FirebaseService {
  // Singleton instances
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Sign In dengan Email dan Password
  static Future<UserCredential> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Register dengan Email dan Password
  static Future<UserCredential> registerWithEmailPassword({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    try {
      // 1. Buat user di Firebase Auth
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Simpan data user di Firestore 
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'id': userCredential.user!.uid,
        'name': fullName,
        'email': email,
        // 'password': password,
        'phoneNumber': phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Sign Out
  static Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// Get Current User by UID
  static Future<UserModel?> getCurrentUser(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();

      if (docSnapshot.exists) {
        return UserModel.fromJson(docSnapshot.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

  /// Check Email Already Exists
  // static Future<bool> emailExists(String email) async {
  //   try {
  //     final result = await _firestore
  //         .collection('users')
  //         .where('email', isEqualTo: email)
  //         .limit(1)
  //         .get();

  //     return result.docs.isNotEmpty;
  //   } catch (e) {
  //     throw Exception('Error checking email: $e');
  //   }
  // }

  /// Get Auth State Changes Stream
  static Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }

  /// Get Current User from Firebase Auth
  static User? getCurrentAuthUser() {
    return _firebaseAuth.currentUser;
  }

  /// Update Password
  static Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      
      if (user == null || user.email == null) {
        throw Exception('User tidak ditemukan');
      }
      
      // Re-authenticate dengan password lama (Firebase requirement)
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      
      await user.reauthenticateWithCredential(credential);
      
      // Update password ke yang baru
      await user.updatePassword(newPassword);
      
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Handle Firebase Auth Exceptions
  static Exception _handleAuthException(FirebaseAuthException e) {
    String message;

    switch (e.code) {
      case 'user-not-found':
        message = 'Email tidak terdaftar. Silakan daftar terlebih dahulu.';
        break;
      case 'wrong-password':
        message = 'Password yang Anda masukkan salah.';
        break;
      case 'invalid-email':
        message = 'Format email tidak valid.';
        break;
      case 'user-disabled':
        message = 'Akun Anda telah dinonaktifkan oleh admin.';
        break;
      case 'email-already-in-use':
        message = 'Email sudah terdaftar di sistem kami.';
        break;
      case 'weak-password':
        message = 'Password terlalu lemah. Gunakan kombinasi huruf dan angka.';
        break;
      case 'operation-not-allowed':
        message = 'Operasi authentication tidak diizinkan.';
        break;
      case 'too-many-requests':
        message = 'Terlalu banyak percobaan gagal. Coba beberapa saat lagi.';
        break;
      case 'invalid-credential':
        message = 'Email atau password tidak valid.';
        break;
      default:
        message = 'Terjadi kesalahan: ${e.message}';
    }

    return Exception(message);
  }

  /// Get user email by phone number
  static Future<String?> getUserEmailByPhoneNumber(String phoneNumber) async {
    try {
      final result = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (result.docs.isNotEmpty) {
        return result.docs.first.data()['email'] as String?;
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching user by phone: $e');
    }
  }

  /// Send Password Reset Email
  static Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Update User Avatar URL
  static Future<void> updateUserAvatar(String userId, String avatarUrl) async {
    try {
      await _firestore
        .collection('users')
        .doc(userId).update({
        'avatarUrl': avatarUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error updating avatar: $e');
    }
  }
}