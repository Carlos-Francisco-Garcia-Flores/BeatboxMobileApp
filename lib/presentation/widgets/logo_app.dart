import 'package:flutter/material.dart';

class LogoApp extends StatelessWidget {
  final double width;
  final double height;

  const LogoApp({
    super.key,
    this.width = 200,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png', // 👈 Aquí está centralizado el logo
      width: width,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          child: const Text(
            "Dogotbox",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        );
      },
    );
  }
}
