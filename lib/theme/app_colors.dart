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
  static const Color bgLight = Color(0xFFF3F8FF);
  static const Color card = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF1B1F3B);
  static const Color inkSoft = Color(0xFF5B6285);

  // Surface and utility variants
  static const Color borderLight = Color(0xFFE2E8F4);
  static const Color softGrey = Color(0xFFEAEFF8);
  static const Color disabledGrey = Color(0xFFB0B7C3);
  static const Color shadowNavy = Color(0x1F1F2A6B); // ~12% opacity
  static const Color glowYellow = Color(0x80FFD66B);

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
