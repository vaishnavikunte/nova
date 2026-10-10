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
import '../../widgets/secondary_button.dart';
import '../../widgets/star_reward.dart';

/// Full-screen level completion celebration with animated rewards, streak increment, and badge awards.
class LevelCompleteScreen extends StatefulWidget {
  const LevelCompleteScreen({super.key});

  @override
  State<LevelCompleteScreen> createState() => _LevelCompleteScreenState();
}

class _LevelCompleteScreenState extends State<LevelCompleteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _trophyController;
  late Animation<double> _trophyScale;
  bool _playConfetti = true;

  @override
  void initState() {
    super.initState();
    _trophyController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _trophyScale = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _trophyController, curve: Curves.elasticOut),
    );

    _trophyController.forward();

    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        setState(() {
          _playConfetti = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _trophyController.dispose();
    super.dispose();
  }

  void _onNextLevel(AppState appState) {
    final nextLvl = appState.student.currentLevel;
    if (nextLvl > 15) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (r) => false);
    } else {
      appState.startLevel(nextLvl);
      Navigator.pushReplacementNamed(context, AppRoutes.levelDetail);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final student = appState.student;
    final int completedLvl = student.completedLevels.isNotEmpty
        ? student.completedLevels.last
        : 1;
    final bool isClassComplete = completedLvl == 15;
    final reduceMotion = appState.accessibility.reduceMotion;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Stack(
        children: [
          ConfettiOverlay(
            play: _playConfetti && !reduceMotion,
            particleCount: 60,
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.lg,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppSpacing.maxContentWidth,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Pop-in Trophy & Celebrating NOVA
                        ScaleTransition(
                          scale: _trophyScale,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.sunYellow,
                                    width: 3.5,
                                  ),
                                  boxShadow: AppSpacing.glowShadow,
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  '🏆',
                                  style: TextStyle(fontSize: 68),
                                ),
                              ),
                              const Positioned(
                                right: -12,
                                bottom: -10,
                                child: MascotWidget(
                                  size: 78,
                                  mood: NovaMood.celebrating,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Title
                        Text(
                          isClassComplete
                              ? AppStrings.classCompleteTitle
                              : AppStrings.adventureComplete,
                          style: AppTextStyles.headingLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Level $completedLvl Explorer',
                          style: AppTextStyles.questionText.copyWith(
                            color: AppColors.indigo,
                            fontSize: 22,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        // Sequential Rewards Row
                        const StarReward(stars: 20),
                        const SizedBox(height: AppSpacing.md),

                        // Streak and Badge Chips
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: AppSpacing.roundedCard,
                            border: Border.all(
                              color: AppColors.borderLight,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                AppStrings.streakDays.replaceAll(
                                  '{days}',
                                  '${student.streak}',
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: AppColors.navy,
                                ),
                              ),
                              Container(
                                width: 1.5,
                                height: 20,
                                color: AppColors.borderLight,
                              ),
                              const Text(
                                '🏆 Badge Unlocked',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: AppColors.purple,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        Text(
                          AppStrings.readyForNext,
                          style: AppTextStyles.bodySoft,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xxl),

                        // ▶ Primary Action: [ Next Level ] or [ Next Class ]
                        PrimaryButton(
                          label: isClassComplete && student.classNumber < 6
                              ? AppStrings.goToNextClass.replaceAll(
                                  '{n}',
                                  '${student.classNumber + 1}',
                                )
                              : AppStrings.nextLevelBtn,
                          icon: Icons.arrow_forward_rounded,
                          onPressed: () {
                            if (isClassComplete && student.classNumber < 6) {
                              appState.setClassNumber(student.classNumber + 1);
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppRoutes.home,
                                (r) => false,
                              );
                            } else {
                              _onNextLevel(appState);
                            }
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Secondary: [ Back to Adventure Map ]
                        SecondaryButton(
                          label: AppStrings.backToMapBtn,
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.home,
                              (r) => false,
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
