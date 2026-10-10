import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

/// Material 3 Themes: Standard playful palette and High Contrast WCAG AAA variant.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    const Color lightBg = Color(0xFFE9DDFF);
    const Color lightMainText = Color(0xFF29164E);
    const Color lightSupportText = Color(0xFF594B79);
    const Color lightCard = Colors.white;

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Mukta',
      brightness: Brightness.light,
      scaffoldBackgroundColor:
          Colors.transparent, // Background handled by GlobalPurpleThemeWrapper
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: lightMainText),
        bodyMedium: TextStyle(color: lightMainText),
        titleLarge: TextStyle(color: lightMainText),
        titleMedium: TextStyle(color: lightMainText),
        titleSmall: TextStyle(color: lightSupportText),
        bodySmall: TextStyle(color: lightSupportText),
      ),
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
        surface: lightCard,
        onSurface: lightMainText,
      ),
      cardTheme: CardThemeData(
        color: lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.roundedCard,
          side: const BorderSide(color: AppColors.borderLight, width: 1.5),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.purple,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, AppSpacing.minButtonHeight),
          shape: RoundedRectangleBorder(borderRadius: AppSpacing.roundedButton),
          textStyle: AppTextStyles.button,
          elevation: 4,
          shadowColor: AppColors.shadowNavy,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.navy,
          minimumSize: const Size(double.infinity, AppSpacing.minButtonHeight),
          shape: RoundedRectangleBorder(borderRadius: AppSpacing.roundedButton),
          side: const BorderSide(color: AppColors.navy, width: 2.0),
          textStyle: AppTextStyles.buttonSecondary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: AppSpacing.roundedCard,
          borderSide: const BorderSide(
            color: AppColors.borderLight,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.roundedCard,
          borderSide: const BorderSide(
            color: AppColors.borderLight,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.roundedCard,
          borderSide: const BorderSide(color: AppColors.indigo, width: 2.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        labelStyle: const TextStyle(color: lightMainText),
        hintStyle: const TextStyle(color: lightSupportText),
      ),
    );
  }

  static ThemeData get darkTheme {
    const Color darkBg = Color(0xFF170D35);
    const Color darkMainText = Color(0xFFFFFFFF);
    const Color darkSupportText = Color(0xFFE4DAFF);
    const Color darkCard = Color(0xFF30205A);
    const Color inputBg = Color(
      0xFFE9DDFF,
    ); // Light input surface per requirements
    const Color inputText = Color(0xFF29164E);

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Mukta',
      brightness: Brightness.dark,
      scaffoldBackgroundColor:
          Colors.transparent, // Background handled by GlobalPurpleThemeWrapper
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: darkMainText),
        bodyMedium: TextStyle(color: darkMainText),
        titleLarge: TextStyle(color: darkMainText),
        titleMedium: TextStyle(color: darkMainText),
        titleSmall: TextStyle(color: darkSupportText),
        bodySmall: TextStyle(color: darkSupportText),
      ),
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.purple,
        onPrimary: Colors.white,
        secondary: AppColors.sky,
        onSecondary: Colors.black,
        tertiary: AppColors.mint,
        onTertiary: Colors.black,
        error: AppColors.coral,
        onError: Colors.white,
        surface: darkCard,
        onSurface: darkMainText,
      ),
      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.roundedCard,
          side: BorderSide(
            color: darkSupportText.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.purple,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, AppSpacing.minButtonHeight),
          shape: RoundedRectangleBorder(borderRadius: AppSpacing.roundedButton),
          textStyle: AppTextStyles.button,
          elevation: 4,
          shadowColor: Colors.black45,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, AppSpacing.minButtonHeight),
          shape: RoundedRectangleBorder(borderRadius: AppSpacing.roundedButton),
          side: const BorderSide(color: Colors.white54, width: 2.0),
          textStyle: AppTextStyles.buttonSecondary.copyWith(
            color: Colors.white,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputBg,
        border: OutlineInputBorder(
          borderRadius: AppSpacing.roundedCard,
          borderSide: BorderSide(color: darkSupportText, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.roundedCard,
          borderSide: BorderSide(color: darkSupportText, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.roundedCard,
          borderSide: const BorderSide(color: AppColors.sky, width: 2.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        labelStyle: const TextStyle(color: inputText),
        hintStyle: const TextStyle(color: inputText),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: inputText,
        selectionColor: AppColors.purple,
        selectionHandleColor: AppColors.purple,
      ),
    );
  }
}
