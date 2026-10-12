import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../nova_main/services/app_state.dart';
import '../../../../nova_main/theme/app_colors.dart';
import '../../../../nova_main/widgets/confetti_overlay.dart';
import '../../data/lesson_registry.dart';
import '../widgets/nova_character.dart';
import '../widgets/chintu_character.dart';
import '../widgets/match_pairs_widget.dart';
import '../../domain/engine/lesson_engine.dart';
import '../../domain/models/lesson_models.dart';

class LessonPlayerScreen extends ConsumerStatefulWidget {
  final int standard;
  final int level;

  const LessonPlayerScreen({
    super.key,
    required this.standard,
    required this.level,
  });

  @override
  ConsumerState<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends ConsumerState<LessonPlayerScreen> {
  bool _isLessonLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isLessonLoaded) {
        final lesson = LessonRegistry.getLesson(widget.standard, widget.level);
        if (lesson != null) {
          _isLessonLoaded = true;
          ref.read(lessonEngineProvider.notifier).loadLesson(lesson);
          ref.read(lessonEngineProvider.notifier).startLesson();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lessonState = ref.watch(lessonEngineProvider);
    final lesson = lessonState.lesson;

    if (lesson == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFFBF8F2),
        body: Center(
          child: CircularProgressIndicator(color: AppColors.purple),
        ),
      );
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        ref.read(lessonEngineProvider.notifier).dispose();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFBF8F2),
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  _buildTopBar(lesson, lessonState),
                  _buildSegmentedProgress(lessonState),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: _buildPhaseContent(lessonState),
                    ),
                  ),
                ],
              ),
            ),
            if (lessonState.phase == LessonPhase.celebration)
              const Positioned.fill(
                child: IgnorePointer(
                  child: ConfettiOverlay(play: true),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Top Bar & Progress
  // ---------------------------------------------------------------------------

  Widget _buildTopBar(Lesson lesson, LessonState state) {
    String stepIndicator = '';
    if (state.phase == LessonPhase.story) {
      stepIndicator = 'गोष्ट · ${state.currentBeatIndex + 1}/${lesson.beats.length}';
    } else if (state.phase == LessonPhase.challenge) {
      stepIndicator = 'प्रश्न · ${state.currentQuestionIndex + 1}/${lesson.questions.length}';
    } else if (state.phase == LessonPhase.summary) {
      stepIndicator = 'पुनरावलोकन · Summary';
    } else if (state.phase == LessonPhase.celebration) {
      stepIndicator = 'अभिनंदन! · Celebration';
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.navy, size: 28),
            onPressed: () {
              ref.read(lessonEngineProvider.notifier).dispose();
              Navigator.pop(context);
            },
            tooltip: 'Back to Levels',
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Level ${widget.level} · ${lesson.titleEn}',
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  stepIndicator,
                  style: const TextStyle(
                    color: AppColors.purple,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Sound toggle
          IconButton(
            icon: Icon(
              state.isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
              color: state.isMuted ? Colors.grey : AppColors.purple,
              size: 26,
            ),
            onPressed: () {
              ref.read(lessonEngineProvider.notifier).toggleSound();
            },
            tooltip: state.isMuted ? 'Unmute narration' : 'Mute narration',
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedProgress(LessonState state) {
    int activePhaseIndex = 0;
    if (state.phase == LessonPhase.story) {
      activePhaseIndex = 0;
    } else if (state.phase == LessonPhase.challenge) {
      activePhaseIndex = 1;
    } else if (state.phase == LessonPhase.summary) {
      activePhaseIndex = 2;
    } else {
      activePhaseIndex = 3;
    }

    final phases = ['गोष्ट (Story)', 'खेळ (Quiz)', 'शिकलो (Summary)', 'बक्षीस (Done)'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: List.generate(phases.length, (index) {
          final isDone = index < activePhaseIndex;
          final isCurrent = index == activePhaseIndex;

          Color color;
          if (isDone) {
            color = const Color(0xFF10B981);
          } else if (isCurrent) {
            color = AppColors.purple;
          } else {
            color = const Color(0xFFE2E8F0);
          }

          return Expanded(
            child: Container(
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Phase Routing
  // ---------------------------------------------------------------------------

  Widget _buildPhaseContent(LessonState state) {
    switch (state.phase) {
      case LessonPhase.loading:
        return const Center(child: CircularProgressIndicator(color: AppColors.purple));
      case LessonPhase.story:
        return _buildStoryPhase(state);
      case LessonPhase.challenge:
        return _buildChallengePhase(state);
      case LessonPhase.summary:
        return _buildSummaryPhase(state);
      case LessonPhase.celebration:
        return _buildCelebrationPhase(state);
    }
  }

  // ---------------------------------------------------------------------------
  // Screen A: Dedicated Story Experience
  // ---------------------------------------------------------------------------

  Widget _buildStoryPhase(LessonState state) {
    final beat = state.lesson!.beats[state.currentBeatIndex];

    String chapterTitle = '🌞 A New Morning';
    if (beat.id.contains('top_bottom')) {
      chapterTitle = '🏠 Top and Bottom · वर आणि खाली';
    } else if (beat.id.contains('big_small')) {
      chapterTitle = '🚜 Big and Small · मोठा आणि छोटी';
    }

    return Column(
      children: [
        // Chapter Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF59E0B), width: 1.2),
          ),
          child: Text(
            chapterTitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF92400E),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Village Stage Illustration with Visual Cues
        _buildVillageStage(state),

        const SizedBox(height: 16),

        // NOVA Dialogue Bubble
        _buildSpeechBubble(state.feedbackText, isSpeaking: state.isPlayingAudio),

        if (state.isListening)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.mic, color: Colors.redAccent, size: 24),
                const SizedBox(width: 8),
                Text(
                  "ऐकत आहे... ${state.transcript}",
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 20),

        // Story Controls: [Listen Again] [Next] [Skip Story]
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.navy,
                side: const BorderSide(color: AppColors.purple, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onPressed: () {
                ref.read(lessonEngineProvider.notifier).replayCurrentBeat();
              },
              icon: const Icon(Icons.replay_rounded, size: 20),
              label: const Text('Listen Again', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.purple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                elevation: 3,
              ),
              onPressed: () {
                ref.read(lessonEngineProvider.notifier).nextBeat();
              },
              icon: const Icon(Icons.arrow_forward_rounded, size: 20),
              label: Text(
                state.currentBeatIndex + 1 < state.lesson!.beats.length ? 'Next' : 'चला, खेळूया! (Play)',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
              ),
              onPressed: () {
                ref.read(lessonEngineProvider.notifier).skipStory();
              },
              child: const Text('Skip Story', style: TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVillageStage(LessonState state) {
    final cue = state.currentCue;
    final beatIndex = state.currentBeatIndex;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 250, maxHeight: 290),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFBAE6FD), // Bright morning sky
            Color(0xFFFEF3C7), // Warm sunshine horizon
            Color(0xFFD1FAE5), // Grassy village floor
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Beat 1 Environment: Rising Sun
            if (beatIndex == 0)
              Positioned(
                top: 20,
                right: 30,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDE68A),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
                        blurRadius: 16,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.wb_sunny_rounded, color: Color(0xFFD97706), size: 48),
                ),
              ),

            // Beat 2 Environment: Roof & Ground Cues
            if (beatIndex == 1) ...[
              // Roof on top with Chiu Sparrow
              Positioned(
                top: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: (cue == VisualCue.roof || cue == VisualCue.chiu)
                        ? const Color(0xFFFEF08A)
                        : Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: (cue == VisualCue.roof || cue == VisualCue.chiu)
                          ? const Color(0xFFD97706)
                          : const Color(0xFF3B82F6),
                      width: 2,
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.roofing_rounded, color: Color(0xFFB45309), size: 24),
                      SizedBox(width: 6),
                      Text(
                        'वर (Top) · छतावर चिऊताई 🐦',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
                      ),
                    ],
                  ),
                ),
              ),
              // Ground at bottom with Ganya Calf
              Positioned(
                bottom: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: (cue == VisualCue.ground || cue == VisualCue.ganya)
                        ? const Color(0xFFBBF7D0)
                        : Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: (cue == VisualCue.ground || cue == VisualCue.ganya)
                          ? const Color(0xFF16A34A)
                          : const Color(0xFF10B981),
                      width: 2,
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.grass_rounded, color: Color(0xFF15803D), size: 24),
                      SizedBox(width: 6),
                      Text(
                        'खाली (Bottom) · जमिनीवर गण्या वासरू 🐄',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Beat 3 Environment: Big Tractor vs Small Bucket Cues
            if (beatIndex == 2) ...[
              Positioned(
                top: 14,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: cue == VisualCue.tractor
                            ? const Color(0xFFFEF08A)
                            : Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.purple, width: 1.5),
                      ),
                      child: const Text('🚜 मोठा · Big Tractor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: cue == VisualCue.bucket
                            ? const Color(0xFFBAE6FD)
                            : Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF0284C7), width: 1.5),
                      ),
                      child: const Text('🪣 छोटी · Small Bucket', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
              ),
            ],

            // Real Rive Characters: NOVA and Chintu
            Positioned(
              bottom: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('NOVA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.navy)),
                      ),
                      NovaCharacter(state: state.novaState, size: 125),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Chintu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.navy)),
                      ),
                      ChintuCharacter(state: state.chintuState, size: 125),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Screen B, C, D: Challenge Phase
  // ---------------------------------------------------------------------------

  Widget _buildChallengePhase(LessonState state) {
    final question = state.lesson!.questions[state.currentQuestionIndex];

    return Column(
      children: [
        // Character Row with Question Header
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NovaCharacter(state: state.novaState, size: 95),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSpeechBubble(
                state.feedbackText.isNotEmpty ? state.feedbackText : question.prompt.displayText,
                isSpeaking: state.isPlayingAudio,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Activity Dispatch: Picture MCQ vs Match-Pairs
        if (question.type == QuestionType.matchPairs)
          MatchPairsWidget(
            question: question,
            completedPairIds: state.completedPairIds,
            isAllCompleted: state.completedPairIds.length >= question.matchingPairs.length,
            onPairMatchAttempt: (left, right) {
              ref.read(lessonEngineProvider.notifier).submitPairMatch(left, right);
            },
            onContinue: () {
              ref.read(lessonEngineProvider.notifier).nextQuestion();
            },
          )
        else
          _buildPictureMcqArea(question, state),

        if (state.isListening)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.mic, color: Colors.redAccent, size: 24),
                const SizedBox(width: 8),
                Text(
                  "ऐकत आहे... ${state.transcript}",
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildPictureMcqArea(LessonQuestion question, LessonState state) {
    return Column(
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: question.options.map((opt) {
            final isSelected = state.selectedOptionId == opt.id;
            final isCorrect = state.isCorrectAnswer == true && isSelected;
            final isIncorrect = state.isCorrectAnswer == false && isSelected;

            return _buildOptionCard(
              opt,
              isSelected: isSelected,
              isCorrect: isCorrect,
              isIncorrect: isIncorrect,
              onTap: () {
                ref.read(lessonEngineProvider.notifier).submitAnswer(opt.id);
              },
            );
          }).toList(),
        ),

        const SizedBox(height: 20),

        // Continue Button when answer is correct
        if (state.showContinueButton)
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.purple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              elevation: 4,
            ),
            onPressed: () {
              ref.read(lessonEngineProvider.notifier).nextQuestion();
            },
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text(
              'पुढे चला (Continue)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          )
        else
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.navy,
              side: const BorderSide(color: AppColors.purple, width: 1.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onPressed: () {
              ref.read(lessonEngineProvider.notifier).replayCurrentQuestion();
            },
            icon: const Icon(Icons.volume_up_rounded, size: 20),
            label: const Text('Replay Prompt', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
      ],
    );
  }

  Widget _buildOptionCard(
    QuestionOption option, {
    required bool isSelected,
    required bool isCorrect,
    required bool isIncorrect,
    required VoidCallback onTap,
  }) {
    Color borderColor;
    Color bgColor;

    if (isCorrect) {
      borderColor = const Color(0xFF10B981);
      bgColor = const Color(0xFFECFDF5);
    } else if (isIncorrect) {
      borderColor = const Color(0xFFF59E0B);
      bgColor = const Color(0xFFFFFBEB);
    } else if (isSelected) {
      borderColor = AppColors.purple;
      bgColor = const Color(0xFFF3E8FF);
    } else {
      borderColor = const Color(0xFFE2E8F0);
      bgColor = Colors.white;
    }

    IconData iconData;
    Color iconColor;

    if (option.id.contains('tractor')) {
      iconData = Icons.agriculture_rounded;
      iconColor = const Color(0xFF15803D);
    } else if (option.id.contains('bicycle')) {
      iconData = Icons.pedal_bike_rounded;
      iconColor = const Color(0xFF0284C7);
    } else if (option.id.contains('chiu')) {
      iconData = Icons.flutter_dash_rounded;
      iconColor = const Color(0xFFD97706);
    } else if (option.id.contains('ganya')) {
      iconData = Icons.pets_rounded;
      iconColor = const Color(0xFF475569);
    } else if (option.id.contains('morning')) {
      iconData = Icons.wb_sunny_rounded;
      iconColor = const Color(0xFFF59E0B);
    } else {
      iconData = Icons.nights_stay_rounded;
      iconColor = const Color(0xFF6366F1);
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 155,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor,
            width: isSelected || isCorrect ? 2.5 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isSelected ? 0.12 : 0.05),
              blurRadius: isSelected ? 10 : 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, size: 36, color: iconColor),
            ),
            const SizedBox(height: 10),
            Text(
              option.label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isCorrect ? const Color(0xFF047857) : AppColors.navy,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (option.sublabel != null) ...[
              const SizedBox(height: 2),
              Text(
                option.sublabel!,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (isCorrect) ...[
              const SizedBox(height: 6),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 18),
                  SizedBox(width: 4),
                  Text('बरोबर!', style: TextStyle(color: Color(0xFF047857), fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Screen E: Summary & Celebration Phase
  // ---------------------------------------------------------------------------

  Widget _buildSummaryPhase(LessonState state) {
    return Column(
      children: [
        NovaCharacter(state: state.novaState, size: 110),
        const SizedBox(height: 12),
        _buildSpeechBubble(state.feedbackText, isSpeaking: state.isPlayingAudio),
        const SizedBox(height: 20),
        _buildSummaryPointsCard(state.lesson!.summary),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.purple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            elevation: 4,
          ),
          onPressed: () {
            ref.read(lessonEngineProvider.notifier).nextQuestion();
          },
          icon: const Icon(Icons.celebration_rounded),
          label: const Text('बक्षीस बघा (See Rewards)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildCelebrationPhase(LessonState state) {
    final appState = AppStateScope.of(context);

    return Column(
      children: [
        const SizedBox(height: 8),
        const Text(
          "🎉 शाब्बास! तू जिंकलास! 🎉",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF92400E),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        const Text(
          "तू आज खूप छान शिकलास!",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 16),

        // 3 Large Gold Stars
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              child: const Icon(
                Icons.star_rounded,
                color: Color(0xFFF59E0B),
                size: 54,
              ),
            );
          }),
        ),

        const SizedBox(height: 16),

        // Characters Together
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NovaCharacter(state: state.novaState, size: 120),
            const SizedBox(width: 16),
            ChintuCharacter(state: state.chintuState, size: 120),
          ],
        ),

        const SizedBox(height: 20),

        // Learning Recap
        _buildSummaryPointsCard(state.lesson!.summary),

        const SizedBox(height: 24),

        // Actions: [Play Again] [Back to Levels]
        Wrap(
          spacing: 16,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.navy,
                side: const BorderSide(color: AppColors.purple, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                ref.read(lessonEngineProvider.notifier).resetLesson();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Play Again', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.purple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                elevation: 4,
              ),
              onPressed: () {
                // Persist completion in AppState
                appState.completeLevel();
                ref.read(lessonEngineProvider.notifier).dispose();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.home_rounded),
              label: const Text('Back to Levels', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSummaryPointsCard(LessonSummary summary) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_stories_rounded, color: AppColors.purple, size: 22),
              SizedBox(width: 8),
              Text(
                'आज आपण काय शिकलो? (What we learned)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.navy),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...summary.summaryPoints.map((point) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('⭐ ', style: TextStyle(fontSize: 14)),
                  Expanded(
                    child: Text(
                      point.displayText,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Dialogue Box / Speech Bubble
  // ---------------------------------------------------------------------------

  Widget _buildSpeechBubble(String text, {bool isSpeaking = false}) {
    if (text.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSpeaking ? AppColors.purple : const Color(0xFFCBD5E1),
          width: isSpeaking ? 2.0 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isSpeaking ? 0.08 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSpeaking) ...[
            const Icon(Icons.graphic_eq_rounded, color: AppColors.purple, size: 20),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.navy,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
