import 'package:flutter/material.dart';
import 'package:reverse_flappy/src/style/palette.dart';

class HillsPainter extends CustomPainter {
  final Palette palette;

  HillsPainter(this.palette);

  @override
  void paint(Canvas canvas, Size size) {
    // Back hill
    final backPaint = Paint()..color = palette.hillGreen.withAlpha(180);
    final backPath = Path()
      ..moveTo(0, size.height * 0.6)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.1,
        size.width * 0.5,
        size.height * 0.5,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.9,
        size.width,
        size.height * 0.3,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(backPath, backPaint);

    // Front hill
    final frontPaint = Paint()..color = palette.groundGreen;
    final frontPath = Path()
      ..moveTo(0, size.height * 0.8)
      ..quadraticBezierTo(
        size.width * 0.3,
        size.height * 0.3,
        size.width * 0.6,
        size.height * 0.7,
      )
      ..quadraticBezierTo(
        size.width * 0.85,
        size.height * 1.0,
        size.width,
        size.height * 0.6,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(frontPath, frontPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
