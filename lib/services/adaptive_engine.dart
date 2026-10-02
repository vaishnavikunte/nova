import 'dart:math';
import '../data/feedback_messages.dart';
import '../models/emotion_state.dart';
import '../models/question_model.dart';

/// Result of evaluating an answer through the adaptive pedagogical engine.
class AdaptiveEvaluation {
  final bool isCorrect;
  final EmotionState emotion;
  final int nextTier;
  final String message;
  final bool showHint;
  final bool showSimplified;
  final List<String> stepByStepSteps;

  const AdaptiveEvaluation({
    required this.isCorrect,
    required this.emotion,
    required this.nextTier,
    required this.message,
    this.showHint = false,
    this.showSimplified = false,
    this.stepByStepSteps = const [],
  });
}

/// History entry for a question attempt within the current level session.
class QuestionAttempt {
  final bool isCorrect;
  final int hintsUsed;

  const QuestionAttempt({
    required this.isCorrect,
    required this.hintsUsed,
  });
}

/// Adaptive engine implementing deterministic pedagogical state inference.
class AdaptiveEngine {
  AdaptiveEngine._();

  /// Infers student emotional state based on session history signals.
  static EmotionState inferEmotion({
    required List<QuestionAttempt> sessionHistory,
    required int currentQuestionHintsUsed,
    required bool currentAnswerCorrect,
    EmotionState? forcedEmotion,
  }) {
    if (forcedEmotion != null) {
      return forcedEmotion;
    }

    // Build complete history including current attempt
    final history = [
      ...sessionHistory,
      QuestionAttempt(isCorrect: currentAnswerCorrect, hintsUsed: currentQuestionHintsUsed),
    ];

    final int totalAttempts = history.length;
    final int notCorrectCount = history.where((a) => !a.isCorrect).length;

    // Rule 1: Frustrated check
    // 2 not-correct in a row, OR all 3 hints used, OR >= 3 not-correct in session
    bool twoWrongInARow = false;
    if (totalAttempts >= 2) {
      if (!history[totalAttempts - 1].isCorrect && !history[totalAttempts - 2].isCorrect) {
        twoWrongInARow = true;
      }
    }

    if (twoWrongInARow || currentQuestionHintsUsed >= 3 || notCorrectCount >= 3) {
      return EmotionState.frustrated;
    }

    // Rule 2: Confused check
    // 1 not-correct answer, OR 1-2 hints on current question
    if (!currentAnswerCorrect || (currentQuestionHintsUsed >= 1 && currentQuestionHintsUsed <= 2)) {
      return EmotionState.confused;
    }

    // Rule 3: Confident check
    // 2 correct answers in a row, 0 hints on both
    if (totalAttempts >= 2) {
      final last1 = history[totalAttempts - 1];
      final last2 = history[totalAttempts - 2];
      if (last1.isCorrect && last1.hintsUsed == 0 && last2.isCorrect && last2.hintsUsed == 0) {
        return EmotionState.confident;
      }
    }

    // Rule 4: Otherwise neutral
    return EmotionState.neutral;
  }

  /// Evaluates answer attempt and computes pedagogical adaptation.
  static AdaptiveEvaluation evaluate({
    required QuestionModel question,
    required int selectedIndex,
    required int currentTier,
    required List<QuestionAttempt> sessionHistory,
    required int currentQuestionHintsUsed,
    EmotionState? forcedEmotion,
    bool? forcedAnswerOutcome,
  }) {
    final bool isCorrect = forcedAnswerOutcome ?? (selectedIndex == question.correctIndex);

    final emotion = inferEmotion(
      sessionHistory: sessionHistory,
      currentQuestionHintsUsed: currentQuestionHintsUsed,
      currentAnswerCorrect: isCorrect,
      forcedEmotion: forcedEmotion,
    );

    int nextTier = currentTier;
    bool showHint = false;
    bool showSimplified = false;
    List<String> stepByStep = [];

    switch (emotion) {
      case EmotionState.confident:
        nextTier = min(3, currentTier + 1);
        break;
      case EmotionState.confused:
        nextTier = currentTier;
        showHint = true;
        break;
      case EmotionState.frustrated:
        nextTier = max(1, currentTier - 1);
        showSimplified = true;
        stepByStep = [
          'Step 1: Notice what the puzzle gives us.',
          'Step 2: Take it apart one small piece at a time.',
          'Step 3: Combine the pieces to see the solution!',
        ];
        break;
      case EmotionState.neutral:
        nextTier = currentTier;
        break;
    }

    String message;
    if (isCorrect) {
      message = FeedbackMessages.forEmotion(emotion);
    } else {
      message = FeedbackMessages.gentleTryAgain[
          Random().nextInt(FeedbackMessages.gentleTryAgain.length)];
    }

    return AdaptiveEvaluation(
      isCorrect: isCorrect,
      emotion: emotion,
      nextTier: nextTier,
      message: message,
      showHint: showHint,
      showSimplified: showSimplified,
      stepByStepSteps: stepByStep,
    );
  }
}
