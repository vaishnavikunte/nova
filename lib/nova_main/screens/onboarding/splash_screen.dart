import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../constants/app_strings.dart';
import '../../models/story_beat.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/mascot_widget.dart';
import '../../widgets/offline_badge.dart';

/// Animated splash screen introducing NOVA and STEM branding, auto-advancing after ~2.6s.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoScale;
  late AnimationController _orbitController;
  late AnimationController _taglineController;
  late Animation<double> _taglineFade;
  Timer? _navigationTimer;

  static const List<String> stemIcons = ['➕', '🔬', '📐', '🧮', '🌱', '🚀'];

  @override
  void initState() {
    super.initState();

    // 1. Logo scale 0.6 -> 1.0 with elasticOut (700ms)
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    // 2. Orbiting STEM icons controller
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // 3. Tagline fade-up
    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _taglineFade = CurvedAnimation(parent: _taglineController, curve: Curves.easeIn);

    // Start sequence
    _logoController.forward().then((_) {
      _orbitController.forward();
      _taglineController.forward();
    });

    // Auto-advance after 2.6s
    _navigationTimer = Timer(const Duration(milliseconds: 2600), _goToWelcome);
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _logoController.dispose();
    _orbitController.dispose();
    _taglineController.dispose();
    super.dispose();
  }

  void _goToWelcome() {
    if (!mounted) return;
    _navigationTimer?.cancel();
    Navigator.pushReplacementNamed(context, AppRoutes.welcome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _goToWelcome,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.navy, AppColors.indigo, AppColors.bgLight],
              stops: [0.0, 0.45, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo mark with orbiting STEM icons
                      SizedBox(
                        width: 260,
                        height: 260,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Orbiting icons
                            AnimatedBuilder(
                              animation: _orbitController,
                              builder: (context, child) {
                                return Stack(
                                  children: List.generate(stemIcons.length, (i) {
                                    final double baseAngle = (i * 2 * pi / stemIcons.length);
                                    final double progress = _orbitController.value;
                                    final double angle = baseAngle + (progress * 0.4);
                                    const double radius = 105.0;

                                    final double x = 130 + radius * cos(angle) - 18;
                                    final double y = 130 + radius * sin(angle) - 18;

                                    return Positioned(
                                      left: x,
                                      top: y,
                                      child: Opacity(
                                        opacity: progress.clamp(0.0, 1.0),
                                        child: Text(
                                          stemIcons[i],
                                          style: const TextStyle(fontSize: 26),
                                        ),
                                      ),
                                    );
                                  }),
                                );
                              },
                            ),
                            // Center rounded logo badge with NOVA
                            ScaleTransition(
                              scale: _logoScale,
                              child: Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.sunYellow, width: 3.5),
                                  boxShadow: AppSpacing.glowShadow,
                                ),
                                alignment: Alignment.center,
                                child: const MascotWidget(
                                  size: 105,
                                  mood: NovaMood.excited,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      // App Name
                      Text(
                        AppStrings.appName,
                        style: AppTextStyles.headingLarge.copyWith(
                          fontSize: 42,
                          color: AppColors.navy,
                          letterSpacing: 2.0,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      // Tagline
                      FadeTransition(
                        opacity: _taglineFade,
                        child: Text(
                          AppStrings.appTagline,
                          style: AppTextStyles.headingMedium.copyWith(
                            fontSize: 22,
                            color: AppColors.indigo,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Offline ready status pill at bottom
                const Positioned(
                  bottom: 24,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: OfflineBadge(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
