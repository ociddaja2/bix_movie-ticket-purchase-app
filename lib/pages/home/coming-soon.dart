import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coming Soon'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
      body: const Center(
        child: Text('This is the Coming Soon Page'),
      ),
    );
  }
}