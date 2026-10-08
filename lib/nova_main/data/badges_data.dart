import '../models/badge.dart';

/// Predefined achievement badges for NOVA explorers.
class BadgesData {
  BadgesData._();

  static const List<BadgeModel> allBadges = [
    BadgeModel(
      id: 'welcome_explorer',
      name: 'Star Explorer',
      emoji: '🌟',
      description: 'Began the learning adventure with NOVA!',
      isUnlocked: true,
    ),
    BadgeModel(
      id: 'assessment_pro',
      name: 'Knowledge Scout',
      emoji: '🧭',
      description: 'Completed the "What You Know" game.',
    ),
    BadgeModel(
      id: 'class4_l1_badge',
      name: 'Number Navigator',
      emoji: '🔭',
      description: 'Mastered place value to 10,000!',
    ),
    BadgeModel(
      id: 'class4_l2_badge',
      name: 'Market Master',
      emoji: '🛒',
      description: 'Solved all market fruit additions and subtractions!',
    ),
    BadgeModel(
      id: 'class4_l3_badge',
      name: 'Robot Builder',
      emoji: '🤖',
      description: 'Multiplied parts to build shiny robots!',
    ),
    BadgeModel(
      id: 'class4_l4_badge',
      name: 'Division Explorer',
      emoji: '🍎',
      description: 'Shared apples fairly across all baskets!',
    ),
    BadgeModel(
      id: 'class4_l5_badge',
      name: 'Crystal Finder',
      emoji: '💎',
      description: 'Discovered factors and multiples in the cave!',
    ),
    BadgeModel(
      id: 'class4_l6_badge',
      name: 'Fraction Hero',
      emoji: '🍕',
      description: 'Divided treasure and pizzas with precision!',
    ),
    BadgeModel(
      id: 'streak_3',
      name: 'Consistency Comet',
      emoji: '☄️',
      description: 'Maintained a 3-day learning streak!',
    ),
    BadgeModel(
      id: 'grand_adventure',
      name: 'Galaxy Champion',
      emoji: '🏆',
      description: 'Conquered the Level 15 Grand Adventure!',
    ),
  ];
}
