import 'dart:async';
import 'package:flutter/material.dart';
import '../../constants/app_strings.dart';
import '../../data/assessment_data.dart';
import '../../data/feedback_messages.dart';
import '../../demo/demo_fab.dart';
import '../../models/answer_option.dart';
import '../../models/assessment_question.dart';
import '../../models/story_beat.dart';
import '../../routes/app_routes.dart';
import '../../services/app_state.dart';
import '../../services/assessment_service.dart';
import '../../services/haptics_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/adventure_progress_indicator.dart';
import '../../widgets/answer_option_widget.dart';
import '../../widgets/fraction_visual.dart';
import '../../widgets/mascot_widget.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/shape_visual.dart';

/// 8-question assessment flow with star trail progress, gentle positive feedback, and thinking transition.
class AssessmentQuestionScreen extends StatefulWidget {
  const AssessmentQuestionScreen({super.key});

  @override
  State<AssessmentQuestionScreen> createState() => _AssessmentQuestionScreenState();
}

class _AssessmentQuestionScreenState extends State<AssessmentQuestionScreen> {
  int _currentIndex = 0;
  final List<int> _selectedIndices = [];
  int? _tappedOptionIndex;
  OptionState _optionState = OptionState.idle;
  String? _reactionChipText;
  bool _isInputLocked = false;
  bool _isThinking = false;
  String _thinkingText = AppStrings.thinkingMsg1;

  late List<AssessmentQuestion> _questions;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appState = AppStateScope.of(context);
    _questions = AssessmentData.getQuestionsForClass(appState.student.classNumber);
  }

  void _onOptionTapped(int index) {
    if (_isInputLocked) return;

    final currentQ = _questions[_currentIndex];
    final bool isCorrect = index == currentQ.correctIndex;

    setState(() {
      _isInputLocked = true;
      _tappedOptionIndex = index;
      _optionState = isCorrect ? OptionState.correct : OptionState.gentleTryAgain;
      _reactionChipText = isCorrect
          ? FeedbackMessages.correctAnswers[index % FeedbackMessages.correctAnswers.length]
          : FeedbackMessages.gentleTryAgain[index % FeedbackMessages.gentleTryAgain.length];
    });

    _selectedIndices.add(index);

    // Auto-advance after 1.2s
    Timer(const Duration(milliseconds: 1200), _nextQuestionOrFinish);
  }

  void _nextQuestionOrFinish() {
    if (!mounted) return;

    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _tappedOptionIndex = null;
        _optionState = OptionState.idle;
        _reactionChipText = null;
        _isInputLocked = false;
      });
    } else {
      _showThinkingTransition();
    }
  }

  void _showThinkingTransition() {
    setState(() {
      _isThinking = true;
    });

    Timer(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _thinkingText = AppStrings.thinkingMsg2;
        });
      }
    });

    Timer(const Duration(milliseconds: 1600), () {
      if (mounted) {
        final appState = AppStateScope.of(context);
        final outcome = AssessmentService.evaluate(
          questions: _questions,
          selectedOptionIndices: _selectedIndices,
          gateLevels: AssessmentData.class4GateLevels,
        );
        appState.submitAssessment(outcome);
        Navigator.pushReplacementNamed(context, AppRoutes.assessmentResult);
      }
    });
  }

  void _onExitPressed() {
    HapticsService.lightImpact();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.roundedCard),
        title: Text(AppStrings.pauseAdventureTitle, style: AppTextStyles.questionText),
        content: Text(AppStrings.exitAssessmentConfirm, style: AppTextStyles.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppStrings.stayButton, style: AppTextStyles.buttonSecondary),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.coral),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.welcome, (r) => false);
            },
            child: Text(AppStrings.leaveButton, style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isThinking) {
      return _buildThinkingScreen();
    }

    final currentQ = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Top Progress Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: AppColors.inkSoft, size: 28),
                        onPressed: _onExitPressed,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            AdventureProgressIndicator(
                              current: _currentIndex + 1,
                              total: _questions.length,
                              useStars: true,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Step ${_currentIndex + 1} of ${_questions.length} of your adventure',
                              style: AppTextStyles.labelSoft.copyWith(fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      // Small corner NOVA
                      MascotWidget(
                        size: 46,
                        mood: _optionState == OptionState.correct
                            ? NovaMood.celebrating
                            : (_optionState == OptionState.gentleTryAgain
                                ? NovaMood.encouraging
                                : NovaMood.happy),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Question Body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Question Card
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
                                  Text(
                                    currentQ.question,
                                    style: AppTextStyles.questionText,
                                    textAlign: TextAlign.center,
                                  ),
                                  if (currentQ.visualType != VisualType.none) ...[
                                    const SizedBox(height: AppSpacing.md),
                                    _buildQuestionVisual(currentQ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),

                            // Reaction chip if an answer was tapped
                            if (_reactionChipText != null)
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: _optionState == OptionState.correct
                                        ? const Color(0xFFE8FBF4)
                                        : const Color(0xFFFFF1F0),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: _optionState == OptionState.correct
                                          ? AppColors.mint
                                          : AppColors.coral,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Text(
                                    _reactionChipText!,
                                    style: AppTextStyles.label.copyWith(
                                      color: _optionState == OptionState.correct
                                          ? const Color(0xFF065F46)
                                          : const Color(0xFF991B1B),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(height: AppSpacing.sm),

                            // Options List
                            for (int i = 0; i < currentQ.options.length; i++) ...[
                              AnswerOptionWidget(
                                option: currentQ.options[i],
                                index: i,
                                state: _tappedOptionIndex == i
                                    ? _optionState
                                    : (_isInputLocked ? OptionState.disabled : OptionState.idle),
                                onTap: () => _onOptionTapped(i),
                              ),
                            ],
                            const SizedBox(height: AppSpacing.lg),

                            // Fallback manual advance button if auto-advance doesn't trigger
                            if (_isInputLocked)
                              PrimaryButton(
                                label: 'Next ▶',
                                onPressed: _nextQuestionOrFinish,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const DemoFab(),
        ],
      ),
    );
  }

  Widget _buildThinkingScreen() {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const MascotWidget(
                size: 160,
                mood: NovaMood.thinking,
                showGlow: true,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                AppStrings.thinkingTitle,
                style: AppTextStyles.headingLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _thinkingText,
                  key: ValueKey(_thinkingText),
                  style: AppTextStyles.questionText.copyWith(
                    color: AppColors.purple,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.indigo),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionVisual(AssessmentQuestion q) {
    switch (q.visualType) {
      case VisualType.customShapes:
        return ShapeVisual(shape: q.visualData ?? 'square', size: 68);
      case VisualType.fractionCircles:
      case VisualType.fractionBars:
      case VisualType.pizza:
        return FractionVisual(fractionStr: q.visualData ?? '1/2', type: q.visualType, size: 76);
      case VisualType.arrayDots:
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.softGrey, borderRadius: BorderRadius.circular(10)),
          child: const Text('• • • • • • •\n• • • • • • •\n• • • • • • •\n• • • • • • •\n• • • • • • •\n• • • • • • •', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, letterSpacing: 4, height: 1.2)),
        );
      case VisualType.groupedDots:
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.softGrey, borderRadius: BorderRadius.circular(10)),
          child: const Text('( • • • • • • )  ( • • • • • • )\n( • • • • • • )  ( • • • • • • )', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, height: 1.4)),
        );
      case VisualType.patternStrip:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(12)),
          child: const Text('2  ➔  4  ➔  6  ➔  ❓', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.indigo)),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
