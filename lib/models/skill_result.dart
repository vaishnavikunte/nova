import '../constants/app_strings.dart';

class SkillResult {
  final String skillTag;
  final String displayName;
  final String emoji;
  final int correct;
  final int asked;

  const SkillResult({
    required this.skillTag,
    required this.displayName,
    required this.emoji,
    required this.correct,
    required this.asked,
  });

  double get mastery => asked > 0 ? (correct / asked).clamp(0.0, 1.0) : 0.0;

  String get positiveLabel {
    final m = mastery;
    if (m >= 0.8) {
      return AppStrings.masterySuper;
    } else if (m >= 0.5) {
      return AppStrings.masteryGrowing;
    } else {
      return AppStrings.masteryExplore;
    }
  }

  SkillResult copyWith({
    int? correct,
    int? asked,
  }) {
    return SkillResult(
      skillTag: skillTag,
      displayName: displayName,
      emoji: emoji,
      correct: correct ?? this.correct,
      asked: asked ?? this.asked,
    );
  }
}
