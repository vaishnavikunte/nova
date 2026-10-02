
import '../models/answer_option.dart';
import '../models/class_course.dart';
import '../models/level_model.dart';
import '../models/question_model.dart';
import '../models/story_beat.dart';

class CurriculumData {
  CurriculumData._();

  static Map<int, ClassCourse> buildAllCourses() {
    return {
      for (var classNumber = 1; classNumber <= 6; classNumber++)
        classNumber: _buildCourse(classNumber),
    };
  }

  static ClassCourse _buildCourse(int classNumber) {
    final levels = <LevelModel>[];

    for (var number = 1; number <= 15; number++) {
      if (classNumber == 4 && number <= 5) {
        levels.add(_class4Level(number));
      } else {
        levels.add(_placeholderLevel(classNumber, number));
      }
    }

    return ClassCourse(
      classNumber: classNumber,
      title: 'Class $classNumber • NOVA Adventure',
      levels: levels,
    );
  }

  static LevelModel _class4Level(int number) {
    switch (number) {
      case 1:
        return _level(
          classNumber: 4,
          number: 1,
          topic: 'Place Value',
          emoji: '🔢',
          storyTitle: 'The Observatory Number Hunt',
          description: 'Help NOVA read the secret numbers glowing in the stars.',
          difficulty: 1,
          minutes: 6,
          reward: 20,
          badgeId: 'class4_l1_badge',
          completionTitle: 'Number Navigator!',
          beats: const [
            StoryBeat(
              id: 'c4l1b1',
              narration: 'Welcome to the observatory! NOVA found a row of glowing numbers.',
              sceneType: SceneType.observatory,
              novaMood: NovaMood.excited,
            ),
            StoryBeat(
              id: 'c4l1b2',
              narration: 'Look at each digit carefully. Its place tells us how much it is worth.',
              sceneType: SceneType.observatory,
              novaMood: NovaMood.thinking,
            ),
            StoryBeat(
              id: 'c4l1b3',
              narration: 'Let us solve a few number puzzles together!',
              sceneType: SceneType.observatory,
              novaMood: NovaMood.encouraging,
            ),
            StoryBeat(
              id: 'c4l1b4',
              narration: 'The star map is complete. You helped NOVA unlock the next trail.',
              sceneType: SceneType.treasure,
              novaMood: NovaMood.celebrating,
            ),
          ],
          questions: _questions(
            prefix: 'c4l1',
            items: const [
              ['What is the value of the 7 in 3,742?', '700', '70', '7', '0'],
              ['Which number is greatest?', '2,408', '2,840', '2,480', '1'],
              ['What is 4,000 + 300 + 20 + 5?', '4,325', '4,352', '4,235', '0'],
              ['Which digit is in the tens place in 5,681?', '8', '6', '1', '1'],
              ['Round 347 to the nearest hundred.', '300', '400', '350', '1'],
            ],
          ),
        );
      case 2:
        return _level(
          classNumber: 4,
          number: 2,
          topic: 'Addition & Subtraction',
          emoji: '➕',
          storyTitle: 'The Market Mystery',
          description: 'Count supplies and solve change puzzles at NOVA’s space market.',
          difficulty: 1,
          minutes: 7,
          reward: 22,
          badgeId: 'class4_l2_badge',
          completionTitle: 'Market Math Master!',
          beats: const [
            StoryBeat(
              id: 'c4l2b1',
              narration: 'The market robots need help counting their delivery crates.',
              sceneType: SceneType.market,
              novaMood: NovaMood.happy,
            ),
            StoryBeat(
              id: 'c4l2b2',
              narration: 'We can line up the numbers and add from right to left.',
              sceneType: SceneType.market,
              novaMood: NovaMood.thinking,
            ),
            StoryBeat(
              id: 'c4l2b3',
              narration: 'Now the robots have a few subtraction puzzles for us.',
              sceneType: SceneType.market,
              novaMood: NovaMood.encouraging,
            ),
            StoryBeat(
              id: 'c4l2b4',
              narration: 'Fantastic! Every crate is counted correctly.',
              sceneType: SceneType.market,
              novaMood: NovaMood.celebrating,
            ),
          ],
          questions: _questions(
            prefix: 'c4l2',
            items: const [
              ['What is 248 + 135?', '373', '383', '393', '1'],
              ['What is 500 − 176?', '324', '334', '314', '0'],
              ['What is 367 + 208?', '565', '575', '585', '1'],
              ['What is 900 − 425?', '475', '485', '465', '0'],
              ['A shop has 125 apples and gets 75 more. How many?', '190', '200', '210', '1'],
            ],
          ),
        );
      case 3:
        return _level(
          classNumber: 4,
          number: 3,
          topic: 'Multiplication',
          emoji: '✖️',
          storyTitle: 'The Robot Factory',
          description: 'Build equal groups of robot parts using multiplication.',
          difficulty: 2,
          minutes: 8,
          reward: 24,
          badgeId: 'class4_l3_badge',
          completionTitle: 'Multiplication Builder!',
          beats: const [
            StoryBeat(
              id: 'c4l3b1',
              narration: 'Inside the robot factory, parts arrive in equal groups.',
              sceneType: SceneType.factory,
              novaMood: NovaMood.excited,
            ),
            StoryBeat(
              id: 'c4l3b2',
              narration: 'Multiplication is a fast way to count equal groups.',
              sceneType: SceneType.factory,
              novaMood: NovaMood.thinking,
            ),
            StoryBeat(
              id: 'c4l3b3',
              narration: 'Use your times tables to power the assembly line.',
              sceneType: SceneType.factory,
              novaMood: NovaMood.encouraging,
            ),
            StoryBeat(
              id: 'c4l3b4',
              narration: 'The robots are ready for their next mission!',
              sceneType: SceneType.factory,
              novaMood: NovaMood.celebrating,
            ),
          ],
          questions: _questions(
            prefix: 'c4l3',
            items: const [
              ['What is 7 × 6?', '36', '42', '48', '1'],
              ['There are 4 groups of 8. How many altogether?', '24', '32', '36', '1'],
              ['What is 9 × 5?', '40', '45', '50', '1'],
              ['What is 6 × 7?', '36', '42', '48', '1'],
              ['Three shelves hold 12 books each. How many books?', '24', '36', '42', '1'],
            ],
          ),
        );
      case 4:
        return _level(
          classNumber: 4,
          number: 4,
          topic: 'Division',
          emoji: '➗',
          storyTitle: 'The Garden Sharing Quest',
          description: 'Share space seeds equally and discover division.',
          difficulty: 2,
          minutes: 8,
          reward: 26,
          badgeId: 'class4_l4_badge',
          completionTitle: 'Fair-Share Explorer!',
          beats: const [
            StoryBeat(
              id: 'c4l4b1',
              narration: 'NOVA has 24 moon seeds and four garden beds.',
              sceneType: SceneType.garden,
              novaMood: NovaMood.happy,
            ),
            StoryBeat(
              id: 'c4l4b2',
              narration: 'Division helps us share a total into equal groups.',
              sceneType: SceneType.garden,
              novaMood: NovaMood.thinking,
              interactionType: InteractionType.dragToShare,
              itemsToShare: 12,
              basketCount: 3,
            ),
            StoryBeat(
              id: 'c4l4b3',
              narration: 'Try each sharing puzzle and check that every group is fair.',
              sceneType: SceneType.garden,
              novaMood: NovaMood.encouraging,
            ),
            StoryBeat(
              id: 'c4l4b4',
              narration: 'Every garden bed has the same number of seeds. Great sharing!',
              sceneType: SceneType.garden,
              novaMood: NovaMood.celebrating,
            ),
          ],
          questions: _questions(
            prefix: 'c4l4',
            items: const [
              ['What is 24 ÷ 4?', '5', '6', '7', '1'],
              ['Share 18 stars equally into 3 groups. How many per group?', '5', '6', '7', '1'],
              ['What is 35 ÷ 5?', '6', '7', '8', '1'],
              ['Which multiplication fact checks 32 ÷ 8 = 4?', '8 × 3 = 24', '8 × 4 = 32', '8 × 5 = 40', '1'],
              ['There are 40 stickers shared among 10 children. Each gets?', '4', '5', '6', '0'],
            ],
          ),
        );
      case 5:
        return _level(
          classNumber: 4,
          number: 5,
          topic: 'Fractions',
          emoji: '🍰',
          storyTitle: 'The Fraction Moon Cake',
          description: 'Explore equal parts and compare simple fractions.',
          difficulty: 3,
          minutes: 9,
          reward: 28,
          badgeId: 'class4_l5_badge',
          completionTitle: 'Fraction Star!',
          beats: const [
            StoryBeat(
              id: 'c4l5b1',
              narration: 'NOVA baked a moon cake and wants to share it fairly.',
              sceneType: SceneType.treasure,
              novaMood: NovaMood.excited,
            ),
            StoryBeat(
              id: 'c4l5b2',
              narration: 'A fraction names equal parts of a whole.',
              sceneType: SceneType.treasure,
              novaMood: NovaMood.thinking,
              interactionType: InteractionType.tapToCount,
              itemsToCount: 4,
            ),
            StoryBeat(
              id: 'c4l5b3',
              narration: 'The top number tells how many parts we have. The bottom tells the total equal parts.',
              sceneType: SceneType.treasure,
              novaMood: NovaMood.encouraging,
            ),
            StoryBeat(
              id: 'c4l5b4',
              narration: 'You found the fraction hidden inside the moon cake!',
              sceneType: SceneType.treasure,
              novaMood: NovaMood.celebrating,
            ),
          ],
          questions: _questions(
            prefix: 'c4l5',
            items: const [
              ['Which fraction means one out of four equal parts?', '1/4', '1/2', '3/4', '0'],
              ['Which is greater?', '1/4', '3/4', '1/8', '1'],
              ['How many fourths make one whole?', '2', '3', '4', '2'],
              ['Which fraction is equal to 1/2?', '2/4', '1/4', '3/4', '0'],
              ['What fraction is shaded if 3 of 5 equal parts are shaded?', '2/5', '3/5', '4/5', '1'],
            ],
          ),
        );
      default:
        return _placeholderLevel(4, number);
    }
  }

