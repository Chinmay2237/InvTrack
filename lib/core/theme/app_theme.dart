import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/core/theme/app_colors.dart';

class AppTheme {
  static final TextTheme _lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.poppins(fontSize: 57, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
    displayMedium: GoogleFonts.poppins(fontSize: 45, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
    displaySmall: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
    headlineLarge: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
    headlineMedium: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
    headlineSmall: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
    titleLarge: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
    titleMedium: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
    titleSmall: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
    bodyLarge: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.textSecondary),
    bodyMedium: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.textSecondary),
    bodySmall: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.normal, color: AppColors.textLabel),
    labelLarge: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.white),
    labelMedium: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textLabel),
    labelSmall: GoogleFonts.roboto(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textLabel),
  );

  static final TextTheme _darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.poppins(fontSize: 57, fontWeight: FontWeight.bold, color: AppColors.white),
    displayMedium: GoogleFonts.poppins(fontSize: 45, fontWeight: FontWeight.bold, color: AppColors.white),
    displaySmall: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.white),
    headlineLarge: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.white),
    headlineMedium: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.white),
    headlineSmall: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w500, color: AppColors.white),
    titleLarge: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w500, color: AppColors.white),
    titleMedium: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.white),
    titleSmall: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.grey),
    bodyLarge: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.grey),
    bodyMedium: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.grey),
    bodySmall: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.normal, color: AppColors.grey1),
    labelLarge: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.white),
    labelMedium: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.grey),
    labelSmall: GoogleFonts.roboto(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.grey),
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      background: AppColors.background,
      error: AppColors.error,
      onPrimary: AppColors.white,
      onSecondary: AppColors.black,
      onSurface: AppColors.textPrimary,
      onBackground: AppColors.textPrimary,
    ),
    textTheme: _lightTextTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.appBarBackgroundColor,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.primary),
      titleTextStyle: _lightTextTheme.headlineSmall?.copyWith(color: AppColors.primary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: _lightTextTheme.labelLarge,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderColor)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary)),
        labelStyle: _lightTextTheme.bodyMedium
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.grey,
      showUnselectedLabels: true,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.darkSurface,
      background: AppColors.darkBackground,
      error: AppColors.error,
      onPrimary: AppColors.white,
      onSecondary: AppColors.black,
      onSurface: AppColors.white,
      onBackground: AppColors.white,
    ),
    textTheme: _darkTextTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.white),
      titleTextStyle: _darkTextTheme.headlineSmall?.copyWith(color: AppColors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: _darkTextTheme.labelLarge,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkSurface,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderColor2)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary)),
        labelStyle: _darkTextTheme.bodyMedium
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.grey,
      showUnselectedLabels: true,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.primary.withOpacity(0.2),
      labelStyle: const TextStyle(color: AppColors.primary),
      side: const BorderSide(color: AppColors.primary, width: 1),
    )
  );
}
