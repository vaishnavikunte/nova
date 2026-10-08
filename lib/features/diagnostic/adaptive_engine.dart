enum AdaptationAction {
  maintain,
  scaffoldWithinLevel,
  routeToBridgeRunway,
}

class StudentPerformanceState {
  double pMastery;
  int consecutiveFails;

  StudentPerformanceState({
    required this.pMastery,
    required this.consecutiveFails,
  });
}

class DiagnosticManager {
  // Standard BKT parameters
  static const double slip = 0.10;
  static const double guess = 0.20;
  static const double transit = 0.15;

  /// Evaluates the student's response and updates the BKT state.
  /// Returns the AdaptationAction to be taken by the curriculum flow.
  AdaptationAction evaluateResponse(
    bool isCorrect,
    int timeTakenMs,
    StudentPerformanceState state,
  ) {
    // 1. Calculate the conditional probability of mastery given the observation
    double pMasteryGivenObs;
    if (isCorrect) {
      pMasteryGivenObs = (state.pMastery * (1 - slip)) /
          ((state.pMastery * (1 - slip)) + ((1 - state.pMastery) * guess));
      state.consecutiveFails = 0;
    } else {
      pMasteryGivenObs = (state.pMastery * slip) /
          ((state.pMastery * slip) + ((1 - state.pMastery) * (1 - guess)));
      state.consecutiveFails += 1;
    }

    // 2. Update probability of mastery for the next opportunity
    state.pMastery = pMasteryGivenObs + ((1 - pMasteryGivenObs) * transit);

    // 3. Determine the adaptation action
    if (state.consecutiveFails >= 3 || state.pMastery < 0.30) {
      return AdaptationAction.scaffoldWithinLevel;
    }

    return AdaptationAction.maintain;
  }
}