  static LevelModel _placeholderLevel(int classNumber, int number) {
    final topics = [
      'Number Sense',
      'Addition & Subtraction',
      'Multiplication',
      'Division',
      'Fractions',
      'Geometry',
      'Measurement',
      'Patterns',
      'Word Problems',
      'Time',
      'Money',
      'Data',
      'Perimeter',
      'Area',
      'Math Mission',
    ];
    final topic = topics[(number - 1) % topics.length];
    return _level(
      classNumber: classNumber,
      number: number,
      topic: topic,
      emoji: ['🔢', '➕', '✖️', '➗', '🍰'][number % 5],
      storyTitle: 'NOVA’s $topic Adventure',
      description: 'A structured local curriculum placeholder for Class $classNumber, Level $number.',
      difficulty: number <= 5 ? 1 : (number <= 10 ? 2 : 3),
      minutes: 6 + (number % 4),
      reward: 18 + number,
      badgeId: 'class${classNumber}_l${number}_badge',
      completionTitle: '$topic Explorer!',
      beats: [
        StoryBeat(
          id: 'c${classNumber}l${number}b1',
          narration: 'NOVA welcomes you to today’s $topic adventure.',
          sceneType: SceneType.general,
          novaMood: NovaMood.happy,
        ),
        StoryBeat(
          id: 'c${classNumber}l${number}b2',
          narration: 'Let us explore one small idea at a time.',
          sceneType: SceneType.general,
          novaMood: NovaMood.thinking,
        ),
        StoryBeat(
          id: 'c${classNumber}l${number}b3',
          narration: 'Now it is your turn to try the challenge.',
          sceneType: SceneType.general,
          novaMood: NovaMood.encouraging,
        ),
        StoryBeat(
          id: 'c${classNumber}l${number}b4',
          narration: 'Adventure complete! You made progress today.',
          sceneType: SceneType.treasure,
          novaMood: NovaMood.celebrating,
        ),
      ],
      questions: _genericQuestions('c${classNumber}l$number'),
    );
  }

