import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Top bar star rating (⭐ / ⭐⭐ / ⭐⭐⭐) reflecting the active tier.
class AdaptiveDifficultyStars extends StatelessWidget {
  final int tier; // 1, 2, or 3
  final bool animated;

  const AdaptiveDifficultyStars({
    super.key,
    required this.tier,
    this.animated = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppSpacing.roundedChip,
        border: Border.all(color: AppColors.borderLight, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          final bool filled = index < tier;
          return AnimatedScale(
            scale: filled ? 1.05 : 0.85,
            duration: const Duration(milliseconds: 300),
            curve: Curves.elasticOut,
            child: Icon(
              filled ? Icons.star_rounded : Icons.star_border_rounded,
              color: filled ? AppColors.sunYellow : AppColors.disabledGrey,
              size: 22,
            ),
          );
        }),
      ),
    );
  }
}

/// Session progress trail representing completed steps (e.g. 8 stars or 5 dots).
class AdventureProgressIndicator extends StatelessWidget {
  final int current; // 1-indexed
  final int total;
  final bool useStars;

  const AdventureProgressIndicator({
    super.key,
    required this.current,
    required this.total,
    this.useStars = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final bool isPassed = index < current;
        final bool isCurrent = index == current - 1;

        if (useStars) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.5),
            child: AnimatedScale(
              scale: isCurrent ? 1.25 : 1.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.elasticOut,
              child: Icon(
                isPassed ? Icons.star_rounded : Icons.star_border_rounded,
                color: isPassed ? AppColors.sunYellow : AppColors.disabledGrey,
                size: 24,
              ),
            ),
          );
        } else {
          // Dots mode
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            width: isCurrent ? 18.0 : 10.0,
            height: 10.0,
            decoration: BoxDecoration(
              color: isPassed ? AppColors.mint : AppColors.disabledGrey,
              borderRadius: BorderRadius.circular(5.0),
            ),
          );
        }
      }),
    );
  }
}
