import 'package:flutter/material.dart';
import '../constants/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Reusable "🟢 Offline Ready" status pill.
class OfflineBadge extends StatelessWidget {
  final bool compact;

  const OfflineBadge({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 3 : 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE8FBF4),
        borderRadius: AppSpacing.roundedChip,
        border: Border.all(color: AppColors.mint, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 7 : 9,
            height: compact ? 7 : 9,
            decoration: const BoxDecoration(
              color: Color(0xFF10B981),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            AppStrings.offlineReady,
            style: AppTextStyles.label.copyWith(
              fontSize: compact ? 12 : 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF065F46),
            ),
          ),
        ],
      ),
    );
  }
}
