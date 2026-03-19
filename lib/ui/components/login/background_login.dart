import 'package:flutter/material.dart';

class DecorativeCirclesBackground extends StatelessWidget {
  const DecorativeCirclesBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //top left small circle
        Positioned(
          top: 30,
          left: 20,
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 210, 239, 253),
              shape: BoxShape.circle,
            ),
          ),
        ),

        // medium circle, belakang selamat datang
        Positioned(
          top: 150,
          left: 30,
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 192, 214, 225),
              shape: BoxShape.circle,
            ),
          ),
        ),

        // big circle, kanan atas
        Positioned(
          top: 20,
          right: 20,
          child: Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 206, 232, 245),
              shape: BoxShape.circle,
            ),
          ),
        ),

        // medium circle top right di bawah big circle
        Positioned(
          top: 100,
          right: 80,
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 170, 204, 221),
              shape: BoxShape.circle,
            ),
          ),
        ),

        // big circle tengah kanan
        Positioned(
          top: 300,
          left: 240,
          child: Container(
            width: 150,
            height: 150,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 223, 240, 249),
              shape: BoxShape.circle,
            ),
          ),
        ),

        // small circle bottom left, bawah button login
        Positioned(
          bottom: 300,
          left: 60,
          child: Container(
            width: 15,
            height: 15,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 176, 189, 195),
              shape: BoxShape.circle,
            ),
          ),
        ),

        // medium circle bottom left
        Positioned(
          bottom: 200,
          left: 70,
          child: Container(
            width: 35,
            height: 35,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 186, 227, 248),
              shape: BoxShape.circle,
            ),
          ),
        ),

        // small circle bottom right
        Positioned(
          bottom: 200,
          right: 50,
          child: Container(
            width: 25,
            height: 25,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 204, 220, 228),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}