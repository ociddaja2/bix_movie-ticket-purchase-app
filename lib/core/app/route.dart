import 'package:bixcinema/core/models/tayang_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../pages/auth/splash_screen.dart';
import '../../pages/auth/login_page.dart';
import '../../pages/auth/register_page.dart';
import '../../pages/home/homepage.dart';
import '../../pages/home/location_page.dart';
import '../../pages/home/sedang_tayang.dart';
import '../../pages/home/booking_page.dart';
import '../../pages/home/profile_page.dart';
import '../../ui/widgets/navbar.dart';
import '../../pages/home/session/movie_detail_page.dart';
import 'package:bixcinema/core/models/movie_model.dart';
import '../../ui/widgets/loading_screen.dart';
import '../../pages/home/coming_soon.dart';

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
  static const String movieDetail = '/movie-detail';
  static const String loading = '/loading';
  static const String sedangTayang = '/sedang-tayang';
  static const String comingSoon = '/coming-soon';

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

      GoRoute(path: sedangTayang,
        builder: (context, state) => const SedangTayangPage(),
      ),
      GoRoute(path: comingSoon,
        builder: (context, state) => const ComingSoonPage(),
      ),
      GoRoute(path: loading,
        builder: (context, state) => const BixLoadingScreen(),
      ),
      GoRoute(path: movieDetail,
      // builder: (context, state) => MovieDetailPage(movie: state.extra as MovieModel),
      // builder: (context, state) => const MovieDetailPage(),
        builder: (context, state) {
          final id = state.uri.queryParameters['id'];
          if (id == null) {
            return Scaffold(
              appBar: AppBar(title: Text('Error')),
              body: Center(child: Text('Movie ID is missing')),
            );
          }
          final params = state.extra as MovieDetailParams;


          return MovieDetailPage(id: id, movie: params.movie, tayang: params.tayang,);
        },
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

class MovieDetailParams {
  final MovieModel movie;
  final TayangModel tayang;
  
  MovieDetailParams({
    required this.movie,
    required this.tayang,
  });
}