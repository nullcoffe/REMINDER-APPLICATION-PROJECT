import 'package:flutter/material.dart';

/// Konstanta warna TaskZilla.
///
/// DRAFT SEMENTARA (backup oleh Laili, PIC asli: Alya).
/// Nilai di bawah diambil dari kode yang sudah ada di develop
/// (app_theme.dart, priority_badge.dart, custom_*.dart).
/// Yang bertanda [CEK FIGMA] belum dicocokkan dengan desain.
class AppColors {
  AppColors._();

  // Brand (dari app_theme.dart)
  static const Color primaryTeal = Color(0xFF008080); // [CEK FIGMA]
  static const Color secondaryTeal = Color(0xFF4DB6AC); // [CEK FIGMA]

  // Background & surface (dari app_theme.dart)
  static const Color scaffoldLight = Color(0xFFF8F9FA);
  static const Color scaffoldDark = Color(0xFF121212);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Prioritas (dari priority_badge.dart)
  static const Color priorityUrgent = Colors.red;
  static const Color priorityHigh = Colors.orange;
  static const Color priorityMedium = Colors.blue;
  static const Color priorityLow = Colors.green;

  // Teks & garis (dari custom_textfield.dart, loading_indicator.dart)
  static const Color textSecondary = Colors.grey;
  static const Color borderLight = Color(0xFFE0E0E0); // grey.shade300
  static const Color borderDark = Color(0xFF616161); // grey.shade700

  // Status umum
  static const Color error = Colors.red;
  static const Color success = Colors.green;
}