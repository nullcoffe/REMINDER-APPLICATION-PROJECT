import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Warna brand dari Stitch AI
  static const Color primary = Color(0xFF14B8A6);
  static const Color secondary = Color(0xFF0D9488);
  static const Color tertiary = Color(0xFF99D5CA);

  // Background & surface tema gelap
  static const Color background = Color(0xFF1E3A3A);
  static const Color surface = Color(0xFF2A4A4A);
  static const Color surfaceLight = Color(0xFF3A5A5A);

  // Teks
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF99D5CA);

  // Prioritas
  static const Color priorityUrgent = Color(0xFFEF4444);
  static const Color priorityHigh = Color(0xFFF97316);
  static const Color priorityMedium = Color(0xFF14B8A6);
  static const Color priorityLow = Color(0xFF22C55E);

  // Status
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF22C55E);

  // Border
  static const Color border = Color(0xFF3A5A5A);

  // Alias untuk kompatibilitas kode lama
  static const Color primaryTeal = primary;
  static const Color secondaryTeal = secondary;
  static const Color scaffoldLight = background;
  static const Color scaffoldDark = background;
  static const Color surfaceDark = surface;
  static const Color borderLight = border;
  static const Color borderDark = border;
}
