import 'package:flutter/material.dart';
import '../../constants/app_strings.dart';
import '../../models/badge.dart';
import '../../models/story_beat.dart';
import '../../services/app_state.dart';
import '../../services/haptics_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/badge_tile.dart';
import '../../widgets/mascot_widget.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/progress_ring.dart';
import '../../widgets/speech_bubble.dart';

/// Visual, non-analytical Progress screen ("My Adventure") with star jar, progress ring, and badge shelf.
class ProgressScreen extends StatelessWidget {
  final VoidCallback onContinueToMap;

  const ProgressScreen({super.key, required this.onContinueToMap});

  void _showBadgeStory(BuildContext context, BadgeModel badge) {
    HapticsService.lightImpact();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.roundedCard),
        title: Row(
          children: [
            Text(badge.isUnlocked ? badge.emoji : '❓', style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                badge.isUnlocked ? badge.name : 'Secret Badge',
                style: AppTextStyles.questionText.copyWith(fontSize: 20),
              ),
            ),
          ],
        ),
        content: Text(
          badge.isUnlocked
              ? badge.description
              : 'Keep exploring levels and discovering new math secrets to unlock this badge!',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Awesome!', style: AppTextStyles.buttonSecondary),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final student = appState.student;
    final badges = appState.badges;
    final int completedCount = student.completedLevels.length;

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
                  // NOVA encouraging speech bubble
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const MascotWidget(size: 72, mood: NovaMood.happy),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: SpeechBubble(
                          text: AppStrings.progressBubble.replaceAll('{name}', student.name),
                          speaker: 'NOVA',
                          typewriter: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Big Circular Progress Ring Visual
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
                        ProgressRing(
                          current: completedCount,
                          total: 15,
                          size: 150,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatChip('Class ${student.classNumber}', '🎒', const Color(0xFFEEF2FF)),
                            _buildStatChip('Level ${student.currentLevel}', '🚀', const Color(0xFFE8FBF4)),
                            _buildStatChip('${student.streak} Days', '🔥', const Color(0xFFFFF1F0)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Star Jar Visual
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: AppSpacing.roundedCard,
                      border: Border.all(color: AppColors.sunYellow, width: 2.0),
                      boxShadow: AppSpacing.softShadow,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Text('🍯', style: TextStyle(fontSize: 32)),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${student.stars} ⭐ Stars Collected',
                                style: AppTextStyles.questionText.copyWith(
                                  color: const Color(0xFF92400E),
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Great learning momentum! Keep going!',
                                style: AppTextStyles.labelSoft.copyWith(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Badge Shelf
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppStrings.badgeShelfTitle,
                      style: AppTextStyles.questionText.copyWith(fontSize: 21),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    height: 125,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: badges.length,
                      itemBuilder: (context, index) {
                        return BadgeTile(
                          badge: badges[index],
                          onTap: () => _showBadgeStory(context, badges[index]),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // ▶ Continue Adventure
                  PrimaryButton(
                    label: 'Continue Adventure 🗺️',
                    onPressed: onContinueToMap,
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(String text, String emoji, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.navy),
          ),
        ],
      ),
    );
  }
}
