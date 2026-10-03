import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class QuestionModel {
  final String type;
  final String targetAnswer;

  QuestionModel({required this.type, required this.targetAnswer});

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      type: json['type'] as String,
      targetAnswer: json['target_answer'] as String,
    );
  }
}

class LevelModel {
  final int levelId;
  final String subject;
  final String ruralTheme;
  final String storyIntro;
  final List<QuestionModel> questionPool;

  LevelModel({
    required this.levelId,
    required this.subject,
    required this.ruralTheme,
    required this.storyIntro,
    required this.questionPool,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      levelId: json['level_id'] as int,
      subject: json['subject'] as String,
      ruralTheme: json['rural_theme'] as String,
      storyIntro: json['story_intro'] as String,
      questionPool: (json['question_pool'] as List)
          .map((q) => QuestionModel.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CurriculumLoader {
  List<LevelModel>? _cachedLevels;

  Future<List<LevelModel>> loadStd3Levels() async {
    if (_cachedLevels != null) {
      return _cachedLevels!;
    }

    final String jsonString = await rootBundle.loadString('assets/curriculum/std3_core.json');
    final List<dynamic> jsonList = json.decode(jsonString);

    _cachedLevels = jsonList.map((json) => LevelModel.fromJson(json)).toList();
    return _cachedLevels!;
  }
  
  void clearCache() {
    _cachedLevels = null;
  }
}
