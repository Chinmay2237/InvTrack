import 'package:flutter/material.dart';

/// Motion and animation specifications per Section 6.5 of InvTrack Design System.
abstract class AppMotion {
  // --- Durations ---
  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationModal = Duration(milliseconds: 300);
  static const Duration durationStagger = Duration(milliseconds: 500);
  static const Duration durationScanSuccess = Duration(milliseconds: 250);

  // --- Curves ---
  static const Curve curveStandard = Curves.easeOut;
  static const Curve curveModal = Curves.easeOutBack;
  static const Curve curveStagger = Curves.decelerate;
  static const Curve curveBounce = Curves.elasticOut;
}
