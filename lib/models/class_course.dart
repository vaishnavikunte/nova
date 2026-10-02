import 'level_model.dart';

/// Full curriculum course containing 15 levels for a single school class.
class ClassCourse {
  final int classNumber;
  final String title;
  final List<LevelModel> levels;

  const ClassCourse({
    required this.classNumber,
    required this.title,
    required this.levels,
  }) : assert(levels.length == 15, 'Each course must contain exactly 15 levels');

  LevelModel getLevel(int levelNumber) {
    return levels.firstWhere(
      (l) => l.number == levelNumber,
      orElse: () => levels.first,
    );
  }
}
