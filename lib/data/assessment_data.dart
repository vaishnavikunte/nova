
import '../models/answer_option.dart';
import '../models/assessment_question.dart';

class AssessmentData {
  AssessmentData._();

  static const Map<String, int> class4GateLevels = {
    'numbers': 1,
    'addsub': 2,
    'multiply': 3,
    'divide': 4,
    'fractions': 6,
  };

  static const List<AssessmentQuestion> class4Questions = [
    AssessmentQuestion(
      id: 'a1',
      classNumber: 4,
      skillTag: 'numbers',
      gatesLevel: 1,
      question: 'Which number is greater: 48 or 84?',
      options: [
        AnswerOptionModel(id: 'a1o1', label: '48', semanticLabel: '48'),
        AnswerOptionModel(id: 'a1o2', label: '84', semanticLabel: '84'),
        AnswerOptionModel(id: 'a1o3', label: 'Both are equal', semanticLabel: 'both are equal'),
      ],
      correctIndex: 1,
      semanticLabel: 'Choose the greater number',
      spokenAnswers: ['84'],
    ),
    AssessmentQuestion(
      id: 'a2',
      classNumber: 4,
      skillTag: 'shapes',
      question: 'How many sides does a rectangle have?',
      options: [
        AnswerOptionModel(id: 'a2o1', label: '3', semanticLabel: '3 sides'),
        AnswerOptionModel(id: 'a2o2', label: '4', semanticLabel: '4 sides'),
        AnswerOptionModel(id: 'a2o3', label: '5', semanticLabel: '5 sides'),
      ],
      correctIndex: 1,
      semanticLabel: 'Choose the number of sides',
      spokenAnswers: ['4', 'four'],
    ),
    AssessmentQuestion(
      id: 'a3',
      classNumber: 4,
      skillTag: 'addsub',
      gatesLevel: 2,
      question: 'What is 27 + 15?',
      options: [
        AnswerOptionModel(id: 'a3o1', label: '32', semanticLabel: '32'),
        AnswerOptionModel(id: 'a3o2', label: '42', semanticLabel: '42'),
        AnswerOptionModel(id: 'a3o3', label: '52', semanticLabel: '52'),
      ],
      correctIndex: 1,
      semanticLabel: 'Solve 27 plus 15',
      spokenAnswers: ['42', 'forty two'],
    ),
    AssessmentQuestion(
      id: 'a4',
      classNumber: 4,
      skillTag: 'addsub',
      gatesLevel: 2,
      question: 'What is 63 − 28?',
      options: [
        AnswerOptionModel(id: 'a4o1', label: '35', semanticLabel: '35'),
        AnswerOptionModel(id: 'a4o2', label: '45', semanticLabel: '45'),
        AnswerOptionModel(id: 'a4o3', label: '31', semanticLabel: '31'),
      ],
      correctIndex: 0,
      semanticLabel: 'Solve 63 minus 28',
      spokenAnswers: ['35', 'thirty five'],
    ),
    AssessmentQuestion(
      id: 'a5',
      classNumber: 4,
      skillTag: 'multiply',
      gatesLevel: 3,
      question: 'What is 6 × 4?',
      options: [
        AnswerOptionModel(id: 'a5o1', label: '18', semanticLabel: '18'),
        AnswerOptionModel(id: 'a5o2', label: '24', semanticLabel: '24'),
        AnswerOptionModel(id: 'a5o3', label: '28', semanticLabel: '28'),
      ],
      correctIndex: 1,
      semanticLabel: 'Solve 6 times 4',
      spokenAnswers: ['24', 'twenty four'],
    ),
    AssessmentQuestion(
      id: 'a6',
      classNumber: 4,
      skillTag: 'divide',
      gatesLevel: 4,
      question: 'What is 24 ÷ 6?',
      options: [
        AnswerOptionModel(id: 'a6o1', label: '3', semanticLabel: '3'),
        AnswerOptionModel(id: 'a6o2', label: '4', semanticLabel: '4'),
        AnswerOptionModel(id: 'a6o3', label: '5', semanticLabel: '5'),
      ],
      correctIndex: 1,
      semanticLabel: 'Solve 24 divided by 6',
      spokenAnswers: ['4', 'four'],
    ),
    AssessmentQuestion(
      id: 'a7',
      classNumber: 4,
      skillTag: 'fractions',
      gatesLevel: 6,
      question: 'Which fraction is equal to one half?',
      options: [
        AnswerOptionModel(id: 'a7o1', label: '2/4', semanticLabel: 'two fourths'),
        AnswerOptionModel(id: 'a7o2', label: '1/3', semanticLabel: 'one third'),
        AnswerOptionModel(id: 'a7o3', label: '3/4', semanticLabel: 'three fourths'),
      ],
      correctIndex: 0,
      semanticLabel: 'Choose the fraction equal to one half',
      spokenAnswers: ['2/4', 'two fourths'],
    ),
    AssessmentQuestion(
      id: 'a8',
      classNumber: 4,
      skillTag: 'patterns',
      question: 'What comes next: 5, 10, 15, __?',
      options: [
        AnswerOptionModel(id: 'a8o1', label: '20', semanticLabel: '20'),
        AnswerOptionModel(id: 'a8o2', label: '25', semanticLabel: '25'),
        AnswerOptionModel(id: 'a8o3', label: '30', semanticLabel: '30'),
      ],
      correctIndex: 0,
      semanticLabel: 'Continue the pattern',
      spokenAnswers: ['20', 'twenty'],
    ),
  ];

  static List<AssessmentQuestion> getQuestionsForClass(int classNumber) {
    // Class 4 is the semester demo curriculum. Other classes reuse the
    // same assessment structure with classNumber changed for UI navigation.
    if (classNumber == 4) return class4Questions;
    return class4Questions
        .map((q) => AssessmentQuestion(
              id: '${q.id}_c$classNumber',
              classNumber: classNumber,
              skillTag: q.skillTag,
              gatesLevel: q.gatesLevel,
              question: q.question,
              visualType: q.visualType,
              visualData: q.visualData,
              options: q.options,
              correctIndex: q.correctIndex,
              semanticLabel: q.semanticLabel,
              spokenAnswers: q.spokenAnswers,
            ))
        .toList();
  }
}
