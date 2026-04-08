import 'package:flutter/material.dart';

class LoadAnimation extends StatelessWidget {
  const LoadAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Color.fromARGB(255, 5, 53, 125),
      ),
    );
  }
}