import 'dart:ui';

import 'package:flutter/material.dart';

class DottedBorder extends StatelessWidget {
  final Widget child;
  final Color color;
  final double strokeWidth;
  final List<double> dashPattern;
  final Radius radius;
  final BorderType borderType;

  const DottedBorder({
    super.key,
    required this.child,
    this.color = Colors.black,
    this.strokeWidth = 1,
    this.dashPattern = const <double>[3, 1],
    this.radius = const Radius.circular(0),
    this.borderType = BorderType.rRect,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DottedPainter(
        color: color,
        strokeWidth: strokeWidth,
        dashPattern: dashPattern,
        radius: radius,
        borderType: borderType,
      ),
      child: child,
    );
  }
}

enum BorderType {
  rect,
  rRect,
  oval,
  circle,
}

class _DottedPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final List<double> dashPattern;
  final Radius radius;
  final BorderType borderType;

  _DottedPainter({
    this.color = Colors.black,
    this.strokeWidth = 1,
    this.dashPattern = const <double>[3, 1],
    this.radius = const Radius.circular(0),
    this.borderType = BorderType.rRect,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    Path path;
    if (borderType == BorderType.rRect) {
      path = Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, size.width, size.height),
            radius,
          ),
        );
    } else if (borderType == BorderType.rect) {
      path = Path()
        ..addRect(
          Rect.fromLTWH(0, 0, size.width, size.height),
        );
    } else if (borderType == BorderType.oval) {
      path = Path()
        ..addOval(
          Rect.fromLTWH(0, 0, size.width, size.height),
        );
    } else {
      path = Path()
        ..addOval(
          Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2),
            radius: size.width / 2,
          ),
        );
    }

    final Path dashPath = Path();
    double distance = 0.0;

    for (final PathMetric metric in path.computeMetrics()) {
      bool draw = true;
      while (distance < metric.length) {
        final double len = dashPattern[draw ? 0 : 1];
        dashPath.addPath(
          metric.extractPath(distance, distance + len),
          Offset.zero,
        );
        distance += len;
        draw = !draw;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
