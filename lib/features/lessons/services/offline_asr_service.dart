import 'package:speech_to_text/speech_to_text.dart';

class OfflineAsrSpeechInput {
  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;

  Future<bool> initialize() async {
    if (_isInitialized) return true;
    _isInitialized = await _speechToText.initialize(
      onError: (val) => print('ASR Error: ${val.errorMsg}'),
      onStatus: (val) => print('ASR Status: $val'),
    );
    return _isInitialized;
  }

  /// Starts listening and continuously invokes [onResult] with the recognized words.
  Future<void> startListening({
    required void Function(String) onResult,
    String localeId = 'en_IN',
  }) async {
    if (!_isInitialized) {
      final success = await initialize();
      if (!success) return;
    }
    
    await _speechToText.listen(
      onResult: (result) {
        onResult(result.recognizedWords);
      },
      localeId: localeId,
      listenOptions: SpeechListenOptions(
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        cancelOnError: true,
        listenMode: ListenMode.dictation,
      ),
    );
  }

  Future<void> stopListening() async {
    if (_isInitialized && _speechToText.isListening) {
      await _speechToText.stop();
    }
  }

  bool get isListening => _speechToText.isListening;
}
