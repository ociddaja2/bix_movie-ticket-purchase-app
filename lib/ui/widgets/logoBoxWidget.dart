import 'package:flutter/material.dart';

class LogoBox extends StatelessWidget {
  final double height;
  final Color backgroundColor;
  final String imagePath;
  final double imageSize;

  const LogoBox({
    super.key,
    this.height = 200,
    this.backgroundColor = const Color(0xFF003D82),
    required this.imagePath,
    this.imageSize = 150,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.elliptical(450, 150),
            topRight: Radius.elliptical(450, 150),
          ),
        ),
        child: Center(
          child: Image.asset(
            imagePath,
            width: imageSize,
            height: imageSize,
          ),
        ),
      ),
    );
  }
}
