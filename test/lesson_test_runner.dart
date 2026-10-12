import 'package:majhe_gaon/features/lessons/data/lesson_registry.dart';
import 'package:majhe_gaon/features/lessons/data/level_1_data.dart';
import 'package:majhe_gaon/features/lessons/domain/models/lesson_models.dart';

void main() {
  print('--- Running Lesson Verification Suite ---');

  // Test 1: Registry Lookup
  final lesson = LessonRegistry.getLesson(1, 1);
  if (lesson == null) throw Exception('FAILED: Level 1 Lesson is null');
  print('✓ Test 1: Level 1 retrieved successfully from LessonRegistry');

  // Test 2: Beats & Scene Cues
  if (lesson.beats.length != 3) throw Exception('FAILED: Expected 3 beats, got ${lesson.beats.length}');
  final beat2Cues = lesson.beats[1].narration.segments.map((s) => s.cue).toSet();
  if (!beat2Cues.contains(VisualCue.roof) || !beat2Cues.contains(VisualCue.ground)) {
    throw Exception('FAILED: Beat 2 missing roof/ground cues');
  }
  print('✓ Test 2: Story beats and visual cues verified (Beats: ${lesson.beats.length})');

  // Test 3: Question 1 (Big vs Small)
  final q1 = lesson.questions[0];
  if (q1.id != 'q1_big_small' || q1.correctOptionId != 'tractor') {
    throw Exception('FAILED: Question 1 incorrect');
  }
  print('✓ Test 3: Question 1 Big vs Small validates Tractor as correct');

  // Test 4: Question 2 (Match the Following)
  final q2 = lesson.questions[1];
  if (q2.type != QuestionType.matchPairs || q2.matchingPairs.length != 3) {
    throw Exception('FAILED: Question 2 matchPairs invalid');
  }
  final pairIds = q2.matchingPairs.map((p) => p.id).toSet();
  if (!pairIds.contains('pair_sun_morning') ||
      !pairIds.contains('pair_bird_top') ||
      !pairIds.contains('pair_calf_bottom')) {
    throw Exception('FAILED: Matching pairs missing expected IDs');
  }
  print('✓ Test 4: Question 2 Match the Following has 3 valid pairs with dual labels');

  // Test 5: Question 3 (Roof vs Ground)
  final q3 = lesson.questions[2];
  if (q3.correctOptionId != 'chiu') throw Exception('FAILED: Question 3 incorrect');
  print('✓ Test 5: Question 3 validates Chiu as correct');

  // Test 6: Question 4 (Greeting)
  final q4 = lesson.questions[3];
  if (q4.correctOptionId != 'good_morning') throw Exception('FAILED: Question 4 incorrect');
  print('✓ Test 6: Question 4 validates Good Morning as correct');

  // Test 7: Summary & Learning Outcomes
  if (lesson.summary.summaryPoints.length != 5) {
    throw Exception('FAILED: Expected 5 summary points, got ${lesson.summary.summaryPoints.length}');
  }
  print('✓ Test 7: Summary points cover all 5 taught concepts (Points: 5)');

  print('=== ALL 7 LESSON VERIFICATION TESTS PASSED SUCCESSFULLY! ===');
}
