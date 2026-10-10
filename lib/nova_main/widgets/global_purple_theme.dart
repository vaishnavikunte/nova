import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'mascot_widget.dart';

import '../models/story_beat.dart';
import '../services/app_state.dart';

/// A global wrapper that provides the animated, purple-themed STEM environment
/// to all pages in the application.
class GlobalPurpleThemeWrapper extends StatefulWidget {
  final Widget child;

  const GlobalPurpleThemeWrapper({super.key, required this.child});

  @override
  State<GlobalPurpleThemeWrapper> createState() =>
      _GlobalPurpleThemeWrapperState();
}

class _GlobalPurpleThemeWrapperState extends State<GlobalPurpleThemeWrapper>
    with TickerProviderStateMixin {
  late AnimationController _bgFloatController;

  @override
  void initState() {
    super.initState();
    _bgFloatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgFloatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final isDark = appState.accessibility.isDarkMode;

    return Stack(
      children: [
        // Base gradient layer
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-0.5, -0.6),
                radius: 1.5,
                colors: isDark
                    ? const [
                        Color(0xFF6242F5), // Electric violet glow
                        Color(0xFF3920B8), // Royal purple
                        Color(0xFF170D35), // Deep dark indigo
                      ]
                    : const [
                        Color(0xFFFFFFFF), // White glow
                        Color(0xFFE9DDFF), // Pastel lavender
                        Color(0xFFA997FF), // Soft purple
                      ],
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
          ),
        ),

        // Animated STEM decorations layer
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _bgFloatController,
            builder: (context, _) {
              final floatY =
                  math.sin(_bgFloatController.value * math.pi * 2) * 20;
              return Stack(
                children: [
                  Positioned(
                    top: 80 + floatY,
                    left: -10,
                    child: const Icon(
                      Icons.calculate_rounded,
                      color: Color(0x66FFFFFF),
                      size: 100,
                    ),
                  ),
                  Positioned(
                    top: 160 - floatY,
                    right: -30,
                    child: const Icon(
                      Icons.science_rounded,
                      color: Color(0x6672E5BD),
                      size: 120,
                    ),
                  ),
                  Positioned(
                    bottom: 200 + floatY * 0.8,
                    left: -20,
                    child: const Text(
                      'π',
                      style: TextStyle(
                        color: Color(0x77FF91D0),
                        fontSize: 140,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 80 - floatY,
                    right: -20,
                    child: const Icon(
                      Icons.architecture_rounded,
                      color: Color(0x66FFD65C),
                      size: 130,
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.35 + floatY * 0.5,
                    left: -40,
                    child: const Text(
                      '+',
                      style: TextStyle(
                        color: Color(0x6680D7FF),
                        fontSize: 160,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40 - floatY * 0.5,
                    right: 20,
                    child: const Text(
                      '÷',
                      style: TextStyle(
                        color: Color(0x66FFFFFF),
                        fontSize: 100,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 30 + floatY,
                    left: 80,
                    child: const Icon(
                      Icons.star_rounded,
                      color: Color(0x66FFD65C),
                      size: 80,
                    ),
                  ),
                  Positioned(
                    top: 20 + floatY * 1.2,
                    left: MediaQuery.of(context).size.width * 0.4,
                    child: const Icon(
                      Icons.star_rounded,
                      color: Color(0x77FF91D0),
                      size: 70,
                    ),
                  ),
                  Positioned(
                    bottom: 100 - floatY * 1.5,
                    right: -40,
                    child: const Text(
                      '1',
                      style: TextStyle(
                        color: Color(0x44FFFFFF),
                        fontSize: 200,
                        fontWeight: FontWeight.w900,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),

        // Small Animated Child (Chintu) in the background (bottom left)
        Positioned(
          bottom: -40,
          left: -40,
          child: IgnorePointer(
            child: Transform.scale(
              scale: 0.9,
              child: MascotWidget(
                size: 250,
                mood: NovaMood.happy,
                speaking: false,
                showGlow: true,
              ),
            ),
          ),
        ),

        // The actual application content (Navigator) goes on top!
        widget.child,
      ],
    );
  }
}
