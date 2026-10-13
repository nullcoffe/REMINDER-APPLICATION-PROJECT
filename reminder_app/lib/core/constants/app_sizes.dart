import 'package:flutter/material.dart';

/// ============================================================
/// KONSTANTA UKURAN TASKZILLA
/// Penanggung jawab: Alya
///
/// Fungsi:
/// Menyimpan ukuran, padding, spacing, radius, dan ukuran ikon
/// agar tampilan seluruh halaman TaskZilla tetap konsisten.
///
/// Catatan:
/// Nilai ini merupakan draft dan dapat disesuaikan dengan Figma.
/// ============================================================

class AppSizes {
  AppSizes._();

  // ============================================================
  // RADIUS / SUDUT MEMBULAT
  // Disesuaikan dengan AppTheme dan komponen UI TaskZilla.
  // ============================================================

  static const double radiusBadge = 8.0;
  static const double radiusDefault = 12.0;
  static const double radiusCard = 16.0;

  // Alias agar kompatibel dengan kode halaman yang sudah ada.
  static const double radiusMedium = radiusDefault;
  static const double radiusLarge = radiusCard;

  // ============================================================
  // SPACING / JARAK ANTAR KOMPONEN
  // ============================================================

  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;

  // Alias untuk kompatibilitas dengan kode sebelumnya.
  static const double spacingSmall = spaceS;
  static const double spacingMedium = spaceM;
  static const double spacingLarge = spaceL;

  // ============================================================
  // PADDING HALAMAN
  // ============================================================

  static const double pagePadding = 16.0;

  // Alias ukuran padding yang digunakan oleh halaman task.
  static const double paddingMedium = spaceM;
  static const double paddingLarge = spaceL;

  // ============================================================
  // PADDING TOMBOL
  // Sesuai dengan ElevatedButtonTheme pada AppTheme.
  // ============================================================

  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    vertical: 14.0,
    horizontal: 24.0,
  );

  // ============================================================
  // PADDING INPUT
  // Sesuai dengan InputDecorationTheme pada AppTheme.
  // ============================================================

  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 12.0,
  );

  // ============================================================
  // PADDING BADGE PRIORITAS
  // ============================================================

  static const EdgeInsets badgePadding = EdgeInsets.symmetric(
    horizontal: 10.0,
    vertical: 4.0,
  );

  // ============================================================
  // UKURAN IKON DAN INDIKATOR
  // ============================================================

  static const double iconEmptyState = 64.0;
  static const double loadingIndicatorSize = 20.0;
  static const double iconSmall = 16.0;

  // ============================================================
  // UKURAN TEKS
  // Digunakan sebagai acuan ukuran teks komponen UI.
  // ============================================================

  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 20.0;
}