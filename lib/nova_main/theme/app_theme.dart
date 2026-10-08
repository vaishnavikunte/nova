import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

/// Material 3 Themes: Standard playful palette and High Contrast WCAG AAA variant.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.bgLight,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.navy,
        onPrimary: Colors.white,
        secondary: AppColors.purple,
        onSecondary: Colors.white,
        tertiary: AppColors.mint,
        onTertiary: AppColors.ink,
        error: AppColors.coral,
        onError: Colors.white,
        surface: AppColors.card,
        onSurface: AppColors.ink,
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.roundedCard,
          side: const BorderSide(color: AppColors.borderLight, width: 1.5),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, AppSpacing.minButtonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.roundedButton,
          ),
          textStyle: AppTextStyles.button,
          elevation: 4,
          shadowColor: AppColors.shadowNavy,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.navy,
          minimumSize: const Size(double.infinity, AppSpacing.minButtonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.roundedButton,
          ),
          side: const BorderSide(color: AppColors.navy, width: 2.0),
          textStyle: AppTextStyles.buttonSecondary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: AppSpacing.roundedCard,
          borderSide: const BorderSide(color: AppColors.borderLight, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.roundedCard,
          borderSide: const BorderSide(color: AppColors.borderLight, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.roundedCard,
          borderSide: const BorderSide(color: AppColors.indigo, width: 2.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
    );
  }

  static ThemeData get highContrastTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.hcBackground,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.hcYellow,
        onPrimary: Colors.black,
        secondary: AppColors.hcSky,
        onSecondary: Colors.black,
        tertiary: AppColors.hcMint,
        onTertiary: Colors.black,
        error: AppColors.hcCoral,
        onError: Colors.black,
        surface: AppColors.hcCard,
        onSurface: AppColors.hcText,
      ),
      cardTheme: CardThemeData(
        color: AppColors.hcCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.roundedCard,
          side: const BorderSide(color: AppColors.hcBorder, width: 2.5),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.hcYellow,
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, AppSpacing.minButtonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.roundedButton,
            side: const BorderSide(color: Colors.white, width: 2),
          ),
          textStyle: AppTextStyles.button.copyWith(color: Colors.black, fontWeight: FontWeight.w900),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.hcYellow,
          minimumSize: const Size(double.infinity, AppSpacing.minButtonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.roundedButton,
          ),
          side: const BorderSide(color: AppColors.hcYellow, width: 2.5),
          textStyle: AppTextStyles.buttonSecondary.copyWith(color: AppColors.hcYellow),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.hcCard,
        border: OutlineInputBorder(
          borderRadius: AppSpacing.roundedCard,
          borderSide: const BorderSide(color: Colors.white, width: 2.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.roundedCard,
          borderSide: const BorderSide(color: Colors.white, width: 2.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.roundedCard,
          borderSide: const BorderSide(color: AppColors.hcYellow, width: 3.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
    );
  }
}
