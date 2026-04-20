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

  // ============= REGISTER VALIDATIONS =============

  // Validasi full name
  static String? validateFullName(String value) {
    if (value.isEmpty) {
      return 'Nama lengkap wajib diisi';
    }
    if (value.length < 3) {
      return 'Nama lengkap minimal 3 karakter';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Nama hanya boleh berisi huruf dan spasi';
    }
    return null;
  }

  // Validasi phone number
  static String? validatePhoneNumber(String value) {
    if (value.isEmpty) {
      return 'Nomor telepon wajib diisi';
    }
    if (!RegExp(r'^(?:\+62|0)[0-9]{9,12}$').hasMatch(value)) {
      return 'Nomor telepon tidak valid (gunakan format 08... atau +62...)';
    }
    return null;
  }

  // Validasi email
  static String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email wajib diisi';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  // Validasi password strength untuk register
  static String? validatePasswordStrength(String value) {
    if (value.isEmpty) {
      return 'Password wajib diisi';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
      return 'Password harus mengandung huruf (a-z, A-Z)';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password harus mengandung angka (0-9)';
    }
    return null;
  }

  // Validasi confirm password
  static String? validateConfirmPassword(
    String password,
    String confirmPassword,
  ) {
    if (confirmPassword.isEmpty) {
      return 'Konfirmasi password wajib diisi';
    }
    if (password != confirmPassword) {
      return 'Konfirmasi password tidak sesuai dengan password';
    }
    return null;
  }
}
