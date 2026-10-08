import 'dart:math';

class MathQuestion {
  final String equation;
  final int answer;

  MathQuestion(this.equation, this.answer);
}

class DuelQuestionGenerator {
  /// Uses a deterministic seed to ensure both devices generate the exact same
  /// sequence of 10 math questions without needing to communicate the questions
  /// over the network or cloud servers.
  static List<MathQuestion> generateQuestions(int seed) {
    final random = Random(seed);
    final questions = <MathQuestion>[];

    for (int i = 0; i < 10; i++) {
      // Randomly pick between 2-digit addition and single-digit multiplication
      bool isAddition = random.nextBool();
      if (isAddition) {
        // 2-digit addition
        int a = 10 + random.nextInt(90);
        int b = 10 + random.nextInt(90);
        questions.add(MathQuestion('$a + $b', a + b));
      } else {
        // Single-digit multiplication
        int a = 2 + random.nextInt(8);
        int b = 2 + random.nextInt(8);
        questions.add(MathQuestion('$a × $b', a * b));
      }
    }
    
    return questions;
  }
}
