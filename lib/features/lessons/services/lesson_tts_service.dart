import 'package:flutter_tts/flutter_tts.dart';
import '../domain/models/lesson_models.dart';

class LessonTtsService {
  final FlutterTts _flutterTts = FlutterTts();

  LessonTtsService() {
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
  }

  /// Plays a full NarrationLine segment by segment.
  /// Calls [onSegmentStart] when a new segment begins, passing its visual cue.
  Future<void> playNarration(
    NarrationLine line, {
    void Function(VisualCue?)? onSegmentStart,
  }) async {
    for (final segment in line.segments) {
      if (onSegmentStart != null) {
        onSegmentStart(segment.cue);
      }
      
      await _flutterTts.setLanguage(segment.languageTag);
      
      // Use phonetic override if provided, otherwise the actual text.
      final textToSpeak = segment.ttsOverride ?? segment.text;
      
      await _flutterTts.awaitSpeakCompletion(true);
      await _flutterTts.speak(textToSpeak);
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}
