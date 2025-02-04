import 'package:flutter/material.dart';

class DiagonalWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.15, 0);
    path.quadraticBezierTo(
      size.width * 0.2,
      0,
      size.width * 0.23,
      size.height * 0.08,
    );
    path.quadraticBezierTo(
      size.width * 0.26,
      size.height * 0.15,
      size.width * 0.29,
      size.height * 0.15,
    );

    path.quadraticBezierTo(
      size.width * 0.32,
      size.height * 0.15,
      size.width * 0.35,
      size.height * 0.08,
    );
    path.quadraticBezierTo(size.width * 0.38, 0, size.width * 0.43, 0);

    path.quadraticBezierTo(
      size.width * 0.48,
      0,
      size.width * 0.51,
      size.height * 0.08,
    );
    path.quadraticBezierTo(
      size.width * 0.54,
      size.height * 0.15,
      size.width * 0.57,
      size.height * 0.15,
    );

    path.quadraticBezierTo(
      size.width * 0.60,
      size.height * 0.15,
      size.width * 0.63,
      size.height * 0.08,
    );
    path.quadraticBezierTo(size.width * 0.66, 0, size.width * 0.71, 0);

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width * 0.71, size.height);

    path.quadraticBezierTo(
      size.width * 0.66,
      size.height,
      size.width * 0.63,
      size.height * 0.92,
    );

    path.quadraticBezierTo(
      size.width * 0.60,
      size.height * 0.85,
      size.width * 0.57,
      size.height * 0.85,
    );

    path.quadraticBezierTo(
      size.width * 0.54,
      size.height * 0.85,
      size.width * 0.51,
      size.height * 0.92,
    );

    path.quadraticBezierTo(
      size.width * 0.48,
      size.height,
      size.width * 0.43,
      size.height,
    );

    path.quadraticBezierTo(
      size.width * 0.38,
      size.height,
      size.width * 0.35,
      size.height * 0.92,
    );
    path.quadraticBezierTo(
      size.width * 0.32,
      size.height * 0.85,
      size.width * 0.29,
      size.height * 0.85,
    );

    path.quadraticBezierTo(
      size.width * 0.26,
      size.height * 0.85,
      size.width * 0.23,
      size.height * 0.92,
    );
    path.quadraticBezierTo(
      size.width * 0.2,
      size.height,
      size.width * 0.15,
      size.height,
    );

    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
