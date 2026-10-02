import 'dart:math';
import 'package:flutter/material.dart';
import '../models/badge.dart';
import '../services/haptics_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Achievement badge tile supporting earned (full color) and locked (silhouette '?') states.
class BadgeTile extends StatelessWidget {
  final BadgeModel badge;
  final VoidCallback onTap;

  const BadgeTile({
    super.key,
    required this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticsService.selectionClick();
        onTap();
      },
      child: Container(
        width: 105,
        margin: const EdgeInsets.only(right: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: badge.isUnlocked ? Colors.white : AppColors.softGrey.withValues(alpha: 0.5),
          borderRadius: AppSpacing.roundedCard,
          border: Border.all(
            color: badge.isUnlocked ? AppColors.sunYellow : AppColors.borderLight,
            width: badge.isUnlocked ? 2.0 : 1.2,
          ),
          boxShadow: badge.isUnlocked ? AppSpacing.softShadow : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: badge.isUnlocked
                    ? const Color(0xFFFFFBEB)
                    : AppColors.disabledGrey.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                badge.isUnlocked ? badge.emoji : '❓',
                style: const TextStyle(fontSize: 26),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              badge.isUnlocked ? badge.name : 'Secret Badge',
              style: AppTextStyles.label.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: badge.isUnlocked ? AppColors.navy : AppColors.inkSoft,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Circular progress ring visual displaying completed level fraction (e.g. 6 / 15).
class ProgressRing extends StatelessWidget {
  final int current;
  final int total;
  final double size;

  const ProgressRing({
    super.key,
    required this.current,
    required this.total,
    this.size = 150.0,
  });

  @override
  Widget build(BuildContext context) {
    final double fraction = total > 0 ? (current / total).clamp(0.0, 1.0) : 0.0;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(fraction: fraction),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$current / $total',
                style: AppTextStyles.headingMedium.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.navy,
                ),
              ),
              Text(
                'Levels Done',
                style: AppTextStyles.labelSoft.copyWith(fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double fraction;

  _RingPainter({required this.fraction});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    final bgPaint = Paint()
      ..color = AppColors.softGrey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14.0
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    final progressPaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.indigo, AppColors.mint],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14.0
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * fraction,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) => oldDelegate.fraction != fraction;
}
