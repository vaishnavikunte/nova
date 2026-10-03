class BadgeModel {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const BadgeModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  BadgeModel copyWith({
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return BadgeModel(
      id: id,
      name: name,
      emoji: emoji,
      description: description,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}
