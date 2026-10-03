/// Profile and progress of the active learner.
class Student {
  final String name;
  final int classNumber;
  final int stars;
  final int streak;
  final List<String> earnedBadgeIds;
  final Set<int> completedLevels;
  final int currentLevel;
  final int recommendedLevel;
  final int avatarColorIndex;

  const Student({
    this.name = 'Explorer',
    this.classNumber = 4,
    this.stars = 0,
    this.streak = 1,
    this.earnedBadgeIds = const [],
    this.completedLevels = const {},
    this.currentLevel = 1,
    this.recommendedLevel = 1,
    this.avatarColorIndex = 0,
  });

  Student copyWith({
    String? name,
    int? classNumber,
    int? stars,
    int? streak,
    List<String>? earnedBadgeIds,
    Set<int>? completedLevels,
    int? currentLevel,
    int? recommendedLevel,
    int? avatarColorIndex,
  }) {
    return Student(
      name: name ?? this.name,
      classNumber: classNumber ?? this.classNumber,
      stars: stars ?? this.stars,
      streak: streak ?? this.streak,
      earnedBadgeIds: earnedBadgeIds ?? this.earnedBadgeIds,
      completedLevels: completedLevels ?? this.completedLevels,
      currentLevel: currentLevel ?? this.currentLevel,
      recommendedLevel: recommendedLevel ?? this.recommendedLevel,
      avatarColorIndex: avatarColorIndex ?? this.avatarColorIndex,
    );
  }
}
