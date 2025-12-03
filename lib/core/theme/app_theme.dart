import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: GoogleFonts.latoTextTheme(),
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(secondary: Colors.amber),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: GoogleFonts.latoTextTheme(
        ThemeData(brightness: Brightness.dark).textTheme,
      ),
      colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark, primarySwatch: Colors.blue).copyWith(secondary: Colors.amber),
    );
  }
}
