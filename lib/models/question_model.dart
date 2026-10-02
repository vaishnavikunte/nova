import 'answer_option.dart';

class QuestionModel {
  final String id;
  final String prompt;
  final VisualType visualType;
  final String? visualData;
  final List<AnswerOptionModel> options;
  final int correctIndex;
  final int tier;
  final List<String> hints;
  final String explanation;
  final List<String> spokenAnswers;

  const QuestionModel({
    required this.id,
    required this.prompt,
    this.visualType = VisualType.none,
    this.visualData,
    required this.options,
    required this.correctIndex,
    required this.tier,
    required this.hints,
    required this.explanation,
    required this.spokenAnswers,
  })  : assert(options.length >= 3, 'Must have at least 3 options'),
        assert(correctIndex >= 0 && correctIndex < options.length, 'correctIndex out of range'),
        assert(tier >= 1 && tier <= 3, 'Tier must be 1, 2, or 3'),
        assert(hints.length == 3, 'Must provide exactly 3 progressive hints'),
        assert(spokenAnswers.length > 0, 'Spoken answers list must not be empty');
}
