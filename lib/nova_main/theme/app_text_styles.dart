import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography definitions adhering to children's learning readability specs.
class AppTextStyles {
  AppTextStyles._();

  static const TextStyle headingLarge = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.w800,
    height: 1.3,
    color: AppColors.navy,
    letterSpacing: -0.5,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: AppColors.navy,
    letterSpacing: -0.3,
  );

  static const TextStyle questionText = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    height: 1.35,
    color: AppColors.ink,
  );

  static const TextStyle storyNarration = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    height: 1.35,
    color: AppColors.ink,
  );

  static const TextStyle body = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.ink,
  );

  static const TextStyle bodySoft = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.inkSoft,
  );

  static const TextStyle button = TextStyle(
    fontSize: 19.0,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: Colors.white,
    letterSpacing: 0.2,
  );

  static const TextStyle buttonSecondary = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: AppColors.navy,
  );

  static const TextStyle label = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.ink,
  );

  static const TextStyle labelSoft = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: AppColors.inkSoft,
  );

  static const TextStyle chip = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.navy,
  );
}
