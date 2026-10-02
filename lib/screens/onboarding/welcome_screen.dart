import 'package:flutter/material.dart';
import '../../constants/app_strings.dart';
import '../../demo/demo_fab.dart';
import '../../models/accessibility_settings.dart';
import '../../models/story_beat.dart';
import '../../routes/app_routes.dart';
import '../../services/app_state.dart';
import '../../services/haptics_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/mascot_widget.dart';
import '../../widgets/offline_badge.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button.dart';
import '../../widgets/speech_bubble.dart';

/// Welcome screen welcoming the child explorer with animated NOVA and audio help options.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  NovaMood _currentMood = NovaMood.excited;
  bool _showAudioBubble = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _currentMood = NovaMood.happy;
        });
      }
    });
  }

  void _onAudioHelpPressed(AppState appState) {
    HapticsService.mediumImpact();
    // Turn on Voice Instructions + Haptics + Large Text
    appState.updateAccessibility(AccessibilitySettings.audioAssisted());

    setState(() {
      _showAudioBubble = true;
      _currentMood = NovaMood.encouraging;
    });

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        Navigator.pushNamed(context, AppRoutes.studentSetup);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final bool isSpeaking = appState.accessibility.voiceInstructions;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Large floating NOVA mascot (~180)
                      MascotWidget(
                        size: 175,
                        mood: _currentMood,
                        speaking: isSpeaking || _showAudioBubble,
                        showGlow: true,
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Optional Audio Help confirmation speech bubble
                      if (_showAudioBubble) ...[
                        const SpeechBubble(
                          text: AppStrings.audioHelpActivated,
                          speaker: 'NOVA',
                          typewriter: true,
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],

                      // Greetings
                      Text(
                        AppStrings.welcomeGreeting,
                        style: AppTextStyles.headingLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        AppStrings.welcomeSubtitle,
                        style: AppTextStyles.bodySoft,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // ▶ Primary Action: [ Let's Begin ]
                      PrimaryButton(
                        label: AppStrings.letsBegin,
                        icon: Icons.rocket_launch_rounded,
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.studentSetup);
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Secondary Action: [ 🔊 I Need Audio Help ]
                      SecondaryButton(
                        label: AppStrings.audioHelp,
                        onPressed: () => _onAudioHelpPressed(appState),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Offline status message
                      const OfflineBadge(),
                      const SizedBox(height: 6),
                      Text(
                        AppStrings.offlineSubtitle,
                        style: AppTextStyles.labelSoft.copyWith(fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
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
