import 'dart:math' as math;
import 'package:flutter/material.dart';

class CurvedTextPainter extends CustomPainter {
  final String text;
  final Color textColor;
  final double fontSize;

  CurvedTextPainter({
    required this.text,
    required this.textColor,
    required this.fontSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4; // Slight inset from edge

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Calculate total text width to center it on the arc
    double totalWidth = 0;
    for (int i = 0; i < text.length; i++) {
      textPainter.text = TextSpan(
        text: text[i],
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0.5,
        ),
      );
      textPainter.layout();
      totalWidth += textPainter.width;
    }

    // Arc runs along the bottom half of the circle
    final textArcAngle = totalWidth / radius;

    // Start angle: center the text on the bottom arc
    // π/2 is the bottom of the circle
    double currentAngle = math.pi / 2 - textArcAngle / 2;

    canvas.save();
    canvas.translate(center.dx, center.dy);

    for (int i = 0; i < text.length; i++) {
      textPainter.text = TextSpan(
        text: text[i],
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0.5,
        ),
      );
      textPainter.layout();

      final charAngle = textPainter.width / radius;
      final angle = currentAngle + charAngle / 2;

      canvas.save();
      canvas.rotate(angle);
      canvas.translate(0, radius - textPainter.height);

      // Rotate each character to face outward
      textPainter.paint(canvas, Offset(-textPainter.width / 2, 0));
      canvas.restore();

      currentAngle += charAngle;
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
