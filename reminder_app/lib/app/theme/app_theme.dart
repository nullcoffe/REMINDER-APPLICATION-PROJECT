import 'package:flutter/material.dart';

// TODO (Nanti saat Alya selesai):
// Sesuaikan dengan konstanta milik Alya setelah di-merge.
// import 'package:reminder_application_project/core/constants/app_colors.dart';
// import 'package:reminder_application_project/core/constants/app_sizes.dart';

class AppTheme {
  AppTheme._();

  // ============================================================
  // PLACEHOLDER WARNA DAN UKURAN SEMENTARA
  // ============================================================
  static const Color _primaryTeal = Color(0xFF008080);
  static const Color _secondaryTeal = Color(0xFF4DB6AC);
  static const Color _scaffoldBgLight = Color(0xFFF8F9FA);
  static const Color _scaffoldBgDark = Color(0xFF121212);
  static const Color _borderLight = Color(0xFFE0E0E0);
  static const Color _borderDark = Color(0xFF616161);
  static const double _defaultRadius = 12.0;

  // ============================================================
  // LIGHT THEME
  // ============================================================
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: _primaryTeal,
      scaffoldBackgroundColor: _scaffoldBgLight,

      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryTeal,
        primary: _primaryTeal,
        secondary: _secondaryTeal,
        brightness: Brightness.light,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: _primaryTeal,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),

      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        margin: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_defaultRadius),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryTeal,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_defaultRadius),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_defaultRadius),
          borderSide: const BorderSide(
            color: _borderLight,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_defaultRadius),
          borderSide: const BorderSide(
            color: _borderLight,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_defaultRadius),
          borderSide: const BorderSide(
            color: _primaryTeal,
            width: 2,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DARK THEME
  // ============================================================
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: _primaryTeal,
      scaffoldBackgroundColor: _scaffoldBgDark,

      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryTeal,
        primary: _primaryTeal,
        secondary: _secondaryTeal,
        brightness: Brightness.dark,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),

      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        elevation: 2,
        margin: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_defaultRadius),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryTeal,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_defaultRadius),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_defaultRadius),
          borderSide: const BorderSide(
            color: _borderDark,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_defaultRadius),
          borderSide: const BorderSide(
            color: _borderDark,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_defaultRadius),
          borderSide: const BorderSide(
            color: _secondaryTeal,
            width: 2,
          ),
        ),
      ),
    );
  }
}