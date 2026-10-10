import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:majhe_gaon/core/routing/boot_logic.dart';
import 'package:majhe_gaon/features/curriculum/presentation/class_selection_screen.dart';
import 'package:majhe_gaon/features/duel/duel_lobby_screen.dart';
import '../../demo/demo_fab.dart';
import '../../models/accessibility_settings.dart';
import '../../models/story_beat.dart';
import '../../services/app_state.dart';
import '../accessibility/accessibility_settings_screen.dart';
import '../onboarding/student_setup_screen.dart';
import '../../services/haptics_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/mascot_widget.dart';
import '../../widgets/speech_bubble.dart';
import '../../widgets/child_character_widget.dart';

/// Welcome screen welcoming the child explorer with animated NOVA, interactive STEM elements, and premium UI.
class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen>
    with TickerProviderStateMixin {
  NovaMood _currentMood = NovaMood.excited;
  bool _showAudioBubble = false;
  bool _showMascotBubble = false;
  String _mascotMessage = '';

  final List<String> _mascotMessages = [
    'चला, काहीतरी नवीन शिकूया!',
    'आज एक नवीन प्रयोग करूया!',
    'गणिताची मजा घेऊया!',
    'तयार आहात ना?',
  ];
  int _messageIndex = 0;

  late AnimationController _bgFloatController;

  @override
  void initState() {
    super.initState();
    _bgFloatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _currentMood = NovaMood.happy;
        });
      }
    });
  }

  @override
  void dispose() {
    _bgFloatController.dispose();
    super.dispose();
  }

  void _onMascotTap() {
    HapticsService.lightImpact();
    setState(() {
      _currentMood = NovaMood.celebrating;
      _mascotMessage = _mascotMessages[_messageIndex];
      _messageIndex = (_messageIndex + 1) % _mascotMessages.length;
      _showMascotBubble = true;
      _showAudioBubble = false;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _showMascotBubble) {
        setState(() {
          _showMascotBubble = false;
          _currentMood = NovaMood.happy;
        });
      }
    });
  }

  void _onAudioHelpPressed(AppState appState) async {
    HapticsService.mediumImpact();
    // Turn on Voice Instructions + Haptics + Large Text
    appState.updateAccessibility(AccessibilitySettings.audioAssisted());

    setState(() {
      _showAudioBubble = true;
      _showMascotBubble = false;
      _currentMood = NovaMood.encouraging;
    });

    final flutterTts = FlutterTts();
    await flutterTts.setLanguage("mr-IN");
    await flutterTts.speak('ठीक आहे! मी तुम्हाला सर्व काही सांगेन.');

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const StudentSetupScreen()),
        );
      }
    });
  }

  void _logOut(BuildContext context) {
    // Clear student session state
    AppStateScope.of(context).clearStudentSession();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const StudentSetupScreen()),
      (route) => false,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final studentAsync = ref.watch(activeStudentProvider);
    final studentName = studentAsync.maybeWhen(
      data: (student) => student.name,
      orElse: () => 'Nikhil',
    );

    return Drawer(
      backgroundColor: const Color(0xFFE5D9FF),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 60,
              bottom: 30,
              left: 24,
              right: 24,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5425A8), Color(0xFF7041D9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(topRight: Radius.circular(32)),
            ),
            child: Row(
              children: [
                const MascotWidget(size: 80, mood: NovaMood.happy),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'नमस्कार,',
                        style: TextStyle(
                          color: Color(0xFFB9A0FF),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        studentName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(
              Icons.home_rounded,
              color: Color(0xFF5425A8),
              size: 32,
            ),
            title: const Text(
              'Home',
              style: TextStyle(
                color: Color(0xFF2F185E),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.favorite_rounded,
              color: Color(0xFF5425A8),
              size: 32,
            ),
            title: const Text(
              'Donate',
              style: TextStyle(
                color: Color(0xFF2F185E),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.emoji_events_rounded,
              color: Color(0xFF5425A8),
              size: 32,
            ),
            title: const Text(
              'Dangal',
              style: TextStyle(
                color: Color(0xFF2F185E),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DuelLobbyScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.settings_rounded,
              color: Color(0xFF5425A8),
              size: 32,
            ),
            title: const Text(
              'Settings',
              style: TextStyle(
                color: Color(0xFF2F185E),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccessibilitySettingsScreen()),
              );
            },
          ),
          const Spacer(),
          const Divider(color: Color(0xFFB9A0FF), thickness: 2),
          ListTile(
            leading: const Icon(
              Icons.logout_rounded,
              color: Color(0xFFFF8A7A),
              size: 32,
            ),
            title: const Text(
              'Log Out',
              style: TextStyle(
                color: Color(0xFFFF8A7A),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () => _logOut(context),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final bool isSpeaking = appState.accessibility.voiceInstructions;

    final studentAsync = ref.watch(activeStudentProvider);
    final studentName = studentAsync.maybeWhen(
      data: (student) => student.name,
      orElse: () => 'Nikhil',
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      drawer: _buildDrawer(context),
      body: Stack(
        children: [
          _STEMBackground(animation: _bgFloatController),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.lg,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppSpacing.maxContentWidth,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Interactive Mascot
                      GestureDetector(
                        onTap: _onMascotTap,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Ambient glow behind mascot
                            Container(
                              width: 190,
                              height: 190,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF65B7F3,
                                    ).withValues(alpha: 0.3),
                                    blurRadius: 40,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                            MascotWidget(
                              size: 175,
                              mood: _currentMood,
                              speaking:
                                  isSpeaking ||
                                  _showAudioBubble ||
                                  _showMascotBubble,
                              showGlow: true,
                            ),
                            // Tiny floating icons around mascot
                            Positioned(
                              top: 20,
                              right: 10,
                              child: _FloatingIcon(
                                icon: Icons.science,
                                color: const Color(0xFF4AD9AD),
                                animation: _bgFloatController,
                                offset: 0,
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 10,
                              child: _FloatingIcon(
                                icon: Icons.calculate,
                                color: const Color(0xFF8870E8),
                                animation: _bgFloatController,
                                offset: math.pi,
                              ),
                            ),
                            // Small animated child character
                            Positioned(
                              bottom: 0,
                              right: -40,
                              child: IgnorePointer(
                                child: const ChildCharacterWidget(
                                  size: 110,
                                  prop: ChildProp.rocket,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Speech bubbles
                      if (_showAudioBubble)
                        const SpeechBubble(
                          text: 'ठीक आहे! मी तुम्हाला सर्व काही सांगेन.',
                          speaker: 'NOVA',
                          typewriter: true,
                        )
                      else if (_showMascotBubble)
                        SpeechBubble(
                          text: _mascotMessage,
                          speaker: 'NOVA',
                          typewriter: true,
                        )
                      else
                        const SizedBox(
                          height: 52,
                        ), // Placeholder to prevent jumping

                      const SizedBox(height: AppSpacing.md),

                      // Greeting with sparkle accent
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'नमस्कार, $studentName!',
                            style: AppTextStyles.headingLarge.copyWith(
                              color: const Color(0xFF202F78),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.auto_awesome,
                            color: Color(0xFFFFD45C),
                            size: 28,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'नवीन काहीतरी शिकायला तयार आहात?',
                        style: AppTextStyles.bodySoft.copyWith(
                          color: const Color(0xFF626C94),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Primary Action: Let's Begin
                      _PremiumPrimaryButton(
                        label: 'चला सुरू करूया',
                        icon: Icons.rocket_launch_rounded,
                        gradientColors: const [
                          Color(0xFF4054C8),
                          Color(0xFF8870E8),
                        ],
                        onPressed: () {
                          HapticsService.lightImpact();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ClassSelectionScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Ganit Dangal Button
                      _PremiumPrimaryButton(
                        label: 'गणित दंगल (Ganit Dangal)',
                        icon: Icons.emoji_events_rounded,
                        iconColor: const Color(0xFFFFD45C),
                        gradientColors: const [
                          Color(0xFF202F78),
                          Color(0xFF4054C8),
                        ],
                        showMathPattern: true,
                        onPressed: () {
                          HapticsService.lightImpact();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DuelLobbyScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Audio Assistance Button
                      _PremiumSecondaryButton(
                        label: '🔊 मला ऑडिओ मदत हवी आहे',
                        onPressed: () => _onAudioHelpPressed(appState),
                      ),
                      const SizedBox(height: AppSpacing.xl),


                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                child: Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(
                      Icons.menu_rounded,
                      color: Color(0xFF202F78),
                      size: 36,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
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

class _STEMBackground extends StatelessWidget {
  final Animation<double> animation;
  const _STEMBackground({required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final floatY = math.sin(animation.value * math.pi * 2) * 15;
        return Stack(
          children: [
            // Soft gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.4),
                  radius: 1.2,
                  colors: [Color(0xFFE0E7FF), Color(0xFFF3F7FF)],
                ),
              ),
            ),
            // Floating elements
            Positioned(
              top: 100 + floatY,
              left: 40,
              child: const Icon(
                Icons.calculate_outlined,
                color: Color(0x224054C8),
                size: 40,
              ),
            ),
            Positioned(
              top: 160 - floatY,
              right: 30,
              child: const Icon(
                Icons.science_outlined,
                color: Color(0x224AD9AD),
                size: 48,
              ),
            ),
            Positioned(
              bottom: 250 + floatY * 0.8,
              left: 30,
              child: const Text(
                'π',
                style: TextStyle(
                  color: Color(0x228870E8),
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 180 - floatY,
              right: 40,
              child: const Icon(
                Icons.architecture_outlined,
                color: Color(0x22FFD45C),
                size: 45,
              ),
            ),
            Positioned(
              top: 350 + floatY * 0.5,
              left: 20,
              child: const Text(
                '+',
                style: TextStyle(
                  color: Color(0x2265B7F3),
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              top: 280 - floatY * 0.5,
              right: 20,
              child: const Text(
                '×',
                style: TextStyle(
                  color: Color(0x224054C8),
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 80 + floatY,
              left: 80,
              child: const Icon(
                Icons.star_rounded,
                color: Color(0x22FFD45C),
                size: 30,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FloatingIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Animation<double> animation;
  final double offset;

  const _FloatingIcon({
    required this.icon,
    required this.color,
    required this.animation,
    required this.offset,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final floatY = math.sin((animation.value * math.pi * 2) + offset) * 5;
        return Transform.translate(
          offset: Offset(0, floatY),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 16),
          ),
        );
      },
    );
  }
}

class _PremiumPrimaryButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final List<Color> gradientColors;
  final VoidCallback onPressed;
  final bool showMathPattern;

  const _PremiumPrimaryButton({
    required this.label,
    required this.icon,
    this.iconColor = Colors.white,
    required this.gradientColors,
    required this.onPressed,
    this.showMathPattern = false,
  });

  @override
  State<_PremiumPrimaryButton> createState() => _PremiumPrimaryButtonState();
}

class _PremiumPrimaryButtonState extends State<_PremiumPrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) {
        _scaleController.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _scaleController.reverse(),
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 0.95).animate(
          CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
        ),
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: widget.gradientColors),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: widget.gradientColors[0].withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Stack(
              children: [
                if (widget.showMathPattern)
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.08,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Text(
                            '+',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '−',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '×',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '÷',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(widget.icon, color: widget.iconColor, size: 24),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          widget.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PremiumSecondaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const _PremiumSecondaryButton({required this.label, required this.onPressed});

  @override
  State<_PremiumSecondaryButton> createState() =>
      _PremiumSecondaryButtonState();
}

class _PremiumSecondaryButtonState extends State<_PremiumSecondaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _scaleController.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _scaleController.reverse();
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _scaleController.reverse();
      },
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 0.95).animate(
          CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: _isPressed ? const Color(0xFFEEF2FF) : Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFF202F78), width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF202F78).withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isPressed ? Icons.volume_up_rounded : Icons.volume_up_outlined,
                color: const Color(0xFF202F78),
                size: 24,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    color: Color(0xFF202F78),
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

