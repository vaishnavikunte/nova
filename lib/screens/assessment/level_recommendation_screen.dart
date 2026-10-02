import 'package:flutter/material.dart';
import '../../constants/app_strings.dart';
import '../../demo/demo_fab.dart';
import '../../models/story_beat.dart';
import '../../routes/app_routes.dart';
import '../../services/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/level_card.dart';
import '../../widgets/mascot_widget.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button.dart';

/// Level recommendation screen highlighting the assessed starting level node with easier adjustment option.
class LevelRecommendationScreen extends StatefulWidget {
  const LevelRecommendationScreen({super.key});

  @override
  State<LevelRecommendationScreen> createState() => _LevelRecommendationScreenState();
}

class _LevelRecommendationScreenState extends State<LevelRecommendationScreen> {
  void _startRecommendedLevel(AppState appState) {
    final rec = appState.student.recommendedLevel;
    appState.setCurrentLevel(rec);
    appState.startLevel(rec);
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (r) => false);
    // Open level detail as specified
    Navigator.pushNamed(context, AppRoutes.levelDetail);
  }

  void _showLevelPicker(BuildContext context, AppState appState) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Your Starting Point',
                style: AppTextStyles.questionText,
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(6, (i) {
                  final lvl = i + 1;
                  return ActionChip(
                    label: Text('Level $lvl'),
                    onPressed: () {
                      appState.setCurrentLevel(lvl);
                      Navigator.pop(ctx);
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final int recLevelNum = appState.student.recommendedLevel;
    final course = appState.currentCourse;
    final recommendedLevel = course.getLevel(recLevelNum);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // NOVA excited
                      const MascotWidget(
                        size: 140,
                        mood: NovaMood.excited,
                        showGlow: true,
                      ),
                      const SizedBox(height: AppSpacing.md),

                      Text(
                        AppStrings.recommendationTitle,
                        style: AppTextStyles.headingLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        AppStrings.recommendationMessage.replaceAll('{n}', '$recLevelNum'),
                        style: AppTextStyles.questionText.copyWith(
                          color: AppColors.indigo,
                          fontSize: 21,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Glowing Recommended Level Card
                      LevelCard(
                        level: recommendedLevel,
                        onTap: () => _startRecommendedLevel(appState),
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // ▶ Primary Action: [ Start Level {n} ]
                      PrimaryButton(
                        label: AppStrings.startLevelBtn.replaceAll('{n}', '$recLevelNum'),
                        icon: Icons.play_arrow_rounded,
                        onPressed: () => _startRecommendedLevel(appState),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Secondary: [ Try an Easier Level ] (hidden if already Level 1)
                      if (recLevelNum > 1) ...[
                        SecondaryButton(
                          label: AppStrings.tryEasierBtn,
                          onPressed: () {
                            appState.applyEasierLevel();
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],

                      // Picker Link
                      TextButton(
                        onPressed: () => _showLevelPicker(context, appState),
                        child: Text(
                          AppStrings.chooseWhereToBegin,
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.inkSoft,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
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
