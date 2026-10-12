class LessonAudioService {
  /// Initializes the audio service. Currently a no-op as per M0 instructions.
  Future<void> init() async {}

  /// Plays a success chime. No-op.
  Future<void> playSuccess() async {}

  /// Plays a failure or retry tone. No-op.
  Future<void> playRetry() async {}

  /// Plays a celebration sound. No-op.
  Future<void> playCelebration() async {}

  /// Disposes any resources. No-op.
  void dispose() {}
}
