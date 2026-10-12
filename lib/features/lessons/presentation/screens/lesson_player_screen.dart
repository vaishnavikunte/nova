import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../nova_main/theme/app_colors.dart';
import '../../../../nova_main/theme/app_text_styles.dart';
import '../../data/lesson_registry.dart';
import '../widgets/nova_character.dart';
import '../widgets/chintu_character.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lesson = LessonRegistry.getLesson(widget.standard, widget.level);
      if (lesson != null) {
        ref.read(lessonEngineProvider.notifier).loadLesson(lesson);
        ref.read(lessonEngineProvider.notifier).startLesson();
      }
    });
  }

  @override
  void dispose() {
    // Engine cleanup is handled if needed, or we just let it be GC'd.
    // Riverpod autoDispose would be better, but for now we stop manually if needed.
    // Since we don't have access to context inside dispose easily for providers in older versions,
    // we'll skip complex cleanup for this minimal implementation.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lessonState = ref.watch(lessonEngineProvider);
    final lesson = lessonState.lesson;

    if (lesson == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        ref.read(lessonEngineProvider.notifier).dispose();
      },
      child: Scaffold(
        backgroundColor: AppColors.bgLight,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.navy),
            onPressed: () {
              ref.read(lessonEngineProvider.notifier).dispose();
              Navigator.pop(context);
            },
          ),
          title: Text(
            lesson.titleEn,
            style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold),
          ),
        ),
        body: _buildBody(lessonState),
      ),
    );
  }

  Widget _buildBody(LessonState state) {
    switch (state.phase) {
      case LessonPhase.loading:
        return const Center(child: CircularProgressIndicator());
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

  Widget _buildStoryPhase(LessonState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildVisualCue(state.currentCue),
        const SizedBox(height: 16),
        _buildCharacters(state),
        const SizedBox(height: 24),
        _buildDialogueBox(state.feedbackText),
        if (state.isListening)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.mic, color: Colors.redAccent),
                const SizedBox(width: 8),
                Text(
                  "Listening... ${state.transcript}",
                  style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
      ],
    );
  }

  Widget _buildChallengePhase(LessonState state) {
    final question = state.lesson!.questions[state.currentQuestionIndex];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NovaCharacter(state: state.novaState, size: 120),
          ],
        ),
        const SizedBox(height: 16),
        _buildDialogueBox(state.feedbackText),
        const SizedBox(height: 32),
        Wrap(
          spacing: 24,
          runSpacing: 24,
          alignment: WrapAlignment.center,
          children: question.options.map((opt) => _buildOptionCard(opt)).toList(),
        ),
        if (state.isListening)
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.mic, color: Colors.redAccent),
                const SizedBox(width: 8),
                Text(
                  "Listening... ${state.transcript}",
                  style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
      ],
    );
  }

  Widget _buildSummaryPhase(LessonState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NovaCharacter(state: state.novaState, size: 150),
        const SizedBox(height: 24),
        _buildDialogueBox(state.feedbackText),
        const SizedBox(height: 24),
        ...state.lesson!.summary.summaryPoints.map(
          (pt) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(pt.displayText, style: const TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget _buildCelebrationPhase(LessonState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("🎉 You did it! 🎉", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.sunYellow)),
        const SizedBox(height: 24),
        NovaCharacter(state: state.novaState, size: 200),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy),
          onPressed: () => Navigator.pop(context),
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text("Finish", style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
        )
      ],
    );
  }

  Widget _buildCharacters(LessonState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            const Text("NOVA", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
            NovaCharacter(state: state.novaState, size: 150),
          ],
        ),
        Column(
          children: [
            const Text("Chintu", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
            ChintuCharacter(state: state.chintuState, size: 150),
          ],
        ),
      ],
    );
  }

  Widget _buildVisualCue(VisualCue cue) {
    String text = "";
    switch (cue) {
      case VisualCue.sun: text = "☀️ Sun is shining!"; break;
      case VisualCue.roof: text = "🏠 Looking at the roof"; break;
      case VisualCue.chiu: text = "🐦 Chiu Sparrow"; break;
      case VisualCue.ground: text = "🌱 Looking at the ground"; break;
      case VisualCue.ganya: text = "🐄 Ganya Calf"; break;
      case VisualCue.tractor: text = "🚜 Big Tractor"; break;
      case VisualCue.bucket: text = "🪣 Small Bucket"; break;
      case VisualCue.none: return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 10)],
      ),
      child: Text(text, style: const TextStyle(fontSize: 24)),
    );
  }

  Widget _buildDialogueBox(String text) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 10)],
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, color: AppColors.navy),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildOptionCard(QuestionOption option) {
    return GestureDetector(
      onTap: () {
        ref.read(lessonEngineProvider.notifier).submitAnswer(option.id);
      },
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.sunYellow, width: 2),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.1), blurRadius: 8)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder for real images
            Icon(
              option.id.contains('tractor') ? Icons.agriculture :
              option.id.contains('bicycle') ? Icons.pedal_bike :
              option.id.contains('chiu') ? Icons.flutter_dash :
              option.id.contains('ganya') ? Icons.cruelty_free :
              option.id.contains('morning') ? Icons.wb_sunny :
              Icons.nights_stay,
              size: 48,
              color: AppColors.indigo,
            ),
            const SizedBox(height: 12),
            Text(option.label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
