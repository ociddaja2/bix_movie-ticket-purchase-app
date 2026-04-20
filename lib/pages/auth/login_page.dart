import 'package:bixcinema/core/app/route.dart';
import 'package:bixcinema/core/services/auth_service.dart';
import 'package:bixcinema/core/services/validation_service.dart';
import 'package:bixcinema/ui/widgets/backgroundLoginWidget.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core_dart/firebase_core_dart.dart';
import 'package:flutter/material.dart';
import 'package:bixcinema/ui/widgets/logoBoxWidget.dart';
import 'package:go_router/go_router.dart';
import 'package:bixcinema/core/services/storage_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      resizeToAvoidBottomInset:
          false, // Ini yang membuat layout tidak bergeser saat keyboard muncul
      body: SafeArea(
        child: Stack(
          children: [
            // Bulatan-bulatan dekoratif
            const DecorativeCirclesBackground(),

            // Logo BIX Cinema di dalam scroll (ikut scroll, muncul paling bawah)
            LogoBox(imagePath: 'lib/assets/images/icons/iconbix.png'),

            // Main content
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 60),

                        // Welcome text
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
                          'Nikmati pengalaman menonton yang nyaman dan\npenuh cerita di setiap momen.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Input Form disini

                        // Email field
                        const Text(
                          'Email or WhatsApp Number',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 8),

                        TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email atau nomor tidak boleh kosong';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hoverColor: Colors.transparent,
                            labelText: 'Masukkan Email Atau Nomor',
                            labelStyle: TextStyle(color: Colors.black54),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.black),
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
                        const SizedBox(height: 20),

                        // Password field
                        const Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),

                        TextFormField(
                          controller: _passwordController,
                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Password tidak boleh kosong'
                              : null,
                          obscureText: true,
                          decoration: InputDecoration(
                            hoverColor: Colors.transparent,
                            labelText: 'Masukkan Password',
                            labelStyle: TextStyle(color: Colors.black54),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.black),
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

                        const SizedBox(height: 12),

                        // Remember me checkbox
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Remember me',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Login button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    // 1. Validasi input
                                    final emailError =
                                        ValidationService.validateEmailOrPhone(
                                          _emailController.text,
                                        );
                                    final passwordError =
                                        ValidationService.validatePassword(
                                          _passwordController.text,
                                        );

                                    if (emailError != null ||
                                        passwordError != null) {
                                      // Tampilkan error dialog
                                      _showErrorDialog(
                                        'Validasi Gagal',
                                        emailError ??
                                            passwordError ??
                                            'Error tidak diketahui',
                                      );
                                      return;
                                    }

                                    // Set loading state
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    // 2. Simpan credentials jika remember me dicentang
                                    await StorageService.saveLoginCredentials(
                                      email: _emailController.text,
                                      rememberMe: _rememberMe,
                                    );

                                    // 3. Login dengan AuthService
                                    final result = await AuthService.signIn(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    );

                                    // Stop loading
                                    setState(() {
                                      _isLoading = false;
                                    });

                                    if (result['success']) {
                                      // Tampilkan success dialog sebelum navigate
                                      if (mounted) {
                                        _showSuccessDialog(
                                          'Login Berhasil',
                                          'Selamat datang kembali! Anda akan dialihkan ke halaman utama.',
                                          () {
                                            // Navigate ke loading screen
                                            // ignore: use_build_context_synchronously
                                            context.go(AppRoutes.loading);
                                          },
                                        );
                                      }
                                    } else {
                                      // Tampilkan error dialog
                                      if (mounted) {
                                        _showErrorDialog(
                                          'Login Gagal',
                                          result['error'] ??
                                              'Terjadi kesalahan yang tidak diketahui',
                                        );
                                      }
                                    }
                                  },
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
                                    'Masuk',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Sign up link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Belum punya akun?  ',
                              style: TextStyle(fontSize: 14),
                            ),
                            GestureDetector(
                              onTap: () => context.push('/register'),
                              child: Text(
                                'Daftar Disini',
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

  void _showSuccessDialog(
    String title,
    String message,
    VoidCallback onOk,
  ) {
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
