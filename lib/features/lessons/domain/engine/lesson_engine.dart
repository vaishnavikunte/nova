import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/lesson_models.dart';
import '../../presentation/widgets/nova_character.dart';
import '../../presentation/widgets/chintu_character.dart';
import '../../services/lesson_tts_service.dart';
import '../../services/offline_asr_service.dart';

enum LessonPhase { loading, story, challenge, summary, celebration }

class LessonState {
  final Lesson? lesson;
  final LessonPhase phase;
  final int currentBeatIndex;
  final int currentQuestionIndex;
  final NovaState novaState;
  final ChintuState chintuState;
  final VisualCue currentCue;
  final bool isPlayingAudio;
  final bool isListening;
  final String transcript;
  final String feedbackText;
  final Set<String> completedPairIds;
  final String? selectedOptionId;
  final bool? isCorrectAnswer;
  final bool showContinueButton;
  final bool isMuted;

  const LessonState({
    this.lesson,
    this.phase = LessonPhase.loading,
    this.currentBeatIndex = 0,
    this.currentQuestionIndex = 0,
    this.novaState = NovaState.idle,
    this.chintuState = ChintuState.idle,
    this.currentCue = VisualCue.none,
    this.isPlayingAudio = false,
    this.isListening = false,
    this.transcript = '',
    this.feedbackText = '',
    this.completedPairIds = const {},
    this.selectedOptionId,
    this.isCorrectAnswer,
    this.showContinueButton = false,
    this.isMuted = false,
  });

  LessonState copyWith({
    Lesson? lesson,
    LessonPhase? phase,
    int? currentBeatIndex,
    int? currentQuestionIndex,
    NovaState? novaState,
    ChintuState? chintuState,
    VisualCue? currentCue,
    bool? isPlayingAudio,
    bool? isListening,
    String? transcript,
    String? feedbackText,
    Set<String>? completedPairIds,
    String? selectedOptionId,
    bool? isCorrectAnswer,
    bool? showContinueButton,
    bool? isMuted,
    bool clearSelectedOption = false,
  }) {
    return LessonState(
      lesson: lesson ?? this.lesson,
      phase: phase ?? this.phase,
      currentBeatIndex: currentBeatIndex ?? this.currentBeatIndex,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      novaState: novaState ?? this.novaState,
      chintuState: chintuState ?? this.chintuState,
      currentCue: currentCue ?? this.currentCue,
      isPlayingAudio: isPlayingAudio ?? this.isPlayingAudio,
      isListening: isListening ?? this.isListening,
      transcript: transcript ?? this.transcript,
      feedbackText: feedbackText ?? this.feedbackText,
      completedPairIds: completedPairIds ?? this.completedPairIds,
      selectedOptionId: clearSelectedOption ? null : (selectedOptionId ?? this.selectedOptionId),
      isCorrectAnswer: clearSelectedOption ? null : (isCorrectAnswer ?? this.isCorrectAnswer),
      showContinueButton: showContinueButton ?? this.showContinueButton,
      isMuted: isMuted ?? this.isMuted,
    );
  }
}

class LessonEngine extends Notifier<LessonState> {
  late final LessonTtsService _ttsService;
  late final OfflineAsrSpeechInput _asrService;

  @override
  LessonState build() {
    _ttsService = LessonTtsService();
    _asrService = OfflineAsrSpeechInput();
    _asrService.initialize();
    return const LessonState();
  }

  void loadLesson(Lesson lesson) {
    state = state.copyWith(
      lesson: lesson,
      phase: LessonPhase.story,
      currentBeatIndex: 0,
      currentQuestionIndex: 0,
      currentCue: VisualCue.none,
      feedbackText: '',
      completedPairIds: {},
      clearSelectedOption: true,
      showContinueButton: false,
    );
  }

  Future<void> startLesson() async {
    await playCurrentBeat();
  }

  void toggleSound() {
    final newMuted = !state.isMuted;
    if (newMuted) {
      _ttsService.stop();
    }
    state = state.copyWith(isMuted: newMuted);
  }

