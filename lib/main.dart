import 'package:flutter/material.dart';
import 'package:bixcinema/app/pages/splash_screen.dart';
import 'package:bixcinema/app/pages/login_page.dart';
import 'package:bixcinema/app/pages/register_page.dart';
import 'package:bixcinema/app/pages/home/homepage.dart';

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
      },
    );
  }
}
