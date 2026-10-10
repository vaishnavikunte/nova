import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Spacing scale, radii, and elevation definitions.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 48.0;

  static const double radiusChip = 16.0;
  static const double radiusCard = 24.0;
  static const double radiusButton = 28.0;
  static const double radiusCircle = 999.0;

  static const BorderRadius roundedChip = BorderRadius.all(
    Radius.circular(radiusChip),
  );
  static const BorderRadius roundedCard = BorderRadius.all(
    Radius.circular(radiusCard),
  );
  static const BorderRadius roundedButton = BorderRadius.all(
    Radius.circular(radiusButton),
  );

  static const double minTouchTarget = 56.0;
  static const double minButtonHeight = 60.0;
  static const double minOptionHeight = 72.0;
  static const double maxContentWidth = 480.0;

  static const List<BoxShadow> softShadow = [
    BoxShadow(
      color: AppColors.shadowNavy,
      blurRadius: 20.0,
      offset: Offset(0, 6),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> glowShadow = [
    BoxShadow(
      color: AppColors.glowYellow,
      blurRadius: 24.0,
      offset: Offset(0, 0),
      spreadRadius: 4,
    ),
  ];
}
