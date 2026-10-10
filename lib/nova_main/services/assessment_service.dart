import '../models/assessment_question.dart';

class AssessmentOutcome {
  final int recommendedLevel;
  final Map<String, double> skillMastery;
  final int correctCount;
  final int totalQuestions;

  const AssessmentOutcome({
    required this.recommendedLevel,
    required this.skillMastery,
    required this.correctCount,
    required this.totalQuestions,
  });
}

/// Deterministic local placement logic for the UI prototype.
class AssessmentService {
  AssessmentService._();

  static AssessmentOutcome evaluate({
    required List<AssessmentQuestion> questions,
    required List<int> selectedOptionIndices,
    required Map<String, int> gateLevels,
  }) {
    final scores = <String, List<bool>>{};
    var correct = 0;

    for (var i = 0; i < questions.length; i++) {
      final q = questions[i];
      final selected = i < selectedOptionIndices.length
          ? selectedOptionIndices[i]
          : -1;
      final isCorrect = selected == q.correctIndex;
      if (isCorrect) correct++;
      scores.putIfAbsent(q.skillTag, () => <bool>[]).add(isCorrect);
    }

    final mastery = <String, double>{
      for (final entry in scores.entries)
        entry.key: entry.value.where((v) => v).length / entry.value.length,
    };

    // Each gated skill that is demonstrated unlocks its corresponding level.
    // The highest failed gate becomes the safe starting point.
    var recommended = 1;
    for (final entry in gateLevels.entries) {
      final masteryScore = mastery[entry.key] ?? 0;
      if (masteryScore >= 0.5) {
        recommended = entry.value;
      } else {
        break;
      }
    }

    // Strong overall performance can begin one step beyond the last gate.
    if (questions.isNotEmpty && correct / questions.length >= 0.875) {
      recommended = (recommended + 1).clamp(1, 15);
    }

    return AssessmentOutcome(
      recommendedLevel: recommended,
      skillMastery: mastery,
      correctCount: correct,
      totalQuestions: questions.length,
    );
  }
}
