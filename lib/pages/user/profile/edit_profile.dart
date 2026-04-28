import 'package:bixcinema/ui/widgets/appbar_2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: BixAppBar.subtitle(
          title: 'Edit Profile',
          subtitle: 'Ubah informasi profil Anda',
          onBack: () => context.go('/profile'),
        ),
        body: const Center(
          child: Text('This is the Edit Profile Page'),
        ),
      ),

    );
  }
}