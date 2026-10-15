import 'package:flutter/material.dart';

//Konstanta ukuran, padding, dan radius untuk mengatur konsistensi ui aplikasi
class AppSizes {
  AppSizes._();

  // Radius
  static const double radiusBadge = 8.0;
  static const double radiusDefault = 12.0;
  static const double radiusCard = 16.0;

  // Spacing
  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;
  static const double spaceXL = 40.0;

  // Padding halaman
  static const double pagePadding = 16.0;

  // Padding komponen
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    vertical: 14,
    horizontal: 24,
  );
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );
  static const EdgeInsets badgePadding = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 4,
  );

  // Ukuran elemen
  static const double iconEmptyState = 64.0;
  static const double loadingIndicatorSize = 20.0;
  static const double iconSmall = 16.0;

  // Ukuran font
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 20.0;

  // Alias
  static const double paddingMedium = spaceM;
  static const double paddingLarge = spaceL;
  static const double radiusMedium = radiusDefault;
  static const double radiusLarge = radiusCard;
  static const double spacingSmall = spaceS;
  static const double spacingMedium = spaceM;
  static const double spacingLarge = spaceL;

  // Layout Auth
  static const double authMaxContentWidth = 420.0;
}
