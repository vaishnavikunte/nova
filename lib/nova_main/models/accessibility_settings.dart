enum SpeechSpeed { slow, normal, fast }

class AccessibilitySettings {
  final bool voiceInstructions;
  final bool hapticFeedback;
  final bool gestureNavigation;
  final bool largeText;
  final bool highContrast;
  final bool isDarkMode;
  final bool reduceMotion;
  final SpeechSpeed speechSpeed;
  final bool screenOffMode;

  const AccessibilitySettings({
    this.voiceInstructions = false,
    this.hapticFeedback = true,
    this.gestureNavigation = false,
    this.largeText = false,
    this.highContrast = false,
    this.isDarkMode =
        true, // Default to dark mode to match the purple theme reference! Wait, no, dark mode is deep purple, light is pastel
    this.reduceMotion = false,
    this.speechSpeed = SpeechSpeed.normal,
    this.screenOffMode = false,
  });

  AccessibilitySettings copyWith({
    bool? voiceInstructions,
    bool? hapticFeedback,
    bool? gestureNavigation,
    bool? largeText,
    bool? highContrast,
    bool? isDarkMode,
    bool? reduceMotion,
    SpeechSpeed? speechSpeed,
    bool? screenOffMode,
  }) {
    return AccessibilitySettings(
      voiceInstructions: voiceInstructions ?? this.voiceInstructions,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      gestureNavigation: gestureNavigation ?? this.gestureNavigation,
      largeText: largeText ?? this.largeText,
      highContrast: highContrast ?? this.highContrast,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      speechSpeed: speechSpeed ?? this.speechSpeed,
      screenOffMode: screenOffMode ?? this.screenOffMode,
    );
  }

  factory AccessibilitySettings.audioAssisted() {
    return const AccessibilitySettings(
      voiceInstructions: true,
      hapticFeedback: true,
      largeText: true,
      speechSpeed: SpeechSpeed.normal,
    );
  }
}
