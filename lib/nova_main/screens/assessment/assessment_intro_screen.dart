import 'package:flutter/material.dart';
import '../../constants/app_strings.dart';
import '../../demo/demo_fab.dart';
import '../../models/story_beat.dart';
import '../../routes/app_routes.dart';
import '../../services/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/mascot_widget.dart';
import '../../widgets/primary_button.dart';

/// Assessment intro reassuring child about no marks/pressure and explaining the 3-minute game.
class AssessmentIntroScreen extends StatelessWidget {
  const AssessmentIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Stack(
        children: [
          SafeArea(
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
                      // NOVA Encouraging mascot
                      const MascotWidget(
                        size: 150,
                        mood: NovaMood.encouraging,
                        showGlow: true,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Title
                      Text(
                        AppStrings.assessmentTitle,
                        style: AppTextStyles.headingLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Reassuring Positive Body Text
                      Text(
                        AppStrings.assessmentBody1,
                        style: AppTextStyles.body,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        AppStrings.assessmentBody2,
                        style: AppTextStyles.questionText.copyWith(
                          color: AppColors.purple,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Three reassuring chips
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildPill(AppStrings.chipGame),
                          _buildPill(AppStrings.chipShows),
                          _buildPill(AppStrings.chipTime),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // ▶ Primary Action: [ Start My Adventure ]
                      PrimaryButton(
                        label: AppStrings.startAssessment,
                        icon: Icons.play_arrow_rounded,
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.assessmentQuestion,
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Secondary text-button: [ Skip — start at Level 1 ]
                      TextButton(
                        onPressed: () {
                          appState.setCurrentLevel(1);
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.home,
                          );
                        },
                        child: Text(
                          AppStrings.skipAssessment,
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

  Widget _buildPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppSpacing.roundedChip,
        border: Border.all(color: AppColors.borderLight, width: 1.5),
        boxShadow: AppSpacing.softShadow,
      ),
      child: Text(
        text,
        style: AppTextStyles.label.copyWith(
          color: AppColors.navy,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }
}
