import 'package:flutter/material.dart';

//palert warna utama aplikasi taskzilla
class AppColors {
  AppColors._();

  // warna brand atau warna primary
  static const Color primaryTeal = Color(0xFF008080);
  static const Color secondaryTeal = Color(0xFF4DB6AC);

  // warna Background & surface
  static const Color scaffoldLight = Color(0xFFF8F9FA);
  static const Color scaffoldDark = Color(0xFF121212);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // warna Prioritas
  static const Color priorityUrgent = Colors.red;
  static const Color priorityHigh = Colors.orange;
  static const Color priorityMedium = Colors.blue;
  static const Color priorityLow = Colors.green;

  // Teks & garis
  static const Color textSecondary = Colors.grey;
  static const Color borderLight = Color(0xFFE0E0E0); // grey.shade300
  static const Color borderDark = Color(0xFF616161); // grey.shade700

  // Status umum
  static const Color error = Colors.red;
  static const Color success = Colors.green;

  // Alias untuk nama yang dipakai layar task
  static const Color primary = primaryTeal;
  static const Color background = scaffoldLight;
  static const Color surface = surfaceLight;
  static const Color textPrimary = Color(0xFF1E293B);
}
