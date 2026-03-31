import 'package:flutter/material.dart';

class MovieListPage extends StatelessWidget {
  const MovieListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie List'),
      ),
      body: const Center(
        child: Text('This is the Movie List Page'),
      ),
    );
  }
}