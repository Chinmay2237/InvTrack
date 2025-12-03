import 'package:flutter/material.dart';
import 'package:myapp/core/theme/app_theme.dart';

class AppText {
  static double _screenWidth = 0;

  static void init(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
  }

  static double _scale(double size) {
    if (_screenWidth >= 1200) {
      return size * 1.2;
    } else if (_screenWidth >= 600) {
      return size * 1.1;
    } else {
      return size;
    }
  }

  static TextStyle get displayLarge => AppTheme.lightTheme.textTheme.displayLarge!.copyWith(fontSize: _scale(57));
  static TextStyle get displayMedium => AppTheme.lightTheme.textTheme.displayMedium!.copyWith(fontSize: _scale(45));
  static TextStyle get displaySmall => AppTheme.lightTheme.textTheme.displaySmall!.copyWith(fontSize: _scale(36));
  static TextStyle get headlineLarge => AppTheme.lightTheme.textTheme.headlineLarge!.copyWith(fontSize: _scale(32));
  static TextStyle get headlineMedium => AppTheme.lightTheme.textTheme.headlineMedium!.copyWith(fontSize: _scale(28));
  static TextStyle get headlineSmall => AppTheme.lightTheme.textTheme.headlineSmall!.copyWith(fontSize: _scale(24));
  static TextStyle get titleLarge => AppTheme.lightTheme.textTheme.titleLarge!.copyWith(fontSize: _scale(22));
  static TextStyle get titleMedium => AppTheme.lightTheme.textTheme.titleMedium!.copyWith(fontSize: _scale(16));
  static TextStyle get titleSmall => AppTheme.lightTheme.textTheme.titleSmall!.copyWith(fontSize: _scale(14));
  static TextStyle get bodyLarge => AppTheme.lightTheme.textTheme.bodyLarge!.copyWith(fontSize: _scale(16));
  static TextStyle get bodyMedium => AppTheme.lightTheme.textTheme.bodyMedium!.copyWith(fontSize: _scale(14));
  static TextStyle get bodySmall => AppTheme.lightTheme.textTheme.bodySmall!.copyWith(fontSize: _scale(12));
  static TextStyle get labelLarge => AppTheme.lightTheme.textTheme.labelLarge!.copyWith(fontSize: _scale(14));
  static TextStyle get labelMedium => AppTheme.lightTheme.textTheme.labelMedium!.copyWith(fontSize: _scale(12));
  static TextStyle get labelSmall => AppTheme.lightTheme.textTheme.labelSmall!.copyWith(fontSize: _scale(11));
}
