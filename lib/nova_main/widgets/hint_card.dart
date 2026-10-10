import 'package:flutter/material.dart';
import '../services/haptics_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'primary_button.dart';

/// Progressive hint stack displaying revealed clues with numbered badges.
class HintCard extends StatelessWidget {
  final List<String> hints;
  final int revealedCount; // 1 to 3
  final VoidCallback onNextHint;
  final VoidCallback onClose;

  const HintCard({
    super.key,
    required this.hints,
    required this.revealedCount,
    required this.onNextHint,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasMore = revealedCount < hints.length;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB), // Soft warm yellow
        borderRadius: AppSpacing.roundedCard,
        border: Border.all(color: AppColors.sunYellow, width: 2.0),
        boxShadow: AppSpacing.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_rounded,
                color: Color(0xFFD97706),
                size: 28,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Helpful Clues ($revealedCount of ${hints.length})',
                style: AppTextStyles.label.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF92400E),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: AppColors.inkSoft),
                onPressed: () {
                  HapticsService.selectionClick();
                  onClose();
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // Stack of revealed hints
          for (int i = 0; i < revealedCount && i < hints.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                      color: AppColors.sunYellow,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      hints[i],
                      style: AppTextStyles.body.copyWith(
                        fontSize: 17,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          if (hasMore)
            PrimaryButton(
              label: 'Another hint',
              icon: Icons.lightbulb_outline_rounded,
              color: AppColors.navy,
              height: 52,
              onPressed: onNextHint,
            )
          else
            PrimaryButton(
              label: "Let's Try Again! ⭐",
              color: AppColors.mint,
              height: 52,
              onPressed: onClose,
            ),
        ],
      ),
    );
  }
}
