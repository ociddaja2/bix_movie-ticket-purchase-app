// lib/core/services/storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StorageService {
  static const String _emailKey = 'remembered_email';
  static const String _rememberMeKey = 'remember_me';

  // Simpan credentials jika remember me dicentang
  static Future<void> saveLoginCredentials({
    required String email,
    required bool rememberMe,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString(_emailKey, email);
      await prefs.setBool(_rememberMeKey, true);
    } else {
      await prefs.remove(_emailKey);
      await prefs.setBool(_rememberMeKey, false);
    }
  }

  // Ambil saved email
  static Future<String?> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  // Cek apakah remember me aktif
  static Future<bool> isRememberMeEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? false;
  }

  // Clear saved credentials
  static Future<void> clearSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_emailKey);
    await prefs.remove(_rememberMeKey);
  }
}