  Future<void> playCurrentBeat() async {
    if (state.lesson == null) return;
    
    final beat = state.lesson!.beats[state.currentBeatIndex];
    state = state.copyWith(
      isPlayingAudio: true, 
      novaState: NovaState.talking, 
      currentCue: VisualCue.none,
      feedbackText: beat.narration.displayText,
      showContinueButton: false,
    );
    
    if (!state.isMuted) {
      await _ttsService.playNarration(
        beat.narration,
        onSegmentStart: (cue) {
          if (cue != null) {
            state = state.copyWith(currentCue: cue);
          }
        },
      );
    }

    state = state.copyWith(
      isPlayingAudio: false, 
      novaState: NovaState.idle,
      showContinueButton: true,
    );

    if (beat.requiresMicInteraction) {
      await startListeningForBeat();
    }
  }

  Future<void> replayCurrentBeat() async {
    if (state.isPlayingAudio) {
      await _ttsService.stop();
    }
    await playCurrentBeat();
  }

  void skipStory() {
    _ttsService.stop();
    _asrService.stopListening();
    state = state.copyWith(
      phase: LessonPhase.challenge,
      currentQuestionIndex: 0,
      isListening: false,
      isPlayingAudio: false,
      completedPairIds: {},
      clearSelectedOption: true,
      showContinueButton: false,
    );
    _playCurrentQuestion();
  }

  Future<void> startListeningForBeat() async {
    state = state.copyWith(isListening: true, novaState: NovaState.listening, transcript: '');
    await _asrService.startListening(
      onResult: (words) async {
        state = state.copyWith(transcript: words);
        if (words.toLowerCase().contains("good morning") || words.toLowerCase().contains("good")) {
          await _asrService.stopListening();
          state = state.copyWith(
            isListening: false, 
            novaState: NovaState.happy, 
            feedbackText: 'शाब्बास! Good Morning!',
            showContinueButton: true,
          );
          if (!state.isMuted) {
            await _ttsService.playNarration(const NarrationLine(
              displayText: "Excellent! Good Morning!",
              semanticDescription: "Happy",
              segments: [NarrationSegment(text: "Good Morning!", languageTag: 'en-IN')],
            ));
          }
        }
      },
    );
  }

  void nextBeat() {
    if (state.lesson == null) return;
    _ttsService.stop();
    _asrService.stopListening();
    
    if (state.currentBeatIndex + 1 < state.lesson!.beats.length) {
      state = state.copyWith(
        currentBeatIndex: state.currentBeatIndex + 1,
        isListening: false,
        clearSelectedOption: true,
      );
      playCurrentBeat();
    } else {
      // Transition to challenge phase
      state = state.copyWith(
        phase: LessonPhase.challenge, 
        currentQuestionIndex: 0,
        isListening: false,
        completedPairIds: {},
        clearSelectedOption: true,
        showContinueButton: false,
      );
      _playCurrentQuestion();
    }
  }

  Future<void> _playCurrentQuestion() async {
    if (state.lesson == null) return;
    final question = state.lesson!.questions[state.currentQuestionIndex];
    
    state = state.copyWith(
      isPlayingAudio: true, 
      novaState: NovaState.talking,
      feedbackText: question.prompt.displayText,
      clearSelectedOption: true,
      showContinueButton: false,
      completedPairIds: {},
    );
    
    if (!state.isMuted) {
      await _ttsService.playNarration(question.prompt);
    }
    state = state.copyWith(isPlayingAudio: false, novaState: NovaState.idle);

    if (question.type == QuestionType.voice || question.type == QuestionType.tapOrVoice) {
      startListeningForQuestion(question);
    }
  }

  Future<void> replayCurrentQuestion() async {
    if (state.isPlayingAudio) {
      await _ttsService.stop();
    }
    await _playCurrentQuestion();
  }

  Future<void> startListeningForQuestion(LessonQuestion question) async {
    state = state.copyWith(isListening: true, novaState: NovaState.listening, transcript: '');
    await _asrService.startListening(
      onResult: (words) async {
        state = state.copyWith(transcript: words);
        final lowerWords = words.toLowerCase();
        
        for (final option in question.options) {
          for (final alias in option.spokenAliases) {
            if (lowerWords.contains(alias.toLowerCase())) {
              await _asrService.stopListening();
              submitAnswer(option.id);
              return;
            }
          }
        }
      },
    );
  }

