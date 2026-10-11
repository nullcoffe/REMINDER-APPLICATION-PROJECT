import 'package:flutter/material.dart';

// TODO (Nanti saat Alya selesai):
// Uncomment import di bawah ini jika file milik Alya sudah di-merge ke develop.
// import 'package:reminder_application_project/core/constants/app_colors.dart';
// import 'package:reminder_application_project/core/constants/app_sizes.dart';

class AppTheme {
  AppTheme._(); // Private constructor agar class tidak bisa di-instansiasi

  // ===========================================================================
  // PLACEHOLDER WARNA & UKURAN (SANGGACAN SEMENTARA)
  // Saat PR Alya di-merge, kamu tinggal mengganti variabel sementara di bawah ini 
  // dengan variabel milik Alya (misal: AppColors.primaryTeal).
  // ===========================================================================
  static const Color _primaryTeal = Color(0xFF008080); // Primary Teal Placeholder
  static const Color _secondaryTeal = Color(0xFF4DB6AC);
  static const Color _scaffoldBgLight = Color(0xFFF8F9FA);
  static const Color _scaffoldBgDark = Color(0xFF121212);
  static const double _defaultRadius = 12.0; // Placeholder dari AppSizes

  // ===========================================================================
  // TEMA TERANG (LIGHT THEME)
  // ===========================================================================
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

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: _primaryTeal,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),

      // Elevated Button Theme (UI Kit Tombol Utama TaskZilla)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryTeal,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_defaultRadius),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        ),
      ),

      // Input Decoration Theme (Form TextField)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_defaultRadius),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_defaultRadius),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_defaultRadius),
          borderSide: const BorderSide(color: _primaryTeal, width: 2),
        ),
      ),
    );
  }

  // ===========================================================================
  // TEMA GELAP (DARK THEME)
  // ===========================================================================
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

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryTeal,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_defaultRadius),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_defaultRadius),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_defaultRadius),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_defaultRadius),
          borderSide: const BorderSide(color: _secondaryTeal, width: 2),
        ),
      ),
    );
  }
}