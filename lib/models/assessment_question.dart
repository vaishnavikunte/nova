import 'answer_option.dart';

/// Question used in the 8-question placement assessment.
class AssessmentQuestion {
  final String id;
  final int classNumber;
  final String skillTag; // numbers, shapes, addsub, multiply, divide, fractions, patterns
  final int? gatesLevel; // null for non-gating warmups like shapes and patterns
  final String question;
  final VisualType visualType;
  final String? visualData;
  final List<AnswerOptionModel> options;
  final int correctIndex;
  final String semanticLabel;
  final List<String> spokenAnswers;

  const AssessmentQuestion({
    required this.id,
    required this.classNumber,
    required this.skillTag,
    this.gatesLevel,
    required this.question,
    this.visualType = VisualType.none,
    this.visualData,
    required this.options,
    required this.correctIndex,
    required this.semanticLabel,
    this.spokenAnswers = const [],
  });
}
