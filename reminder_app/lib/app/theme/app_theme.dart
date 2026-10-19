import 'package:flutter/material.dart';
import 'package:reminder_app/core/constants/app_colors.dart';
import 'package:reminder_app/core/constants/app_sizes.dart';

/// Tema global TaskZilla (terang dan gelap).
/// Semua warna dan ukuran diambil dari AppColors dan AppSizes.
class AppTheme {
  AppTheme._(); // Private constructor agar class tidak bisa di-instansiasi

  // ===========================================================================
  // HELPER
  // ===========================================================================
  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  // ===========================================================================
  // TEMA TERANG
  // ===========================================================================
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.scaffoldLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryTeal,
        brightness: Brightness.light,
        primary: AppColors.primaryTeal,
        secondary: AppColors.secondaryTeal,
        surface: AppColors.surfaceLight,
        error: AppColors.error,
      ),

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),

      // Teks
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: AppSizes.fontSizeLarge,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: AppSizes.fontSizeMedium,
          color: AppColors.textPrimary,
        ),
        bodySmall: TextStyle(
          fontSize: AppSizes.fontSizeSmall,
          color: AppColors.textSecondary,
        ),
      ),

      // Kolom input
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        contentPadding: AppSizes.inputPadding,
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        border: _inputBorder(AppColors.borderLight),
        enabledBorder: _inputBorder(AppColors.borderLight),
        focusedBorder: _inputBorder(AppColors.secondaryTeal, width: 2),
        errorBorder: _inputBorder(AppColors.error),
        focusedErrorBorder: _inputBorder(AppColors.error, width: 2),
      ),

      // Tombol utama
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryTeal,
          foregroundColor: Colors.white,
          padding: AppSizes.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
          ),
        ),
      ),

      // Tombol outline
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryTeal,
          padding: AppSizes.buttonPadding,
          side: const BorderSide(color: AppColors.primaryTeal),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
          ),
        ),
      ),

      // Tombol teks
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primaryTeal),
      ),

      // Kartu
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusCard),
          side: const BorderSide(color: AppColors.borderLight),
        ),
      ),

      // Tombol melayang
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
      ),

      // Garis pemisah
      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
        space: AppSizes.spaceM,
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
        ),
      ),
    );
  }

  // ===========================================================================
  // TEMA GELAP
  // ===========================================================================
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.scaffoldDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryTeal,
        brightness: Brightness.dark,
        primary: AppColors.secondaryTeal,
        secondary: AppColors.secondaryTeal,
        surface: AppColors.surfaceDark,
        error: AppColors.error,
      ),

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),

      // Teks
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: AppSizes.fontSizeLarge,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontSize: AppSizes.fontSizeMedium,
          color: Colors.white,
        ),
        bodySmall: TextStyle(
          fontSize: AppSizes.fontSizeSmall,
          color: AppColors.textSecondary,
        ),
      ),

      // Kolom input
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark,
        contentPadding: AppSizes.inputPadding,
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        border: _inputBorder(AppColors.borderDark),
        enabledBorder: _inputBorder(AppColors.borderDark),
        focusedBorder: _inputBorder(AppColors.secondaryTeal, width: 2),
        errorBorder: _inputBorder(AppColors.error),
        focusedErrorBorder: _inputBorder(AppColors.error, width: 2),
      ),

      // Tombol utama
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryTeal,
          foregroundColor: Colors.white,
          padding: AppSizes.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
          ),
        ),
      ),

      // Tombol outline
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.secondaryTeal,
          padding: AppSizes.buttonPadding,
          side: const BorderSide(color: AppColors.secondaryTeal),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
          ),
        ),
      ),

      // Tombol teks
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.secondaryTeal),
      ),

      // Kartu
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusCard),
          side: const BorderSide(color: AppColors.borderDark),
        ),
      ),

      // Tombol melayang
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
      ),

      // Garis pemisah
      dividerTheme: const DividerThemeData(
        color: AppColors.borderDark,
        space: AppSizes.spaceM,
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
        ),
      ),
    );
  }
}
