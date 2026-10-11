import 'package:flutter/material.dart';

/// Konstanta ukuran, padding, dan radius TaskZilla.
///
/// DRAFT SEMENTARA (backup oleh Laili, PIC asli: Alya).
/// Nilai diambil dari kode yang sudah ada di develop
/// (app_theme.dart, custom_button.dart, custom_textfield.dart,
/// priority_badge.dart, notification_screen.dart).
class AppSizes {
  AppSizes._();

  // Radius
  static const double radiusBadge = 8.0; // priority_badge.dart
  static const double radiusDefault = 12.0; // app_theme.dart, button, textfield
  static const double radiusCard = 16.0; // notification_screen.dart

  // Spacing
  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;

  // Padding halaman
  static const double pagePadding = 16.0; // notification_screen.dart

  // Tombol (custom_button.dart)
  static const EdgeInsets buttonPadding =
      EdgeInsets.symmetric(vertical: 14, horizontal: 24);

  // Input (app_theme.dart)
  static const EdgeInsets inputPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 12);

  // Badge (priority_badge.dart)
  static const EdgeInsets badgePadding =
      EdgeInsets.symmetric(horizontal: 10, vertical: 4);

  // Ikon & indikator
  static const double iconEmptyState = 64.0; // notification_screen.dart
  static const double loadingIndicatorSize = 20.0; // custom_button.dart
}