  Future<void> submitAnswer(String optionId) async {
    if (state.lesson == null || state.phase != LessonPhase.challenge) return;
    
    if (state.isListening) {
      await _asrService.stopListening();
      state = state.copyWith(isListening: false);
    }

    final question = state.lesson!.questions[state.currentQuestionIndex];
    if (optionId == question.correctOptionId) {
      // Correct!
      state = state.copyWith(
        selectedOptionId: optionId,
        isCorrectAnswer: true,
        novaState: NovaState.happy, 
        feedbackText: question.correctFeedback.first.displayText,
        showContinueButton: true,
      );
      if (!state.isMuted) {
        await _ttsService.playNarration(question.correctFeedback.first);
      }
    } else {
      // Incorrect / Retry
      state = state.copyWith(
        selectedOptionId: optionId,
        isCorrectAnswer: false,
        novaState: NovaState.talking, 
        feedbackText: question.retryFeedback.first.displayText,
        showContinueButton: false,
      );
      if (!state.isMuted) {
        await _ttsService.playNarration(question.retryFeedback.first);
      }
      state = state.copyWith(novaState: NovaState.idle);
      
      if (question.type == QuestionType.voice || question.type == QuestionType.tapOrVoice) {
        startListeningForQuestion(question);
      }
    }
  }

  Future<void> submitPairMatch(String leftId, String rightId) async {
    if (state.lesson == null || state.phase != LessonPhase.challenge) return;
    final question = state.lesson!.questions[state.currentQuestionIndex];

    if (leftId == rightId) {
      // Correct match!
      final updatedCompleted = Set<String>.from(state.completedPairIds)..add(leftId);
      final allDone = updatedCompleted.length >= question.matchingPairs.length;

      state = state.copyWith(
        completedPairIds: updatedCompleted,
        novaState: allDone ? NovaState.happy : NovaState.talking,
        feedbackText: allDone
            ? question.correctFeedback.first.displayText
            : 'शाब्बास! बरोबर जोडी! ($updatedCompleted.length / ${question.matchingPairs.length})',
        showContinueButton: allDone,
      );

      if (allDone && !state.isMuted) {
        await _ttsService.playNarration(question.correctFeedback.first);
      }
    } else {
      // Mismatch!
      state = state.copyWith(
        novaState: NovaState.talking,
        feedbackText: question.retryFeedback.first.displayText,
        showContinueButton: false,
      );
      if (!state.isMuted) {
        await _ttsService.playNarration(question.retryFeedback.first);
      }
      state = state.copyWith(novaState: NovaState.idle);
    }
  }

  void nextQuestion() {
    if (state.lesson == null) return;
    _ttsService.stop();
    _asrService.stopListening();

    if (state.currentQuestionIndex + 1 < state.lesson!.questions.length) {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex + 1,
        clearSelectedOption: true,
        completedPairIds: {},
        showContinueButton: false,
      );
      _playCurrentQuestion();
    } else {
      // Finish challenge, open summary
      state = state.copyWith(
        phase: LessonPhase.summary,
        clearSelectedOption: true,
        showContinueButton: true,
      );
      _playSummary();
    }
  }

  Future<void> _playSummary() async {
    if (state.lesson == null) return;
    final summary = state.lesson!.summary;
    
    state = state.copyWith(
      isPlayingAudio: true, 
      novaState: NovaState.talking,
      feedbackText: summary.overallNarration.displayText,
      showContinueButton: true,
    );
    
    if (!state.isMuted) {
      await _ttsService.playNarration(summary.overallNarration);
    }
    state = state.copyWith(
      phase: LessonPhase.celebration, 
      isPlayingAudio: false, 
      novaState: NovaState.happy,
      feedbackText: 'शाब्बास! आजचा धडा पूर्ण झाला!',
    );
  }

  void resetLesson() {
    if (state.lesson == null) return;
    loadLesson(state.lesson!);
    startLesson();
  }

  void dispose() {
    _asrService.stopListening();
    _ttsService.stop();
  }
}

final lessonEngineProvider = NotifierProvider<LessonEngine, LessonState>(
  () => LessonEngine(),
);
