
import '../models/question_model.dart';

enum VoiceRecognitionState {
  idle,
  listening,
  processing,
  recognized,
  error,
}

/// Offline/mock voice service for the semester UI prototype.
/// No microphone, cloud API, or speech model is required.
class MockVoiceService {
  bool _disposed = false;

  Future<String> listenForAnswer({
    required QuestionModel question,
    bool forceMishear = false,
    bool? forceCorrect,
  }) async {
    if (_disposed) return question.options[question.correctIndex].label;

    await Future<void>.delayed(const Duration(milliseconds: 650));

    if (forceMishear) {
      return question.options.length > 1
          ? question.options[(question.correctIndex + 1) % question.options.length].label
          : question.options[question.correctIndex].label;
    }

    if (forceCorrect == false && question.options.length > 1) {
      return question.options[(question.correctIndex + 1) % question.options.length].label;
    }

    // Default demo behavior: NOVA "hears" the correct option.
    return question.options[question.correctIndex].label;
  }

  void dispose() {
    _disposed = true;
  }
}
