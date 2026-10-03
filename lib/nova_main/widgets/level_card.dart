import 'package:flutter/material.dart';
import '../models/level_model.dart';
import '../services/haptics_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Informational card summarizing a level's topic, difficulty, reward stars, and time estimate.
class LevelCard extends StatelessWidget {
  final LevelModel level;
  final VoidCallback onTap;

  const LevelCard({
    super.key,
    required this.level,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticsService.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppSpacing.roundedCard,
          border: Border.all(color: AppColors.borderLight, width: 2.0),
          boxShadow: AppSpacing.softShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F5FF),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.purple.withValues(alpha: 0.3), width: 2),
              ),
              alignment: Alignment.center,
              child: Text(level.emoji, style: const TextStyle(fontSize: 32)),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.navy,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'LEVEL ${level.number}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '⭐ ${level.rewardStars} Stars',
                        style: AppTextStyles.label.copyWith(
                          fontSize: 13,
                          color: const Color(0xFFB45309),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    level.topic,
                    style: AppTextStyles.questionText.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    level.storyTitle,
                    style: AppTextStyles.labelSoft.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.inkSoft, size: 28),
          ],
        ),
      ),
    );
  }
}
