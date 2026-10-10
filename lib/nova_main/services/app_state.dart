import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/badges_data.dart';
import '../data/curriculum_data.dart';
import '../models/accessibility_settings.dart';
import '../models/badge.dart';
import '../models/class_course.dart';
import '../models/emotion_state.dart';
import '../models/level_model.dart';
import '../models/question_model.dart';
import '../models/student.dart';
import 'adaptive_engine.dart';
import 'assessment_service.dart';

/// Central state store for NOVA application following ChangeNotifier pattern.
class AppState extends ChangeNotifier {
  late Map<int, ClassCourse> _courses;
  late Student _student;
  late List<BadgeModel> _badges;
  AccessibilitySettings _accessibility = const AccessibilitySettings();

  // Active Level Learning Session
  LevelModel? _activeLevel;
  int _currentTier = 1;
  int _sessionQuestionSlot = 0; // 0 to 4 (5 questions per session)
  List<QuestionAttempt> _sessionAttempts = [];
  int _currentQuestionHints = 0;
  EmotionState _currentEmotion = EmotionState.neutral;
  AdaptiveEvaluation? _lastEvaluation;
  int _hintsUsedInSession = 0;
  int _resolvedWithHelpCount = 0;

  // Demo Controls Overrides
  bool? _forcedAnswerOutcome; // true = correct, false = incorrect, null = auto
  EmotionState? _forcedEmotion;
  bool _lockEmotion = false;
  bool _voiceMishearOnce = false;
  bool _showDemoFab = true;

  AppState() {
    _initInitialState();
  }

