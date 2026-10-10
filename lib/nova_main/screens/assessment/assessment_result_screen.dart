import 'package:flutter/material.dart';
import '../../constants/app_strings.dart';
import '../../demo/demo_fab.dart';
import '../../models/story_beat.dart';
import '../../routes/app_routes.dart';
import '../../services/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/confetti_overlay.dart';
import '../../widgets/mascot_widget.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/skill_bar.dart';

/// Assessment result screen featuring confetti burst, NOVA celebration, and the positive Understanding Map.
class AssessmentResultScreen extends StatefulWidget {
  const AssessmentResultScreen({super.key});

  @override
  State<AssessmentResultScreen> createState() => _AssessmentResultScreenState();
}

class _AssessmentResultScreenState extends State<AssessmentResultScreen> {
  bool _playConfetti = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        setState(() {
          _playConfetti = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final studentName = appState.student.name;
    final reduceMotion = appState.accessibility.reduceMotion;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Stack(
        children: [
          ConfettiOverlay(
            play: _playConfetti && !reduceMotion,
            particleCount: 50,
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppSpacing.maxContentWidth,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Celebrating Mascot
                        const MascotWidget(
                          size: 140,
                          mood: NovaMood.celebrating,
                          showGlow: true,
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Congratulations greeting
                        Text(
                          AppStrings.resultGreeting.replaceAll(
                            '{name}',
                            studentName,
                          ),
                          style: AppTextStyles.headingLarge.copyWith(
                            fontSize: 28,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          AppStrings.resultSubtitle,
                          style: AppTextStyles.bodySoft,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Understanding Map Card
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: AppSpacing.roundedCard,
                            border: Border.all(
                              color: AppColors.borderLight,
                              width: 2.0,
                            ),
                            boxShadow: AppSpacing.softShadow,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.explore_rounded,
                                    color: AppColors.purple,
                                    size: 26,
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Text(
                                    AppStrings.understandingMapTitle,
                                    style: AppTextStyles.questionText.copyWith(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),
                              // 5 Horizontal skill bars
                              const SkillBar(
                                label: 'Numbers',
                                emoji: '🔢',
                                mastery: 0.90,
                                animationDelayMs: 100,
                              ),
                              const SkillBar(
                                label: 'Add & Subtract',
                                emoji: '➕',
                                mastery: 0.85,
                                animationDelayMs: 250,
                              ),
                              const SkillBar(
                                label: 'Multiply',
                                emoji: '✖️',
                                mastery: 0.70,
                                animationDelayMs: 400,
                              ),
                              const SkillBar(
                                label: 'Divide',
                                emoji: '➗',
                                mastery: 0.75,
                                animationDelayMs: 550,
                              ),
                              const SkillBar(
                                label: 'Fractions',
                                emoji: '🍰',
                                mastery: 0.40,
                                animationDelayMs: 700,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        // ▶ Primary Action: [ Continue ]
                        PrimaryButton(
                          label: AppStrings.continueButton,
                          icon: Icons.arrow_forward_rounded,
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.levelRecommendation,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const DemoFab(),
        ],
      ),
    );
  }
}
