import 'package:flutter/material.dart';
import 'package:bixcinema/ui/widgets/backgroundLoginWidget.dart';
import 'package:bixcinema/ui/widgets/logoBoxWidget.dart';
import 'package:bixcinema/core/services/auth_service.dart';
import 'package:bixcinema/core/services/validation_service.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text Editing Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // State variables
  bool _isLoading = false;
  bool _showPasswordError = false;
  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            // Background circles
            const DecorativeCirclesBackground(),

            // Main scrollable content
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Button back
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            hoverColor: Colors.transparent,
                            onPressed: () => context.pop(),
                            icon: const Icon(Icons.arrow_back),
                            color: Colors.black,
                            iconSize: 48,
                          ),
                        ),
                        const SizedBox(height: 10),

                        const Text(
                          'Selamat datang di\nBIX Cinema',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 12),

                        const Text(
                          'Isi Data Dibawah untuk membuat akun baru\nBix Cinema kamu',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 30),

                        const Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Nama Lengkap ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black, // Warna teks utama
                                ),
                              ),
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red, // Warna bintang merah
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hoverColor: Colors.transparent,
                            labelText: 'Masukkan Nama Lengkap',
                            labelStyle: const TextStyle(color: Colors.black54),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF003D82),
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        const Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Nomor Telepon ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black, // Warna teks utama
                                ),
                              ),
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red, // Warna bintang merah
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hoverColor: Colors.transparent,
                            labelText: 'Masukkan Nomor (08... atau +62...)',
                            labelStyle: const TextStyle(color: Colors.black54),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF003D82),
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        
                        const Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Email ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black, // Warna teks utama
                                ),
                              ),
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red, // Warna bintang merah
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hoverColor: Colors.transparent,
                            labelText: 'Masukkan Email',
                            labelStyle: const TextStyle(color: Colors.black54),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF003D82),
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        const Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Password ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black, // Warna teks utama
                                ),
                              ),
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red, // Warna bintang merah
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          onChanged: (_) {
                            // Update password error ketika user ketik
                            setState(() {
                              _passwordError =
                                  ValidationService.validatePasswordStrength(
                                    _passwordController.text,
                                  );
                              _showPasswordError = _passwordError != null;
                            });
                          },
                          decoration: InputDecoration(
                            hoverColor: Colors.transparent,
                            labelText: 'Masukkan Password',
                            labelStyle: const TextStyle(color: Colors.black54),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: _showPasswordError
                                    ? Colors.red
                                    : Colors.black,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: _showPasswordError
                                    ? Colors.red
                                    : const Color(0xFF003D82),
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Password requirements
                        if (_showPasswordError && _passwordError != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              _passwordError!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                        // Password hints
                        const Text(
                          'Password Wajib Memiliki:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _PasswordRequirementItem(
                          text: 'Minimal 6 karakter',
                          isMet: _passwordController.text.length >= 6,
                        ),
                        const SizedBox(height: 4),
                        _PasswordRequirementItem(
                          text: 'Mengandung huruf (a-z, A-Z)',
                          isMet: RegExp(
                            r'[a-zA-Z]',
                          ).hasMatch(_passwordController.text),
                        ),
                        const SizedBox(height: 4),
                        _PasswordRequirementItem(
                          text: 'Mengandung angka (0-9)',
                          isMet: RegExp(
                            r'[0-9]',
                          ).hasMatch(_passwordController.text),
                        ),
                        const SizedBox(height: 16),

                       const Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Konfirmasi Password ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black, // Warna teks utama
                                ),
                              ),
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red, // Warna bintang merah
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hoverColor: Colors.transparent,
                            labelText: 'Konfirmasi Password',
                            labelStyle: const TextStyle(color: Colors.black54),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF003D82),
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // ============= Register Button =============
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleRegister,
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.transparent,
                              backgroundColor: const Color(0xFF003D82),
                              disabledBackgroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Daftar',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Back to login link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Sudah punya akun?  ',
                              style: TextStyle(fontSize: 14),
                            ),
                            GestureDetector(
                              onTap: () => context.pop(),
                              child: const Text(
                                'Masuk Disini',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF003D82),
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),

                  // Logo at the bottom
                  LogoBox(imagePath: 'lib/assets/images/icons/iconbix.png'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============= HANDLE REGISTER =============
  Future<void> _handleRegister() async {
    // Validasi semua field
    final nameError = ValidationService.validateFullName(_nameController.text);
    final phoneError = ValidationService.validatePhoneNumber(
      _phoneController.text,
    );
    final emailError = ValidationService.validateEmail(_emailController.text);
    final passwordError = ValidationService.validatePasswordStrength(
      _passwordController.text,
    );
    final confirmPasswordError = ValidationService.validateConfirmPassword(
      _passwordController.text,
      _confirmPasswordController.text,
    );

    // Jika ada error, tampilkan
    if (nameError != null ||
        phoneError != null ||
        emailError != null ||
        passwordError != null ||
        confirmPasswordError != null) {
      _showErrorDialog(
        'Validasi Gagal',
        nameError ??
            phoneError ??
            emailError ??
            passwordError ??
            confirmPasswordError ??
            'Error tidak diketahui',
      );
      return;
    }

    // Set loading state
    setState(() {
      _isLoading = true;
    });

    // Call AuthService.register
    final result = await AuthService.register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      fullName: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
    );

    // Stop loading
    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    // Handle response
    if (result['success']) {
      _showSuccessDialog(
        'Registrasi Berhasil',
        'Akun Anda telah dibuat. Silakan login dengan email dan password Anda.',
        () {
          context.pop(); // Back to login page
        },
      );
    } else {
      _showErrorDialog(
        'Registrasi Gagal',
        result['error'] ?? 'Terjadi kesalahan yang tidak diketahui',
      );
    }
  }

  // ============= DIALOG HELPERS =============
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String title, String message, VoidCallback onOk) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onOk();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

// ============= PASSWORD REQUIREMENT ITEM WIDGET =============
class _PasswordRequirementItem extends StatelessWidget {
  final String text;
  final bool isMet;

  const _PasswordRequirementItem({required this.text, required this.isMet});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 16,
          color: isMet ? Colors.green : Colors.black54,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: isMet ? Colors.green : Colors.black54,
            fontWeight: isMet ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
