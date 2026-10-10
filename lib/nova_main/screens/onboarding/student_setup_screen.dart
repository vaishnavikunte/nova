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
import '../../widgets/child_character_widget.dart';

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
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppSpacing.maxContentWidth,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Cartoon child peeking from top-left
                      Row(
                        children: [
                          const ChildCharacterWidget(
                            size: 100,
                            prop: ChildProp.rocket,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'चला, शिकायला सुरुवात करूया!',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'तुमचं नाव सांगा आणि आपण सुरू करूया!',
                                  style: AppTextStyles.body.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Name Input
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          maxLength: 20,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                          decoration: InputDecoration(
                            hintText: 'तुमचं नाव लिहा...',
                            hintStyle: TextStyle(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                              fontWeight: FontWeight.bold,
                            ),
                            prefixIcon: Icon(
                              Icons.face_rounded,
                              color: Theme.of(context).colorScheme.primary,
                              size: 30,
                            ),
                            counterText: '',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Step B: Class
                      Text(
                        'तुम्ही कोणत्या इयत्तेत आहात?',
                        style: AppTextStyles.label.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // 2-column grid of 6 ClassCards
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          backgroundColor: const Color(
                            0xFFFFD65A,
                          ), // Sunny yellow
                          foregroundColor: const Color(
                            0xFF2F185E,
                          ), // Dark purple text
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 6,
                        ),
                        onPressed: canContinue
                            ? () => _onContinue(appState)
                            : null,
                        icon: const Icon(Icons.rocket_launch_rounded, size: 28),
                        label: const Text(
                          'चला सुरू करूया',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
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
