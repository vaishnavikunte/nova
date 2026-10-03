import 'package:flutter_test/flutter_test.dart';
import 'package:majhe_gaon/features/voice_engine/voice_answer_matcher.dart';

void main() {
  group('VoiceAnswerMatcher', () {
    test('matches "पंचवीस" to "25"', () {
      bool result = VoiceAnswerMatcher.evaluateAnswer('पंचवीस', '25');
      expect(result, isTrue);
    });

    test('matches "बास्पीभवन" to "बाष्पीभवन" (Levenshtein distance)', () {
      // 'बास्पीभवन' and 'बाष्पीभवन' differ by only 1 character out of 9.
      // Similarity = 8/9 = 0.88, which is >= 0.75, so it should match.
      bool result = VoiceAnswerMatcher.evaluateAnswer('बास्पीभवन', 'बाष्पीभवन');
      expect(result, isTrue);
    });
  });
}
