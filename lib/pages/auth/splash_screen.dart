import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeZoomController;
  late AnimationController _separateController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _bixSeparateAnimation;
  late Animation<Offset> _cinemaSeparateAnimation;

  @override
  void initState() {
    super.initState();

    // Controller untuk animasi slide "BIX"
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Controller untuk animasi fade + zoom "cinema"
    _fadeZoomController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Controller untuk animasi pemisahan (BIX ke atas, cinema ke bawah)
    _separateController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Animasi slide dari kiri ke tengah
    _slideAnimation =
        Tween<Offset>(
          begin: const Offset(-1.5, 0), // Mulai dari kiri layar
          end: Offset.zero, // Berakhir di tengah
        ).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    // Animasi fade in untuk "cinema"
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeZoomController, curve: Curves.easeIn),
    );

    // Animasi zoom out (dari besar ke normal) untuk "cinema"
    _scaleAnimation =
        Tween<double>(
          begin: 1.5, // Mulai dari 1.5x ukuran normal (besar)
          end: 1.0, // Berakhir di ukuran normal
        ).animate(
          CurvedAnimation(
            parent: _fadeZoomController,
            curve: Curves.easeOutBack,
          ),
        );

    // Animasi "BIX" naik ke atas
    _bixSeparateAnimation =
        Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0, -8), // Naik ke atas (keluar layar)
        ).animate(
          CurvedAnimation(
            parent: _separateController,
            curve: Curves.easeInCubic,
          ),
        );

    // Animasi "cinema" turun ke bawah
    _cinemaSeparateAnimation =
        Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0, 12), // Turun ke bawah (keluar layar)
        ).animate(
          CurvedAnimation(
            parent: _separateController,
            curve: Curves.easeInCubic,
          ),
        );

    // Jalankan animasi secara berurutan
    _startAnimations();
  }

  void _startAnimations() async {
    //tunggu sebentar sebelum mulai animasi, buat bg
    await Future.delayed(const Duration(milliseconds: 500));
    //Mulai animasi slide "BIX"
    await _slideController.forward();

    //Delay sebentar
    await Future.delayed(const Duration(milliseconds: 200));

    //Mulai animasi fade + zoom "cinema"
    await _fadeZoomController.forward();

    //Tunggu sebentar
    await Future.delayed(const Duration(milliseconds: 800));

    //Animasi pemisahan (BIX ke atas, cinema ke bawah)
    await _separateController.forward();

    //Navigate ke Homepage menggunakan go_router
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeZoomController.dispose();
    _separateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 42, 120),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animasi "BIX" slide dari kiri + naik ke atas
            SlideTransition(
              position: _slideAnimation,
              child: SlideTransition(
                position: _bixSeparateAnimation,
                child: Image.asset(
                  'lib/assets/images/icons/bixaja.png',
                  width: 200,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Animasi "cinema" fade in + zoom out + turun ke bawah
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: SlideTransition(
                  position: _cinemaSeparateAnimation,
                  child: Image.asset('lib/assets/images/icons/cinemanya.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
