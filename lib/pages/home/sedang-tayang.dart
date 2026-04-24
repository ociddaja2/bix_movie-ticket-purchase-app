import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SedangTayangPage extends StatelessWidget {
  const SedangTayangPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sedang Tayang'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
      body: const Center(
        child: Text('This is the Sedang Tayang Page'),
      ),
    );
  }
}