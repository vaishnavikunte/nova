import 'package:flutter/material.dart';

enum LessonStageType {
  story,
  challenge,
  summary,
  celebration,
}

class LessonStage {
  final String id;
  final LessonStageType type;
  final String title;

  const LessonStage({
    required this.id,
    required this.type,
    required this.title,
  });
}

class LessonData {
  final int standard;
  final int level;
  final String title;
  final List<LessonStage> stages;

  const LessonData({
    required this.standard,
    required this.level,
    required this.title,
    required this.stages,
  });
}
