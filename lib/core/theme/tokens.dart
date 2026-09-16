import 'package:flutter/material.dart';

/// Design tokens for InvTrack v2 — Warm Minimal Aesthetic.
/// Cream backgrounds, warm brown text, rust accents, and serif headers.
abstract class AppTokens {
  // --- Light Theme Colors (Warm Minimal) ---
  static const Color backgroundLight = Color(0xFFFFFDF9);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceAltLight = Color(0xFFF5EFE5);
  static const Color borderLight = Color(0xFFEBE4D8);
  static const Color textPrimaryLight = Color(0xFF3E2F28);
  static const Color textSecondaryLight = Color(0xFF8C7A6B);
  static const Color textDisabledLight = Color(0xFFC5B9AC);

  // --- Dark Theme Colors (Warm Dark Minimal) ---
  static const Color backgroundDark = Color(0xFF1F1A17);
  static const Color surfaceDark = Color(0xFF2A231F);
  static const Color surfaceAltDark = Color(0xFF342D28);
  static const Color borderDark = Color(0xFF483E38);
  static const Color textPrimaryDark = Color(0xFFF5EFE5);
  static const Color textSecondaryDark = Color(0xFFC5B9AC);
  static const Color textDisabledDark = Color(0xFF6E6056);

  // --- Brand & Semantic Colors (Rust & Warm Accents) ---
  static const Color primary = Color(0xFFA85A3A); // Rust accent
  static const Color primaryHover = Color(0xFF8E492D);
  static const Color primarySurfaceLight = Color(0xFFFDF6F0);
  static const Color primarySurfaceDark = Color(0xFF3E231A);

  static const Color critical = Color(0xFFC84B31); // Terracotta Red
  static const Color criticalSurfaceLight = Color(0xFFFDF0ED);
  static const Color criticalSurfaceDark = Color(0xFF421A14);

  static const Color warning = Color(0xFFD98A2B); // Warm Amber / Ochre
  static const Color warningSurfaceLight = Color(0xFFFDF7ED);
  static const Color warningSurfaceDark = Color(0xFF422C14);

  static const Color info = Color(0xFF4A6B82); // Muted Slate Blue
  static const Color infoSurfaceLight = Color(0xFFF0F4F8);
  static const Color infoSurfaceDark = Color(0xFF1D2C38);

  // --- Spacing Scale ---
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;

  // --- Radius Scale ---
  static const double radiusInput = 6.0;
  static const double radiusButton = 10.0;
  static const double radiusChip = 10.0;
  static const double radiusCard = 16.0;
  static const double radiusModal = 20.0;

  // --- Elevation / BoxShadows ---
  static const List<BoxShadow> shadowCardLight = [
    BoxShadow(
      color: Color.fromRGBO(62, 47, 40, 0.05),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> shadowCardDark = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.35),
      blurRadius: 8,
      offset: Offset(0, 3),
    ),
  ];

  static const List<BoxShadow> shadowModalLight = [
    BoxShadow(
      color: Color.fromRGBO(62, 47, 40, 0.12),
      blurRadius: 28,
      offset: Offset(0, 12),
    ),
  ];

  static const List<BoxShadow> shadowModalDark = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.55),
      blurRadius: 32,
      offset: Offset(0, 14),
    ),
  ];
}
