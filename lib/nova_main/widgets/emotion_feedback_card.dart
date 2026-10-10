import 'package:flutter/material.dart';
import '../models/emotion_state.dart';
import '../services/haptics_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'primary_button.dart';
import 'secondary_button.dart';

/// Visibly distinct feedback cards for Confident, Confused, Frustrated, and Correct states.
class EmotionFeedbackCard extends StatefulWidget {
  final EmotionState state;
  final bool isCorrect;
  final String message;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final List<String> stepByStepSteps;

  const EmotionFeedbackCard({
    super.key,
    required this.state,
    required this.isCorrect,
    required this.message,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.stepByStepSteps = const [],
  });

  @override
  State<EmotionFeedbackCard> createState() => _EmotionFeedbackCardState();
}

class _EmotionFeedbackCardState extends State<EmotionFeedbackCard> {
  bool _showingStepByStep = false;
  int _activeStep = 0;

  @override
  Widget build(BuildContext context) {
    Color cardBg;
    Color borderColor;
    IconData headerIcon;
    Color iconColor;

    if (widget.isCorrect) {
      if (widget.state == EmotionState.confident) {
        cardBg = const Color(0xFFFFF9E6);
        borderColor = AppColors.sunYellow;
        headerIcon = Icons.rocket_launch_rounded;
        iconColor = const Color(0xFFD97706);
      } else {
        cardBg = const Color(0xFFEEFBF5);
        borderColor = AppColors.mint;
        headerIcon = Icons.stars_rounded;
        iconColor = AppColors.mint;
      }
    } else {
      if (widget.state == EmotionState.frustrated) {
        cardBg = const Color(0xFFF0FDF4);
        borderColor = AppColors.mint;
        headerIcon = Icons.spa_rounded;
        iconColor = const Color(0xFF16A34A);
      } else {
        // Confused / default gentle try again
        cardBg = const Color(0xFFF0F8FF);
        borderColor = AppColors.sky;
        headerIcon = Icons.lightbulb_rounded;
        iconColor = AppColors.sky;
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppSpacing.roundedCard,
        border: Border.all(color: borderColor, width: 2.2),
        boxShadow: AppSpacing.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                child: Icon(headerIcon, color: iconColor, size: 28),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  widget.message,
                  style: AppTextStyles.questionText.copyWith(fontSize: 20),
                ),
              ),
            ],
          ),
          // Step-by-step walkthrough for frustrated state
          if (_showingStepByStep && widget.stepByStepSteps.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppSpacing.roundedCard,
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (
                    int i = 0;
                    i <= _activeStep && i < widget.stepByStepSteps.length;
                    i++
                  ) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: AppColors.mint,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${i + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              widget.stepByStepSteps[i],
                              style: AppTextStyles.body.copyWith(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (_activeStep < widget.stepByStepSteps.length - 1) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                        label: const Text('Next step'),
                        onPressed: () {
                          HapticsService.lightImpact();
                          setState(() {
                            _activeStep++;
                          });
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          // Primary action
          if (widget.state == EmotionState.frustrated &&
              !_showingStepByStep &&
              widget.stepByStepSteps.isNotEmpty)
            PrimaryButton(
              label: 'Show Me Step by Step',
              icon: Icons.format_list_numbered_rounded,
              color: AppColors.mint,
              onPressed: () {
                setState(() {
                  _showingStepByStep = true;
                });
              },
            )
          else
            PrimaryButton(
              label: widget.primaryLabel,
              color: widget.isCorrect
                  ? (widget.state == EmotionState.confident
                        ? AppColors.indigo
                        : AppColors.mint)
                  : AppColors.navy,
              onPressed: widget.onPrimary,
            ),
          if (widget.secondaryLabel != null && widget.onSecondary != null) ...[
            const SizedBox(height: AppSpacing.sm),
            SecondaryButton(
              label: widget.secondaryLabel!,
              onPressed: widget.onSecondary,
            ),
          ],
        ],
      ),
    );
  }
}
