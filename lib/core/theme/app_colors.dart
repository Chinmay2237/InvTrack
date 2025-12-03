import 'package:flutter/material.dart';

class AppColors {
  // Main Colors
  static const Color primary = Color(0xFF1670A5);
  static const Color error = Color(0xFFE54C40);

  // Text Colors
  static const Color textPrimary = Color(0xFF3A3A3A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLabel = Color(0xFF9AA0A6);
  
  // Background & Surface Colors
  static const Color appBarBackgroundColor = Color(0xFFE8F1F6);
  static const Color background = Color(0xFFF0F2F5);
  static const Color darkBackground = Color(0xFF121212);
  static const Color surface = Colors.white;
  static const Color darkSurface = Color(0xFF1E1E1E);

  // Common Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9AA0A6);
  static const Color grey1 = Color(0xFFD9D9D9);
  static const Color borderColor = Color(0xFF656565);
  static const Color borderColor2 = Color(0xFF636363);
  static const Color transparent = Colors.transparent;

  // Semantic Colors (retained for consistency)
  static const Color primaryAccent = Color(0xFF4A9DCD);
  static const Color secondary = Color(0xFFFFA000);
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = Colors.black;
  static const Color onBackground = textPrimary;
  static const Color onSurface = textPrimary;

  // Stock Status Colors
  static const Color inStock = Color(0xFF4CAF50);
  static const Color lowStock = Color(0xFFFFC107);
  static const Color outOfStock = Color(0xFFF44336);
}
