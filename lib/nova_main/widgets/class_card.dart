import 'package:flutter/material.dart';
import '../services/haptics_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Class selection card with raised elevation and check badge when selected.
class ClassCard extends StatefulWidget {
  final int classNumber;
  final String title;
  final String iconEmoji;
  final bool selected;
  final VoidCallback onTap;

  const ClassCard({
    super.key,
    required this.classNumber,
    required this.title,
    required this.iconEmoji,
    required this.selected,
    required this.onTap,
  });

  @override
  State<ClassCard> createState() => _ClassCardState();
}

class _ClassCardState extends State<ClassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticsService.selectionClick();
    _bounceController.forward().then((_) => _bounceController.reverse());
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          height: 110,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: widget.selected ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).cardTheme.color ?? Colors.white,
            borderRadius: AppSpacing.roundedCard,
            border: Border.all(
              color: widget.selected ? Theme.of(context).colorScheme.primary : (Theme.of(context).colorScheme.outline ?? AppColors.borderLight),
              width: widget.selected ? 2.8 : 1.5,
            ),
            boxShadow: widget.selected ? AppSpacing.softShadow : null,
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.iconEmoji,
                      style: const TextStyle(fontSize: 34),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Class ${widget.classNumber}',
                      style: AppTextStyles.questionText.copyWith(
                        fontSize: 19,
                        color: widget.selected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.selected)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
