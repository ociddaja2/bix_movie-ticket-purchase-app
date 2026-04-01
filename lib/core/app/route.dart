import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../pages/auth/splash_screen.dart';
import '../../pages/auth/login_page.dart';
import '../../pages/auth/register_page.dart';
import '../../pages/home/homepage.dart';
import '../../pages/home/location_page.dart';
import '../../pages/home/movie_list_page.dart';
import '../../pages/home/booking_page.dart';
import '../../pages/home/profile_page.dart';
import '../../ui/widgets/navbar.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class AppRoutes {
  // Nama-nama route (sebagai konstanta agar tidak typo)
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String location = '/location';
  static const String movieList = '/movie-list';
  static const String booking = '/booking';
  static const String profile = '/profile';

  // Fungsi untuk mendapatkan index navbar berdasarkan location
  static int _getNavbarIndex(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/booking')) return 1;
    if (location.startsWith('/profile')) return 2;
    return 0;
  }

  // Konfigurasi GoRouter
  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen()
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginPage()
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: location,
        builder: (context, state) => const LocationPage(),
      ),
      GoRoute(
        path: movieList,
        builder: (context, state) => const MovieListPage(),
      ),

      // fungsi navbar di page dgn navbar
      ShellRoute(
        builder: (context, state, child) {
          return Scaffold(
            body: child,
            bottomNavigationBar: Navbar(
              currentIndex: _getNavbarIndex(state.fullPath ?? ''),
            ),
          );
        },
        routes: [
          GoRoute(
            path: home,
            builder: (context, state) => const Homepage()
          ),
          GoRoute(
            path: booking,
            builder: (context, state) => const BookingPage(),
          ),
          GoRoute(
            path: profile,
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
  );
}
