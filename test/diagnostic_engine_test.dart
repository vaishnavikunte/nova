import 'package:flutter_test/flutter_test.dart';
import 'package:majhe_gaon/features/diagnostic/adaptive_engine.dart';

void main() {
  group('DiagnosticManager', () {
    test('3 consecutive wrong answers drops p_mastery and scaffolds', () {
      final manager = DiagnosticManager();
      // Starting with a very high pMastery (0.99) so it doesn't instantly drop
      // below 0.30. This ensures we are testing the 3-fail threshold rule.
      final state = StudentPerformanceState(pMastery: 0.99, consecutiveFails: 0);

      // Fail 1
      var action = manager.evaluateResponse(false, 5000, state);
      expect(action, equals(AdaptationAction.maintain));
      expect(state.consecutiveFails, equals(1));
      
      // Fail 2
      action = manager.evaluateResponse(false, 5000, state);
      expect(action, equals(AdaptationAction.maintain));
      expect(state.consecutiveFails, equals(2));

      // Fail 3
      action = manager.evaluateResponse(false, 5000, state);
      
      expect(state.consecutiveFails, equals(3));
      expect(action, equals(AdaptationAction.scaffoldWithinLevel));
      expect(state.pMastery, lessThan(0.99));
    });
  });
}
