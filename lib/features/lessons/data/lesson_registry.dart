import '../domain/models/lesson_models.dart';
import 'level_1_data.dart';

class LessonRegistry {
  static Lesson? getLesson(int standard, int level) {
    if (standard == 1 && level == 1) {
      return level1Lesson;
    }
    return null;
  }
}
