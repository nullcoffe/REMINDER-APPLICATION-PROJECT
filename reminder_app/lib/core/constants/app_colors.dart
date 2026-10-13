import 'package:flutter/material.dart';

/// ============================================================
/// KONSTANTA WARNA TASKZILLA
/// Penanggung jawab: Alya
///
/// Fungsi:
/// Menyimpan seluruh warna yang digunakan oleh aplikasi
/// agar tampilan setiap halaman tetap konsisten.
///
/// Catatan:
/// Warna masih berupa draft dan perlu dicocokkan dengan Figma.
/// ============================================================

class AppColors {
  AppColors._();

  // ============================================================
  // BRAND COLOR - ALYA
  // Warna utama identitas aplikasi TaskZilla.
  // ============================================================

  static const Color primaryTeal = Color(0xFF008080);
  static const Color secondaryTeal = Color(0xFF4DB6AC);

  // Alias untuk kompatibilitas dengan kode halaman yang sudah ada.
  static const Color primary = primaryTeal;

  // ============================================================
  // BACKGROUND DAN SURFACE
  // Digunakan untuk latar halaman dan kartu.
  // ============================================================

  static const Color scaffoldLight = Color(0xFFF8F9FA);
  static const Color scaffoldDark = Color(0xFF121212);

  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Alias tema terang agar kompatibel dengan kode sebelumnya.
  static const Color background = scaffoldLight;
  static const Color surface = surfaceLight;

  // ============================================================
  // WARNA PRIORITAS TUGAS
  // Digunakan untuk membedakan tingkat prioritas tugas.
  // ============================================================

  static const Color priorityUrgent = Colors.red;
  static const Color priorityHigh = Colors.orange;
  static const Color priorityMedium = Colors.blue;
  static const Color priorityLow = Colors.green;

  // ============================================================
  // WARNA TEKS DAN BORDER
  // Digunakan pada teks sekunder dan kolom input.
  // ============================================================

  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Colors.grey;

  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF616161);

  // ============================================================
  // WARNA STATUS
  // ============================================================

  static const Color error = Colors.red;
  static const Color success = Colors.green;
}