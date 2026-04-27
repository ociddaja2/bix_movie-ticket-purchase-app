import 'package:bixcinema/core/providers/city_teater_provider.dart';
import 'package:flutter/material.dart';
import 'package:bixcinema/core/app/route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
// import 'package:provider/provider.dart';


void main() async {
  
  try {
  // Inisialisasi Firebase 
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  final cityTeaterProvider = CityTeaterProvider();
  await cityTeaterProvider.initialize();

  runApp(MyApp(cityTeaterProvider: cityTeaterProvider));
}

class MyApp extends StatelessWidget {
  final CityTeaterProvider cityTeaterProvider;

  const MyApp({required this.cityTeaterProvider, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CityTeaterProvider>.value(
      value: cityTeaterProvider,
      child: MaterialApp.router(
      debugShowCheckedModeBanner: true,
      title: 'BixCinema',
      routerConfig: AppRoutes.router,
      )
    );
  }
}
