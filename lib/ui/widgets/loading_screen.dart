import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BixLoadingScreen extends StatefulWidget {
  const BixLoadingScreen({super.key});

  @override
  State<BixLoadingScreen> createState() => _BixLoadingScreenState();
}

class _BixLoadingScreenState extends State<BixLoadingScreen>
    with TickerProviderStateMixin {
  // Rotation controller for the spinning arc
  late AnimationController _rotationController;

  // Pulse / scale controller for the logo
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Fade-in controller for the whole widget
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Continuously spinning arc
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    // Subtle logo pulse (scale 1.0 → 1.06 → 1.0)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Fade-in on load
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      // Navigate to home after loading
      context.go('/home');
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: SizedBox(
            width: 140,
            height: 140,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // ── Outer soft glow ring ──────────────────────────────────
                Container(
                  width: 128,
                  height: 128,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1A2E6E).withOpacity(0.12),
                        blurRadius: 24,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                ),

                // ── Spinning arc indicator ────────────────────────────────
                AnimatedBuilder(
                  animation: _rotationController,
                  builder: (_, _) {
                    return Transform.rotate(
                      angle: _rotationController.value * 2 * pi,
                      child: CustomPaint(
                        size: const Size(128, 128),
                        painter: _ArcPainter(),
                      ),
                    );
                  },
                ),

                // ── Static background circle (thin track) ────────────────
                CustomPaint(
                  size: const Size(128, 128),
                  painter: _TrackPainter(),
                ),

                // ── Pulsing BIX logo ──────────────────────────────────────
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A2E6E),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1A2E6E).withOpacity(0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                     
                        Image.asset(
                          'lib/assets/images/bixcinema.png',
                          width: 60,
                          height: 60,
                        ),
                       
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Thin grey track (background circle) ─────────────────────────────────────
class _TrackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE8ECF4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2 - 2,
      paint,
    );
  }

  @override
  bool shouldRepaint(_TrackPainter old) => false;
}

// ── Spinning arc (uses a sweep gradient for a comet-tail effect) ─────────────
class _ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // Gradient: transparent → brand blue → bright accent
    final gradient = SweepGradient(
      startAngle: 0,
      endAngle: 2 * pi,
      colors: const [
        Colors.transparent,
        Color(0xFF1A2E6E),
        Color(0xFF3D5DCC),
        Colors.transparent,
      ],
      stops: const [0.0, 0.5, 0.85, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    // Draw ~270° arc
    canvas.drawArc(rect, -pi / 2, 1.5 * pi, false, paint);
  }

  @override
  bool shouldRepaint(_ArcPainter old) => false;
}