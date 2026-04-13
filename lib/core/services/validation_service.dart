// lib/core/services/validation_service.dart
class ValidationService {
  // Validasi email atau phone
  static String? validateEmailOrPhone(String value) {
    if (value.isEmpty) {
      return 'Email atau nomor WhatsApp wajib diisi';
    }
    
    // Cek apakah email
    if (value.contains('@')) {
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        return 'Format email tidak valid';
      }
    } 
    // Cek apakah nomor
    else if (!RegExp(r'^(?:\+62|0)[0-9]{9,12}$').hasMatch(value)) {
      return 'Nomor WhatsApp tidak valid (gunakan format 08... atau +62...)';
    }
    
    return null;
  }

  // Validasi password
  static String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password wajib diisi';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }
}