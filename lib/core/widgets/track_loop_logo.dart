import 'package:flutter/material.dart';
import '../theme/tokens.dart';

/// InvTrack Brand Logo Mark: The Track Loop.
/// Two offset interlocking rounded shapes representing inventory movement, assignment, and tracking lifecycle.
class TrackLoopLogo extends StatelessWidget {
  final double size;
  final Color? primaryColor;
  final Color? secondaryColor;
  final bool showBadge;

  const TrackLoopLogo({
    super.key,
    this.size = 32.0,
    this.primaryColor,
    this.secondaryColor,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final logoWidget = ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.22),
      child: Image.asset(
        'assets/images/app_icon.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _TrackLoopPainter(
              primaryColor: primaryColor ?? AppTokens.primary,
              secondaryColor: secondaryColor ??
                  (isDark
                      ? AppTokens.textPrimaryDark
                      : AppTokens.textPrimaryLight),
            ),
          ),
        ),
      ),
    );

    if (!showBadge) return logoWidget;

    return Container(
      padding: EdgeInsets.all(size * 0.15),
      decoration: BoxDecoration(
        color: isDark ? AppTokens.surfaceDark : AppTokens.surfaceLight,
        borderRadius: BorderRadius.circular(size * 0.3),
        border: Border.all(
          color: isDark ? AppTokens.borderDark : AppTokens.borderLight,
          width: 1,
        ),
        boxShadow:
            isDark ? AppTokens.shadowCardDark : AppTokens.shadowCardLight,
      ),
      child: logoWidget,
    );
  }
}

class _TrackLoopPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;

  _TrackLoopPainter({
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final strokeWidth = width * 0.16;

    // Outer Loop Paint (Terracotta/Primary)
    final primaryPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Inner Loop Paint (Espresso/Secondary)
    final secondaryPaint = Paint()
      ..color = secondaryColor.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Track Loop 1 (Top-Left to Center-Right loop path)
    final path1 = Path();
    final r1 = RRect.fromLTRBR(
      width * 0.10,
      height * 0.10,
      width * 0.72,
      height * 0.72,
      Radius.circular(width * 0.22),
    );
    path1.addRRect(r1);

    // Track Loop 2 (Bottom-Right offset loop path)
    final path2 = Path();
    final r2 = RRect.fromLTRBR(
      width * 0.28,
      width * 0.28,
      width * 0.90,
      height * 0.90,
      Radius.circular(width * 0.22),
    );
    path2.addRRect(r2);

    // Accent Dot Paint (Center tracking node)
    final dotPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    // Draw secondary loop first, then primary loop over it
    canvas.drawPath(path2, secondaryPaint);
    canvas.drawPath(path1, primaryPaint);

    // Small tracking node dot at the bottom-right connection point
    canvas.drawCircle(
      Offset(width * 0.78, height * 0.78),
      strokeWidth * 0.45,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _TrackLoopPainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor;
  }
}
