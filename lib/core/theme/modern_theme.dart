
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModernTheme {
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color secondaryColor = Color(0xFFF0F2F5);
  static const Color accentColor = Color(0xFFFF6B6B);
  static const Color textColor = Color(0xFF333333);
  static const Color backgroundColor = Color(0xFFFFFFFF);

  static ThemeData get theme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: TextTheme(
        headline1: GoogleFonts.poppins(
          color: textColor,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headline2: GoogleFonts.poppins(
          color: textColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        bodyText1: GoogleFonts.poppins(
          color: textColor,
          fontSize: 16,
        ),
        bodyText2: GoogleFonts.poppins(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: primaryColor,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: secondaryColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: GoogleFonts.poppins(
          color: Colors.grey[500],
        ),
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shadowColor: Colors.grey.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = ModernTheme.theme;

  ThemeData get themeData => _themeData;

  void setDarkTheme() {
    _themeData = ThemeData.dark().copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
    );
    notifyListeners();
  }

  void setLightTheme() {
    _themeData = ModernTheme.theme;
    notifyListeners();
  }
}
