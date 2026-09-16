import 'package:flutter/material.dart';

/// Centralized Design Tokens for InvTrack — iOS-Inspired Operations Studio.
/// Features warm ivory/neutral grouped canvas, deep charcoal typography,
/// terracotta/rust brand accent, and native iOS status colors.
/// Final Color Tokens for InvTrack — iOS-Inspired Operations Studio.
/// Graphite, Electric Teal, Warm White, and restrained Lavender accents.
abstract final class AppColors {
  // Dark surfaces
  static const backgroundDark = Color(0xFF12161B);
  static const surfaceDark = Color(0xFF1C232B);
  static const surfaceElevatedDark = Color(0xFF242D36);
  static const borderDark = Color(0xFF303840);

  // Dark text
  static const textPrimary = Color(0xFFF3F5F7);
  static const textSecondary = Color(0xFF9AA5B1);

  // Brand
  static const primary = Color(0xFF2EC4B6);
  static const primaryHover = Color(0xFF45D8C8);
  static const secondaryAccent = Color(0xFFA78BFA);

  // Status
  static const success = Color(0xFF58C98D);
  static const warning = Color(0xFFE8B86D);
  static const error = Color(0xFFE27676);

  // Light theme
  static const backgroundLight = Color(0xFFF7F8F7);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const surfaceSecondaryLight = Color(0xFFEEF2F1);
  static const textPrimaryLight = Color(0xFF172027);
  static const textSecondaryLight = Color(0xFF65727A);
  static const borderLight = Color(0xFFDCE4E2);
  static const primaryLight = Color(0xFF168C83);
}

/// Legacy and semantic token references mapping to AppColors.
abstract class AppTokens {
  // --- Canvas & Surface Colors ---
  static const Color backgroundLight = AppColors.backgroundLight;
  static const Color surfaceLight = AppColors.surfaceLight;
  static const Color surfaceAltLight = AppColors.surfaceSecondaryLight;
  static const Color borderLight = AppColors.borderLight;
  static const Color textPrimaryLight = AppColors.textPrimaryLight;
  static const Color textSecondaryLight = AppColors.textSecondaryLight;
  static const Color textDisabledLight = Color(0xFF9AA5B1);

  static const Color backgroundDark = AppColors.backgroundDark;
  static const Color surfaceDark = AppColors.surfaceDark;
  static const Color surfaceAltDark = AppColors.surfaceElevatedDark;
  static const Color borderDark = AppColors.borderDark;
  static const Color textPrimaryDark = AppColors.textPrimary;
  static const Color textSecondaryDark = AppColors.textSecondary;
  static const Color textDisabledDark = Color(0xFF65727A);

  // --- Brand Accent & Highlights ---
  static const Color primary = AppColors.primary;
  static const Color primaryHover = AppColors.primaryHover;
  static const Color secondaryAccent = AppColors.secondaryAccent;
  static const Color primarySurfaceLight = Color(0xFFE6F9F7);
  static const Color primarySurfaceDark = Color(0xFF1B3835);

  // --- Status Colors ---
  static const Color success = AppColors.success;
  static const Color successSurfaceLight = Color(0xFFEEF9F3);
  static const Color successSurfaceDark = Color(0xFF1C3627);

  static const Color info = AppColors.primary; // Electric Teal for primary info
  static const Color infoSurfaceLight = Color(0xFFE6F9F7);
  static const Color infoSurfaceDark = Color(0xFF1B3835);

  static const Color warning = AppColors.warning;
  static const Color warningSurfaceLight = Color(0xFFFDF8EE);
  static const Color warningSurfaceDark = Color(0xFF382F1E);

  static const Color critical = AppColors.error;
  static const Color criticalSurfaceLight = Color(0xFFFDF0F0);
  static const Color criticalSurfaceDark = Color(0xFF381F1F);

  // --- Spacing Scale ---
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space48 = 48.0;

  // --- Radius Scale (iOS Grouped Surfaces) ---
  static const double radiusInput = 10.0;
  static const double radiusButton = 10.0;
  static const double radiusChip = 8.0;
  static const double radiusCard = 12.0;
  static const double radiusGroup = 12.0;
  static const double radiusModal = 16.0;

  // --- iOS Subdued Shadows & Elevations ---
  static const List<BoxShadow> shadowCardLight = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.03),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> shadowCardDark = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.25),
      blurRadius: 8,
      offset: Offset(0, 3),
    ),
  ];

  static const List<BoxShadow> shadowModalLight = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.12),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> shadowModalDark = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.45),
      blurRadius: 24,
      offset: Offset(0, 10),
    ),
  ];
}
