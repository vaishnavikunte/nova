import 'package:flutter/material.dart';
import '../../constants/app_strings.dart';
import '../../demo/demo_fab.dart';
import '../../models/story_beat.dart';
import '../../routes/app_routes.dart';
import '../../services/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/class_card.dart';
import '../../widgets/mascot_widget.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/speech_bubble.dart';

/// Single-screen onboarding setup capturing student name and Class (1 to 6).
class StudentSetupScreen extends StatefulWidget {
  const StudentSetupScreen({super.key});

  @override
  State<StudentSetupScreen> createState() => _StudentSetupScreenState();
}

class _StudentSetupScreenState extends State<StudentSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  int? _selectedClass;

  static const List<String> classEmojis = ['🌱', '🌟', '🧩', '🚀', '🔭', '🏆'];

  @override
  void initState() {
    super.initState();
    _selectedClass = 4; // Default to Class 4 for smooth demo start
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onContinue(AppState appState) {
    if (_selectedClass == null) return;

    final name = _nameController.text.trim().isEmpty
        ? AppStrings.defaultStudentName
        : _nameController.text.trim();

    appState.setStudentName(name);
    appState.setClassNumber(_selectedClass!);

    Navigator.pushNamed(context, AppRoutes.assessmentIntro);
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final bool canContinue = _selectedClass != null;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header with small NOVA and speech bubble
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const MascotWidget(
                            size: 72,
                            mood: NovaMood.happy,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          const Expanded(
                            child: SpeechBubble(
                              text: AppStrings.setupHeader,
                              speaker: 'NOVA',
                              typewriter: false,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Step A: Name
                      Text(
                        'Step 1: Your Name',
                        style: AppTextStyles.label.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        maxLength: 20,
                        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintText: AppStrings.namePrompt,
                          hintStyle: AppTextStyles.bodySoft,
                          prefixIcon: const Icon(Icons.badge_rounded, color: AppColors.indigo),
                          counterText: '',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Step B: Class
                      Row(
                        children: [
                          Text(
                            'Step 2: Choose Your Class',
                            style: AppTextStyles.label.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.navy,
                            ),
                          ),
                          const Spacer(),
                          if (_selectedClass == null)
                            Text(
                              AppStrings.pickClassPrompt,
                              style: AppTextStyles.labelSoft.copyWith(
                                color: AppColors.coral,
                                fontSize: 13,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // 2-column grid of 6 ClassCards
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          final cNum = index + 1;
                          return ClassCard(
                            classNumber: cNum,
                            title: 'Class $cNum',
                            iconEmoji: classEmojis[index],
                            selected: _selectedClass == cNum,
                            onTap: () {
                              setState(() {
                                _selectedClass = cNum;
                              });
                            },
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // ▶ Primary Action: [ Continue ]
                      PrimaryButton(
                        label: AppStrings.continueButton,
                        icon: Icons.arrow_forward_rounded,
                        enabled: canContinue,
                        onPressed: canContinue ? () => _onContinue(appState) : null,
                      ),
                      const SizedBox(height: AppSpacing.lg),
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
