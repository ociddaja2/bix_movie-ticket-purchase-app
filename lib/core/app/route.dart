import 'package:flutter/material.dart';
import 'package:bixcinema/features/auth/presentation/splash_screen.dart';
import 'package:bixcinema/features/auth/presentation/login_page.dart';
import 'package:bixcinema/features/auth/presentation/register_page.dart';
import 'package:bixcinema/features/home/homepage.dart';
import 'package:bixcinema/features/home/location_page.dart';
import 'package:bixcinema/features/home/movie_list_page.dart';

class AppRoutes {
  // Nama-nama route
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String location = '/location';
  static const String movieList = '/movie-list';

  // Definisi routes
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginPage(),
      register: (context) => const RegisterPage(),
      home: (context) => const Homepage(),
      location: (context) => const LocationPage(),
      movieList: (context) => const MovieListPage(),
    };
  }
}