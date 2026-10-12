import 'package:flutter/foundation.dart';

enum QuestionType { tap, voice, tapOrVoice }
enum SceneId { house, roofAndGround, farm, questionArea }
enum VisualCue { sun, roof, chiu, ground, ganya, tractor, bucket, none }

class NarrationSegment {
  final String text;
  final String languageTag;
  final VisualCue? cue;
  final String? ttsOverride;

  const NarrationSegment({
    required this.text,
    required this.languageTag,
    this.cue,
    this.ttsOverride,
  });
}

class NarrationLine {
  final String displayText;
  final List<NarrationSegment> segments;
  final String semanticDescription;

  const NarrationLine({
    required this.displayText,
    required this.segments,
    required this.semanticDescription,
  });
}

class QuestionOption {
  final String id;
  final String label;
  final String? sublabel;
  final String visualKey;
  final String semanticLabel;
  final List<String> spokenAliases;

  const QuestionOption({
    required this.id,
    required this.label,
    this.sublabel,
    required this.visualKey,
    required this.semanticLabel,
    this.spokenAliases = const [],
  });
}

class LessonQuestion {
  final String id;
  final String subject;
  final NarrationLine prompt;
  final QuestionType type;
  final List<QuestionOption> options;
  final String correctOptionId;
  final List<NarrationLine> correctFeedback;
  final List<NarrationLine> retryFeedback;
  final NarrationLine? hint;
  final VisualCue? hintCue;

  const LessonQuestion({
    required this.id,
    required this.subject,
    required this.prompt,
    required this.type,
    required this.options,
    required this.correctOptionId,
    required this.correctFeedback,
    required this.retryFeedback,
    this.hint,
    this.hintCue,
  });
}

class StoryBeat {
  final String id;
  final SceneId sceneId;
  final NarrationLine narration;
  final bool requiresMicInteraction; // specific for Beat 1

  const StoryBeat({
    required this.id,
    required this.sceneId,
    required this.narration,
    this.requiresMicInteraction = false,
  });
}

class LessonSummary {
  final NarrationLine overallNarration;
  final List<NarrationLine> summaryPoints;

  const LessonSummary({
    required this.overallNarration,
    required this.summaryPoints,
  });
}

class Lesson {
  final int standard;
  final int level;
  final String id;
  final String titleEn;
  final String titleMr;
  final String theme;
  final List<String> concepts;
  final List<StoryBeat> beats;
  final List<LessonQuestion> questions;
  final LessonSummary summary;
  final String? nextLessonId;

  const Lesson({
    required this.standard,
    required this.level,
    required this.id,
    required this.titleEn,
    required this.titleMr,
    required this.theme,
    required this.concepts,
    required this.beats,
    required this.questions,
    required this.summary,
    this.nextLessonId,
  });
}
