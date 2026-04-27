import 'package:flutter/material.dart';

class AppTheme {

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    /// الخلفية الأساسية
    scaffoldBackgroundColor: const Color(0xFF0F0F0F),

    /// اللون الأساسي (برتقالي)
    primaryColor: const Color(0xFFF59E0B),

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFF59E0B),
      secondary: Color(0xFFFBBF24),
      surface: Color(0xFF1E1E1E),
      onPrimary: Colors.black,
      onSurface: Colors.white,
    ),

    /// AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.white,
      centerTitle: false,
    ),

    /// الكروت
    cardColor: const Color(0xFF1E1E1E),

    /// النصوص
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        color: Colors.white70,
      ),
    ),


    /// الأزرار
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF59E0B),
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),

    /// TextField
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      hintStyle: const TextStyle(color: Colors.white54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