  static LevelModel _level({
    required int classNumber,
    required int number,
    required String topic,
    required String emoji,
    required String storyTitle,
    required String description,
    required int difficulty,
    required int minutes,
    required int reward,
    required String badgeId,
    required String completionTitle,
    required List<StoryBeat> beats,
    required List<QuestionModel> questions,
  }) {
    return LevelModel(
      id: 'class${classNumber}_level$number',
      classNumber: classNumber,
      number: number,
      topic: topic,
      emoji: emoji,
      storyTitle: storyTitle,
      description: description,
      difficulty: difficulty,
      estMinutes: minutes,
      rewardStars: reward,
      storyBeats: beats,
      questionPool: questions,
      completionTitle: completionTitle,
      badgeId: badgeId,
    );
  }

  static List<QuestionModel> _questions({
    required String prefix,
    required List<List<String>> items,
  }) {
    return List.generate(items.length, (i) {
      final item = items[i];
      final correct = int.parse(item[4]);
      return QuestionModel(
        id: '${prefix}_q${i + 1}',
        prompt: item[0],
        options: [
          AnswerOptionModel(
            id: '${prefix}_q${i + 1}a',
            label: item[1],
            semanticLabel: item[1],
          ),
          AnswerOptionModel(
            id: '${prefix}_q${i + 1}b',
            label: item[2],
            semanticLabel: item[2],
          ),
          AnswerOptionModel(
            id: '${prefix}_q${i + 1}c',
            label: item[3],
            semanticLabel: item[3],
          ),
        ],
        correctIndex: correct,
        tier: i < 2 ? 1 : (i < 4 ? 2 : 3),
        hints: [
          'Read the question once more.',
          'Think about the numbers or groups you can see.',
          'Take it one small step at a time with NOVA.',
        ],
        explanation: 'Use a simple step-by-step strategy and check your answer.',
        spokenAnswers: [item[correct + 1]],
      );
    });
  }

