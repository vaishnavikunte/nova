import 'package:flutter/material.dart';
import '../../constants/app_strings.dart';
import '../../models/story_beat.dart';
import '../../routes/app_routes.dart';
import '../../services/app_state.dart';
import '../../services/haptics_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/mascot_widget.dart';
import '../../widgets/secondary_button.dart';

/// Profile & Journey timeline screen ("Me" tab) with avatar personalization and class switching.
class ProfileJourneyScreen extends StatelessWidget {
  const ProfileJourneyScreen({super.key});

  static const List<Color> avatarColors = [
    AppColors.purple,
    AppColors.sky,
    AppColors.mint,
    AppColors.sunYellow,
    AppColors.coral,
    AppColors.indigo,
  ];

  void _confirmClassSwitch(BuildContext context, AppState appState, int targetClass) {
    if (targetClass == appState.student.classNumber) return;

    HapticsService.lightImpact();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.roundedCard),
        title: const Text('Change Class?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
          AppStrings.switchClassConfirm
              .replaceAll('{n}', '$targetClass')
              .replaceAll('{current}', '${appState.student.classNumber}'),
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Stay Here', style: AppTextStyles.buttonSecondary),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.indigo),
            onPressed: () {
              appState.setClassNumber(targetClass);
              Navigator.pop(ctx);
            },
            child: const Text('Move to Class', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final student = appState.student;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
              child: Column(
                children: [
                  // Profile Header Card
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppSpacing.roundedCard,
                      border: Border.all(color: AppColors.borderLight, width: 2.0),
                      boxShadow: AppSpacing.softShadow,
                    ),
                    child: Column(
                      children: [
                        const MascotWidget(size: 96, mood: NovaMood.happy, showGlow: true),
                        const SizedBox(height: 8),
                        Text(
                          student.name,
                          style: AppTextStyles.headingMedium.copyWith(fontSize: 24),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Class ${student.classNumber} Explorer • ⭐ ${student.stars} Stars',
                          style: AppTextStyles.labelSoft.copyWith(fontSize: 14),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Avatar color swatches
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(avatarColors.length, (index) {
                            final bool selected = student.avatarColorIndex == index;
                            return GestureDetector(
                              onTap: () {
                                HapticsService.selectionClick();
                                appState.setAvatarColorIndex(index);
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: avatarColors[index],
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: selected ? AppColors.navy : Colors.white,
                                    width: selected ? 3.0 : 1.5,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Class Switcher Chips
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Switch School Class',
                      style: AppTextStyles.questionText.copyWith(fontSize: 19),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(6, (i) {
                      final c = i + 1;
                      final bool isCurrent = student.classNumber == c;
                      return ChoiceChip(
                        label: Text('Class $c'),
                        selected: isCurrent,
                        selectedColor: AppColors.indigo,
                        labelStyle: TextStyle(
                          color: isCurrent ? Colors.white : AppColors.navy,
                          fontWeight: FontWeight.bold,
                        ),
                        onSelected: (_) => _confirmClassSwitch(context, appState, c),
                      );
                    }),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Storybook Timeline Milestones
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Learning Journey Timeline',
                      style: AppTextStyles.questionText.copyWith(fontSize: 19),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppSpacing.roundedCard,
                      border: Border.all(color: AppColors.borderLight, width: 2.0),
                    ),
                    child: Column(
                      children: [
                        _buildTimelineItem('Took the "What You Know" game', '🧭', 'Starting level unlocked'),
                        _buildTimelineItem('Earned Star Explorer badge', '🌟', 'Welcome quest completed'),
                        _buildTimelineItem('Achieved 3-Day streak', '🔥', 'Consistent exploration'),
                        _buildTimelineItem('Explored Fractions in Level 6', '🍕', 'Sharing pirate treasure'),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Actions: Accessibility, Replay Assessment, Reset Demo
                  SecondaryButton(
                    label: AppStrings.accessibilityBtn,
                    icon: Icons.accessibility_new_rounded,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.accessibilitySettings);
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SecondaryButton(
                    label: AppStrings.replayAssessmentBtn,
                    icon: Icons.replay_rounded,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.assessmentIntro);
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SecondaryButton(
                    label: AppStrings.resetDemoBtn,
                    icon: Icons.restart_alt_rounded,
                    onPressed: () {
                      appState.resetDemo();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Demo reset successfully!')),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItem(String title, String emoji, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderLight),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.label.copyWith(fontWeight: FontWeight.bold)),
                Text(subtitle, style: AppTextStyles.labelSoft.copyWith(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
