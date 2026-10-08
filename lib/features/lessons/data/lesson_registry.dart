import 'lesson_models.dart';

class LessonRegistry {
  static LessonData? getLesson(int standard, int level) {
    if (standard == 1 && level == 1) {
      return _buildStd1Level1();
    }
    return null;
  }

  static LessonData _buildStd1Level1() {
    return const LessonData(
      standard: 1,
      level: 1,
      title: 'My Morning in the Village',
      stages: [
        LessonStage(id: 's1', type: LessonStageType.story, title: 'Story Part 1'),
        LessonStage(id: 'q1', type: LessonStageType.challenge, title: 'Challenge 1'),
        LessonStage(id: 'sum', type: LessonStageType.summary, title: 'Summary'),
        LessonStage(id: 'cel', type: LessonStageType.celebration, title: 'Celebration'),
      ],
    );
  }
}