  static List<QuestionModel> _genericQuestions(String prefix) {
    return [
      QuestionModel(
        id: '${prefix}_q1',
        prompt: 'Which number comes next: 2, 4, 6, __?',
        options: const [
          AnswerOptionModel(id: 'g1a', label: '7', semanticLabel: '7'),
          AnswerOptionModel(id: 'g1b', label: '8', semanticLabel: '8'),
          AnswerOptionModel(id: 'g1c', label: '10', semanticLabel: '10'),
        ],
        correctIndex: 1,
        tier: 1,
        hints: const ['Look at the change between numbers.', 'The numbers increase by the same amount.', 'Add 2 each time.'],
        explanation: 'The pattern increases by 2.',
        spokenAnswers: const ['8', 'eight'],
      ),
      QuestionModel(
        id: '${prefix}_q2',
        prompt: 'Which group shows equal sharing?',
        options: const [
          AnswerOptionModel(id: 'g2a', label: '2, 2, 2', semanticLabel: 'three equal groups of two'),
          AnswerOptionModel(id: 'g2b', label: '2, 3, 2', semanticLabel: 'unequal groups'),
          AnswerOptionModel(id: 'g2c', label: '1, 2, 3', semanticLabel: 'increasing groups'),
        ],
        correctIndex: 0,
        tier: 1,
        hints: const ['Look at every group.', 'Equal means the same amount.', 'All three groups have 2.'],
        explanation: 'Equal groups contain the same number.',
        spokenAnswers: const ['2, 2, 2'],
      ),
      QuestionModel(
        id: '${prefix}_q3',
        prompt: 'What is 5 + 5?',
        options: const [
          AnswerOptionModel(id: 'g3a', label: '8', semanticLabel: '8'),
          AnswerOptionModel(id: 'g3b', label: '10', semanticLabel: '10'),
          AnswerOptionModel(id: 'g3c', label: '12', semanticLabel: '12'),
        ],
        correctIndex: 1,
        tier: 2,
        hints: const ['Start at 5.', 'Count five more.', '5 plus 5 is 10.'],
        explanation: 'Adding five to five gives ten.',
        spokenAnswers: const ['10', 'ten'],
      ),
    ];
  }
}
