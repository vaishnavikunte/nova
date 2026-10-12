import 'package:flutter_test/flutter_test.dart';
import 'package:majhe_gaon/features/lessons/data/lesson_registry.dart';
import 'package:majhe_gaon/features/lessons/data/level_1_data.dart';
import 'package:majhe_gaon/features/lessons/domain/models/lesson_models.dart';

void main() {
  group('Level 1 Lesson Data & Model Tests', () {
    test('LessonRegistry returns Level 1 lesson for Standard 1, Level 1', () {
      final lesson = LessonRegistry.getLesson(1, 1);
      expect(lesson, isNotNull);
      expect(lesson!.id, equals('std1_level1_morning'));
      expect(lesson.standard, equals(1));
      expect(lesson.level, equals(1));
      expect(lesson.beats.length, equals(3));
      expect(lesson.questions.length, equals(4));
    });

    test('LessonRegistry returns null for non-existent levels', () {
      expect(LessonRegistry.getLesson(1, 99), isNull);
      expect(LessonRegistry.getLesson(2, 1), isNull);
    });

    test('Story beats contain required scenes, segments, and visual cues', () {
      final beats = level1Lesson.beats;
      expect(beats[0].sceneId, equals(SceneId.house));
      expect(beats[0].requiresMicInteraction, isTrue);

      expect(beats[1].sceneId, equals(SceneId.roofAndGround));
      final beat2Cues = beats[1].narration.segments.map((s) => s.cue).toSet();
      expect(beat2Cues.contains(VisualCue.roof), isTrue);
      expect(beat2Cues.contains(VisualCue.chiu), isTrue);
      expect(beat2Cues.contains(VisualCue.ground), isTrue);
      expect(beat2Cues.contains(VisualCue.ganya), isTrue);

      expect(beats[2].sceneId, equals(SceneId.farm));
      final beat3Cues = beats[2].narration.segments.map((s) => s.cue).toSet();
      expect(beat3Cues.contains(VisualCue.tractor), isTrue);
      expect(beat3Cues.contains(VisualCue.bucket), isTrue);
    });

    test('Question 1 (Big vs Small) validates Tractor as correct', () {
      final q1 = level1Lesson.questions[0];
      expect(q1.id, equals('q1_big_small'));
      expect(q1.type, equals(QuestionType.tap));
      expect(q1.options.length, equals(2));
      expect(q1.correctOptionId, equals('tractor'));
      expect(q1.options.any((o) => o.id == 'tractor'), isTrue);
      expect(q1.options.any((o) => o.id == 'bicycle'), isTrue);
    });

    test('Question 2 (Match the Following) contains 3 valid pairs', () {
      final q2 = level1Lesson.questions[1];
      expect(q2.id, equals('q2_match_pairs'));
      expect(q2.type, equals(QuestionType.matchPairs));
      expect(q2.matchingPairs.length, equals(3));

      final pairIds = q2.matchingPairs.map((p) => p.id).toList();
      expect(pairIds, contains('pair_sun_morning'));
      expect(pairIds, contains('pair_bird_top'));
      expect(pairIds, contains('pair_calf_bottom'));

      // Validate matching logic
      for (final pair in q2.matchingPairs) {
        expect(pair.leftLabel, isNotEmpty);
        expect(pair.rightLabel, isNotEmpty);
        expect(pair.leftVisualKey, isNotEmpty);
        expect(pair.rightVisualKey, isNotEmpty);
      }
    });

    test('Question 3 (Roof vs Ground) validates Chiu as correct', () {
      final q3 = level1Lesson.questions[2];
      expect(q3.id, equals('q3_top_bottom'));
      expect(q3.correctOptionId, equals('chiu'));
    });

    test('Question 4 (Greeting) validates Good Morning as correct', () {
      final q4 = level1Lesson.questions[3];
      expect(q4.id, equals('q4_greeting'));
      expect(q4.correctOptionId, equals('good_morning'));
      final goodMorning = q4.options.firstWhere((o) => o.id == 'good_morning');
      expect(goodMorning.spokenAliases, contains('good morning'));
    });

    test('Summary covers all 5 key concepts', () {
      final summary = level1Lesson.summary;
      expect(summary.summaryPoints.length, equals(5));
      final text = summary.summaryPoints.map((p) => p.displayText).join(' ');
      expect(text, contains('Good Morning'));
      expect(text, contains('Top / वर'));
      expect(text, contains('Bottom / खाली'));
      expect(text, contains('Big / मोठा'));
      expect(text, contains('Small / छोटी'));
    });
  });
}
