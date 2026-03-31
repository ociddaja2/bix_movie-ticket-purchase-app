import 'package:flutter/material.dart';
import 'package:bixcinema/features/auth/presentation/splash_screen.dart';
import 'package:bixcinema/features/auth/presentation/login_page.dart';
import 'package:bixcinema/features/auth/presentation/register_page.dart';
import 'package:bixcinema/features/home/homepage.dart';
import 'package:bixcinema/features/home/location_page.dart';
import 'package:bixcinema/features/home/movie_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // Set splash screen as home
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const Homepage(),
        '/location': (context) => const LocationPage(),
        '/movie-list': (context) => const MovieListPage(),
      },
    );
  }
}
