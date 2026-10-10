import 'package:flutter/material.dart';

/// App color palette matching NOVA design specification.
class AppColors {
  AppColors._();

  // Core brand tokens
  static const Color navy = Color(0xFF1F2A6B);
  static const Color indigo = Color(0xFF3F4BB8);
  static const Color purple = Color(0xFF7B5CD6);
  static const Color sky = Color(0xFF5BB8F0);
  static const Color sunYellow = Color(0xFFFFD66B);
  static const Color mint = Color(0xFF6FD9B0);
  static const Color coral = Color(0xFFFF8A7A);
  static const Color bgLight =
      Colors.transparent; // Let global purple wrapper show through
  static const Color card = Color(0xFFF0E9FF); // Light lilac cards
  static const Color ink = Color(0xFF2F185E); // Dark purple text
  static const Color inkSoft = Color(0xFF5B6285);

  // Surface and utility variants
  static const Color borderLight = Color(0xFFB9A0FF); // Lavender borders
  static const Color softGrey = Color(0xFFE5D9FF); // Soft lavender
  static const Color disabledGrey = Color(0xFFB9A0FF);
  static const Color shadowNavy = Color(0x335425A8); // Deep purple shadow
  static const Color glowYellow = Color(0x80FFD65A);

  // High contrast theme tokens (WCAG AAA)
  static const Color hcBackground = Color(0xFF000000);
  static const Color hcCard = Color(0xFF121212);
  static const Color hcText = Color(0xFFFFFFFF);
  static const Color hcTextSecondary = Color(0xFFFFFFB0);
  static const Color hcYellow = Color(0xFFFFEB3B);
  static const Color hcMint = Color(0xFF00FF88);
  static const Color hcCoral = Color(0xFFFF7B7B);
  static const Color hcSky = Color(0xFF64D2FF);
  static const Color hcBorder = Color(0xFFFFFFFF);

  // Gradient helpers
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [navy, indigo],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleSkyGradient = LinearGradient(
    colors: [purple, sky],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient yellowGradient = LinearGradient(
    colors: [Color(0xFFFFE599), sunYellow],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient mintGradient = LinearGradient(
    colors: [mint, Color(0xFF48C59A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