  void _initInitialState() {
    _courses = CurriculumData.buildAllCourses();
    _badges = List<BadgeModel>.from(BadgesData.allBadges);
    _student = const Student(
      name: 'Explorer',
      classNumber: 4,
      stars: 120,
      streak: 3,
      earnedBadgeIds: ['welcome_explorer', 'class4_l1_badge'],
      completedLevels: {1},
      currentLevel: 1,
      recommendedLevel: 1,
      avatarColorIndex: 0,
    );

    // Set Level 1 to available/completed
    _updateLevelStatesForClass(4, 1, 1);

    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('isDarkMode')) {
      _accessibility = _accessibility.copyWith(
        isDarkMode: prefs.getBool('isDarkMode'),
      );
      notifyListeners();
    }
  }

  // Getters
  Student get student => _student;
  AccessibilitySettings get accessibility => _accessibility;
  List<BadgeModel> get badges => _badges;
  LevelModel? get activeLevel => _activeLevel;
  int get currentTier => _currentTier;
  int get sessionQuestionSlot => _sessionQuestionSlot;
  int get currentQuestionHints => _currentQuestionHints;
  EmotionState get currentEmotion => _currentEmotion;
  AdaptiveEvaluation? get lastEvaluation => _lastEvaluation;
  int get hintsUsedInSession => _hintsUsedInSession;
  bool? get forcedAnswerOutcome => _forcedAnswerOutcome;
  EmotionState? get forcedEmotion => _forcedEmotion;
  bool get lockEmotion => _lockEmotion;
  bool get voiceMishearOnce => _voiceMishearOnce;
  bool get showDemoFab => _showDemoFab;

  ClassCourse get currentCourse =>
      _courses[_student.classNumber] ?? _courses[4]!;
  List<LevelModel> get currentLevels => currentCourse.levels;

  // ---------------------------------------------------------------------------
  // Student & Onboarding Actions
  // ---------------------------------------------------------------------------

  void setStudentName(String name) {
    final cleanName = name.trim().isEmpty ? 'Explorer' : name.trim();
    _student = _student.copyWith(name: cleanName);
    notifyListeners();
  }

  void setClassNumber(int classNumber) {
    if (classNumber < 1 || classNumber > 6) return;
    _student = _student.copyWith(
      classNumber: classNumber,
      currentLevel: 1,
      recommendedLevel: 1,
      completedLevels: {},
    );
    _updateLevelStatesForClass(classNumber, 1, 1);
    notifyListeners();
  }

  void setAvatarColorIndex(int index) {
    _student = _student.copyWith(avatarColorIndex: index);
    notifyListeners();
  }

  void clearStudentSession() {
    // Clear student name without clearing progress
    _student = _student.copyWith(name: 'Explorer');
    
    // Clear active session info
    _activeLevel = null;
    _currentTier = 1;
    _sessionQuestionSlot = 0;
    _sessionAttempts = [];
    _currentQuestionHints = 0;
    _currentEmotion = EmotionState.neutral;
    _lastEvaluation = null;
    _hintsUsedInSession = 0;
    _resolvedWithHelpCount = 0;

    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Assessment Actions
  // ---------------------------------------------------------------------------

  void submitAssessment(AssessmentOutcome outcome) {
    final rec = outcome.recommendedLevel;
    _student = _student.copyWith(
      recommendedLevel: rec,
      currentLevel: rec,
      earnedBadgeIds: [..._student.earnedBadgeIds, 'assessment_pro'],
    );

    _unlockBadge('assessment_pro');
    _updateLevelStatesForClass(_student.classNumber, rec, rec);
    notifyListeners();
  }

  void applyEasierLevel() {
    final newLevel = max(1, _student.recommendedLevel - 2);
    _student = _student.copyWith(
      recommendedLevel: newLevel,
      currentLevel: newLevel,
    );
    _updateLevelStatesForClass(_student.classNumber, newLevel, newLevel);
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Level & Map Progression
  // ---------------------------------------------------------------------------

  void setCurrentLevel(int levelNumber) {
    _student = _student.copyWith(currentLevel: levelNumber);
    _updateLevelStatesForClass(
      _student.classNumber,
      levelNumber,
      _student.recommendedLevel,
    );
    notifyListeners();
  }

  void _updateLevelStatesForClass(int classNum, int currentLvl, int recLvl) {
    final course = _courses[classNum];
    if (course == null) return;

    final updated = course.levels.map((lvl) {
      if (_student.completedLevels.contains(lvl.number)) {
        return lvl.copyWith(state: LevelState.completed);
      } else if (lvl.number == currentLvl) {
        return lvl.copyWith(state: LevelState.current);
      } else if (lvl.number < currentLvl) {
        return lvl.copyWith(state: LevelState.available);
      } else {
        return lvl.copyWith(state: LevelState.locked);
      }
    }).toList();

    _courses[classNum] = ClassCourse(
      classNumber: classNum,
      title: course.title,
      levels: updated,
    );
  }

  void startLevel(int levelNumber) {
    final course = currentCourse;
    _activeLevel = course.getLevel(levelNumber);
    _currentTier = _activeLevel?.difficulty ?? 1;
    _sessionQuestionSlot = 0;
    _sessionAttempts = [];
    _currentQuestionHints = 0;
    _currentEmotion = EmotionState.neutral;
    _lastEvaluation = null;
    _hintsUsedInSession = 0;
    _resolvedWithHelpCount = 0;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Question & Session Evaluation
  // ---------------------------------------------------------------------------

  QuestionModel? getActiveQuestion() {
    if (_activeLevel == null) return null;
    final pool = _activeLevel!.questionPool;
    final matching = pool.where((q) => q.tier == _currentTier).toList();
    if (matching.isNotEmpty) {
      return matching[_sessionQuestionSlot % matching.length];
    }
    return pool[_sessionQuestionSlot % pool.length];
  }

  void useHint() {
    if (_currentQuestionHints < 3) {
      _currentQuestionHints++;
      _hintsUsedInSession++;
      notifyListeners();
    }
  }

  AdaptiveEvaluation answerQuestion(int selectedIndex) {
    final question = getActiveQuestion()!;
    final eval = AdaptiveEngine.evaluate(
      question: question,
      selectedIndex: selectedIndex,
      currentTier: _currentTier,
      sessionHistory: _sessionAttempts,
      currentQuestionHintsUsed: _currentQuestionHints,
      forcedEmotion: _forcedEmotion,
      forcedAnswerOutcome: _forcedAnswerOutcome,
    );

    _lastEvaluation = eval;
    _currentEmotion = eval.emotion;
    _currentTier = eval.nextTier;

    _sessionAttempts.add(
      QuestionAttempt(
        isCorrect: eval.isCorrect,
        hintsUsed: _currentQuestionHints,
      ),
    );

    // Clear single-use emotion if not locked
    if (!_lockEmotion) {
      _forcedEmotion = null;
    }

    notifyListeners();
    return eval;
  }

  void advanceToNextQuestionSlot() {
    if (_sessionQuestionSlot < 4) {
      _sessionQuestionSlot++;
      _currentQuestionHints = 0;
      _lastEvaluation = null;
      notifyListeners();
    }
  }

  void resolveQuestionWithHelp() {
    _resolvedWithHelpCount++;
    _sessionAttempts.add(const QuestionAttempt(isCorrect: true, hintsUsed: 3));
    advanceToNextQuestionSlot();
  }

  void completeLevel() {
    if (_activeLevel == null) return;
    final lvl = _activeLevel!;

    final baseReward = lvl.rewardStars;
    final hintPenalty = min(10, _hintsUsedInSession * 2);
    final confidentBonus = _currentEmotion == EmotionState.confident ? 2 : 0;
    final totalReward = max(10, baseReward - hintPenalty + confidentBonus);

    // Rating (1..3 stars)
    int starRating = 1;
    if (_hintsUsedInSession <= 1 && _resolvedWithHelpCount == 0) {
      starRating = 3;
    } else if (_hintsUsedInSession <= 4) {
      starRating = 2;
    }

    final newCompleted = Set<int>.from(_student.completedLevels)
      ..add(lvl.number);
    final nextLevelNum = min(15, lvl.number + 1);

    // Unlock badge if defined
    if (lvl.badgeId.isNotEmpty) {
      _unlockBadge(lvl.badgeId);
    }

    _student = _student.copyWith(
      stars: _student.stars + totalReward,
      streak: _student.streak + 1,
      completedLevels: newCompleted,
      currentLevel: nextLevelNum,
      earnedBadgeIds: lvl.badgeId.isNotEmpty
          ? {..._student.earnedBadgeIds, lvl.badgeId}.toList()
          : _student.earnedBadgeIds,
    );

    // Update level model in course
    final course = currentCourse;
    final updatedLevels = course.levels.map((l) {
      if (l.number == lvl.number) {
        return l.copyWith(state: LevelState.completed, earnedStars: starRating);
      } else if (l.number == nextLevelNum) {
        return l.copyWith(state: LevelState.current);
      }
      return l;
    }).toList();

    _courses[_student.classNumber] = ClassCourse(
      classNumber: _student.classNumber,
      title: course.title,
      levels: updatedLevels,
    );

    _activeLevel = null;
    notifyListeners();
  }

  void _unlockBadge(String badgeId) {
    _badges = _badges.map((b) {
      if (b.id == badgeId) {
        return b.copyWith(isUnlocked: true, unlockedAt: DateTime.now());
      }
      return b;
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // Accessibility
  // ---------------------------------------------------------------------------

  void updateAccessibility(AccessibilitySettings settings) {
    if (_accessibility.isDarkMode != settings.isDarkMode) {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setBool('isDarkMode', settings.isDarkMode);
      });
    }
    _accessibility = settings;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Demo Controls
  // ---------------------------------------------------------------------------

  void setForcedAnswerOutcome(bool? outcome) {
    _forcedAnswerOutcome = outcome;
    notifyListeners();
  }

  /// Backwards-compatible alias used by the evaluator controls.
  void setForceAnswerOutcome(bool? outcome) {
    setForcedAnswerOutcome(outcome);
  }

  void setForcedEmotion(EmotionState? emotion, {bool lock = false}) {
    _forcedEmotion = emotion;
    _lockEmotion = lock;
    if (emotion != null) {
      _currentEmotion = emotion;
    }
    notifyListeners();
  }

  void setVoiceMishearOnce(bool mishear) {
    _voiceMishearOnce = mishear;
    notifyListeners();
  }

  void toggleDemoFab(bool visible) {
    _showDemoFab = visible;
    notifyListeners();
  }

  void unlockAllLevels() {
    final course = currentCourse;
    final allUnlocked = course.levels.map((l) {
      return l.copyWith(state: LevelState.available);
    }).toList();
    _courses[_student.classNumber] = ClassCourse(
      classNumber: _student.classNumber,
      title: course.title,
      levels: allUnlocked,
    );
    notifyListeners();
  }

  void setStarsAndStreak(int stars, int streak) {
    _student = _student.copyWith(stars: stars, streak: streak);
    notifyListeners();
  }

  void resetDemo() {
    _initInitialState();
    notifyListeners();
  }
}

/// InheritedNotifier exposing AppState down the widget hierarchy.
class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState appState,
    required super.child,
  }) : super(notifier: appState);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'No AppStateScope found in context');
    return scope!.notifier!;
  }
}
