// ignore_for_file: unused_import

import 'package:bixcinema/core/providers/city_teater_provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bixcinema/core/app/route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'dart:io';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  // Tambahan untuk mengatasi masalah sertifikat SSL (saat menggunakan Api ImgBB)
  // HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CityTeaterProvider()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: true,
        title: 'BixCinema',
        routerConfig: AppRoutes.router,
      ),
    );
  }
}

// Tambahan untuk mengatasi masalah sertifikat SSL (saat menggunakan Api ImgBB)
// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
//   }
// }