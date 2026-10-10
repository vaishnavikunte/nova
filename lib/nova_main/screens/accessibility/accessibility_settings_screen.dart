import 'package:flutter/material.dart';
import '../../constants/app_strings.dart';
import '../../demo/demo_fab.dart';
import '../../models/accessibility_settings.dart';
import '../../routes/app_routes.dart';
import '../../services/app_state.dart';
import '../../services/haptics_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/accessibility_toggle.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button.dart';

/// Full-featured Accessibility Settings with live app-wide theme and text scale switching.
class AccessibilitySettingsScreen extends StatelessWidget {
  const AccessibilitySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final settings = appState.accessibility;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          AppStrings.accessibilityTitle,
          style: AppTextStyles.questionText.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Theme.of(context).colorScheme.onSurface,
            size: 28,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppSpacing.maxContentWidth,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Appearance / Theme Selection
                      Text(
                        'Appearance (थीम निवडा)',
                        style: AppTextStyles.headingLarge.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _ThemeOptionCard(
                              title: 'Light Theme',
                              subtitle: 'Pastel purple',
                              isSelected: !settings.isDarkMode,
                              bgColor: const Color(0xFFE9DDFF),
                              textColor: const Color(0xFF2F185E),
                              onTap: () => appState.updateAccessibility(
                                settings.copyWith(isDarkMode: false),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ThemeOptionCard(
                              title: 'Dark Theme',
                              subtitle: 'Deep purple',
                              isSelected: settings.isDarkMode,
                              bgColor: const Color(0xFF170D35),
                              textColor: const Color(0xFFE5D9FF),
                              onTap: () => appState.updateAccessibility(
                                settings.copyWith(isDarkMode: true),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Voice Instructions
                      AccessibilityToggle(
                        icon: Icons.record_voice_over_rounded,
                        title: AppStrings.voiceInstructionsTitle,
                        subtitle: AppStrings.voiceInstructionsSubtitle,
                        value: settings.voiceInstructions,
                        previewText:
                            'NOVA will read aloud instructions and options.',
                        onChanged: (val) {
                          appState.updateAccessibility(
                            settings.copyWith(voiceInstructions: val),
                          );
                        },
                      ),

                      // Haptic Feedback
                      AccessibilityToggle(
                        icon: Icons.vibration_rounded,
                        title: AppStrings.hapticFeedbackTitle,
                        subtitle: AppStrings.hapticFeedbackSubtitle,
                        value: settings.hapticFeedback,
                        previewText:
                            'Vibrates lightly when you tap buttons and select answers.',
                        onChanged: (val) {
                          appState.updateAccessibility(
                            settings.copyWith(hapticFeedback: val),
                          );
                        },
                      ),
                      if (settings.hapticFeedback)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 12.0,
                            bottom: 8.0,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              icon: const Icon(
                                Icons.touch_app_rounded,
                                size: 18,
                              ),
                              label: const Text(AppStrings.testHaptics),
                              onPressed: () => HapticsService.mediumImpact(),
                            ),
                          ),
                        ),

                      // Gesture Navigation
                      AccessibilityToggle(
                        icon: Icons.swipe_rounded,
                        title: AppStrings.gestureNavTitle,
                        subtitle: AppStrings.gestureNavSubtitle,
                        value: settings.gestureNavigation,
                        previewText:
                            'Swipe right for next, swipe left for previous, double tap to select.',
                        onChanged: (val) {
                          appState.updateAccessibility(
                            settings.copyWith(gestureNavigation: val),
                          );
                        },
                      ),

                      // Large Text
                      AccessibilityToggle(
                        icon: Icons.text_fields_rounded,
                        title: AppStrings.largeTextTitle,
                        subtitle: AppStrings.largeTextSubtitle,
                        value: settings.largeText,
                        previewText:
                            'This sample text reflects enlarged font scaling.',
                        onChanged: (val) {
                          appState.updateAccessibility(
                            settings.copyWith(largeText: val),
                          );
                        },
                      ),

                      // Reduce Motion
                      AccessibilityToggle(
                        icon: Icons.motion_photos_off_rounded,
                        title: AppStrings.reduceMotionTitle,
                        subtitle: AppStrings.reduceMotionSubtitle,
                        value: settings.reduceMotion,
                        previewText:
                            'Soft fades instead of bouncing animations.',
                        onChanged: (val) {
                          appState.updateAccessibility(
                            settings.copyWith(reduceMotion: val),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Screen-Off Mode Section
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardTheme.color ?? const Color(0xFFF0E9FF),
                          borderRadius: AppSpacing.roundedCard,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline ?? AppColors.borderLight,
                            width: 2.0,
                          ),
                          boxShadow: AppSpacing.softShadow,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.hearing_rounded,
                                  color: AppColors.indigo,
                                  size: 28,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Text(
                                    AppStrings.screenOffModeTitle,
                                    style: AppTextStyles.questionText.copyWith(
                                      color: Theme.of(context).textTheme.bodyLarge?.color,
                                      fontSize: 19,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              AppStrings.screenOffModeSubtitle,
                              style: AppTextStyles.bodySoft.copyWith(
                                color: Theme.of(context).textTheme.bodySmall?.color,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            PrimaryButton(
                              label: AppStrings.tryScreenOffBtn,
                              icon: Icons.headset_rounded,
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.screenOffSimulation,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
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
}

class _ThemeOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final Color bgColor;
  final Color textColor;
  final VoidCallback onTap;

  const _ThemeOptionCard({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.bgColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFD65C) : Colors.transparent,
            width: 4,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: textColor.withOpacity(0.1),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFFFFD65C),
                      size: 30,
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
