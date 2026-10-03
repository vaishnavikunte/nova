import 'question_model.dart';
import 'story_beat.dart';

/// Progression state of a level node on the Adventure Map.
enum LevelState {
  locked,
  available,
  current,
  completed,
}

/// Full metadata and content structure for a curriculum level.
class LevelModel {
  final String id;
  final int classNumber;
  final int number; // 1 to 15
  final String topic;
  final String emoji;
  final String storyTitle;
  final String description;
  final int difficulty; // 1, 2, or 3
  final int estMinutes;
  final int rewardStars;
  final LevelState state;
  final List<StoryBeat> storyBeats;
  final List<QuestionModel> questionPool;
  final String completionTitle;
  final String badgeId;
  final int earnedStars; // 0 to 3

  const LevelModel({
    required this.id,
    required this.classNumber,
    required this.number,
    required this.topic,
    required this.emoji,
    required this.storyTitle,
    required this.description,
    required this.difficulty,
    required this.estMinutes,
    required this.rewardStars,
    this.state = LevelState.locked,
    required this.storyBeats,
    required this.questionPool,
    required this.completionTitle,
    required this.badgeId,
    this.earnedStars = 0,
  });

  LevelModel copyWith({
    LevelState? state,
    int? earnedStars,
    List<StoryBeat>? storyBeats,
    List<QuestionModel>? questionPool,
  }) {
    return LevelModel(
      id: id,
      classNumber: classNumber,
      number: number,
      topic: topic,
      emoji: emoji,
      storyTitle: storyTitle,
      description: description,
      difficulty: difficulty,
      estMinutes: estMinutes,
      rewardStars: rewardStars,
      state: state ?? this.state,
      storyBeats: storyBeats ?? this.storyBeats,
      questionPool: questionPool ?? this.questionPool,
      completionTitle: completionTitle,
      badgeId: badgeId,
      earnedStars: earnedStars ?? this.earnedStars,
    );
  }
}
