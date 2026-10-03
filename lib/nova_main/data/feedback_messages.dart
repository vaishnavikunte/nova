import '../models/emotion_state.dart';

/// Positive-framed encouragement messages for all learning feedback situations.
class FeedbackMessages {
  FeedbackMessages._();

  static const List<String> correctAnswers = [
    'Nice!',
    'Good thinking!',
    'You got it!',
    'Spot on! ⭐',
    'Super work!',
    'Brilliant discovery!',
  ];

  static const List<String> gentleTryAgain = [
    'Almost! Let\'s keep going.',
    'Almost! Let\'s try again.',
    'Good try! Let\'s peek at a hint.',
    'So close! Want to look at it together?',
    'Great effort! Let\'s look at the clues.',
  ];

  static const List<String> confidentEncouragement = [
    'Awesome! You\'re ready for a challenge! 🚀',
    'You\'re getting really good at this!',
    'Your brain is super sharp today!',
  ];

  static const List<String> confusedGuidance = [
    'Let\'s slow down and look at this together. 💡',
    'No rush at all! Let\'s check the clue.',
    'Clues make everything clearer! 🔍',
  ];

  static const List<String> frustratedComfort = [
    'No worries! Let\'s solve it one step at a time. 🌱',
    'Take a breath — we learn by exploring together!',
    'Every explorer takes small steps. You\'re doing great!',
  ];

  static String forEmotion(EmotionState emotion) {
    switch (emotion) {
      case EmotionState.confident:
        return 'Awesome! You\'re ready for a challenge! 🚀';
      case EmotionState.confused:
        return 'Let\'s slow down and look at this together. 💡';
      case EmotionState.frustrated:
        return 'No worries! Let\'s solve it one step at a time. 🌱';
      case EmotionState.neutral:
        return 'Yes! You got it! ⭐';
    }
  }

  static const Map<int, List<String>> levelCelebrations = {
    1: [
      'You navigated those big numbers like a star gazer! 🔭',
      'The observatory stars are shining bright for you! ⭐',
    ],
    2: [
      'You counted all that fruit like a true market master! 🥭',
      'The market stall is glowing thanks to your quick math! 🛒',
    ],
    3: [
      'You built those robots with fantastic multiplication! 🤖',
      'Beep boop! The robot factory is running at top speed! ⚙️',
    ],
    4: [
      'You shared those apples like a champion! 🍎',
      'Equal baskets for everyone — wonderful division! 🧺',
    ],
    5: [
      'You found all the glowing factor secrets in the cave! 💎',
      'The crystal cave shines brightly with your math power! 🔮',
    ],
    6: [
      'You divided the treasure pizza fairly for all! 🍕',
      'Fractions are no match for your sharp eyes! 🏴‍☠️',
    ],
  };

  static String getCelebrationForLevel(int levelNumber) {
    final list = levelCelebrations[levelNumber];
    if (list != null && list.isNotEmpty) {
      return list.first;
    }
    return 'You completed the adventure with flying colors! 🌟';
  }
}
