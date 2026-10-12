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
    );
  }

  Future<void> startLesson() async {
    await playCurrentBeat();
  }

  Future<void> playCurrentBeat() async {
    if (state.lesson == null) return;
    
    final beat = state.lesson!.beats[state.currentBeatIndex];
    state = state.copyWith(
      isPlayingAudio: true, 
      novaState: NovaState.talking, 
      currentCue: VisualCue.none,
      feedbackText: beat.narration.displayText,
    );
    
    await _ttsService.playNarration(
      beat.narration,
      onSegmentStart: (cue) {
        if (cue != null) {
          state = state.copyWith(currentCue: cue);
        }
      },
    );

    state = state.copyWith(isPlayingAudio: false, novaState: NovaState.idle);

    if (beat.requiresMicInteraction) {
      await startListeningForBeat();
    } else {
      // Auto advance after brief pause
      Future.delayed(const Duration(seconds: 1), () => nextBeat());
    }
  }

  Future<void> startListeningForBeat() async {
    state = state.copyWith(isListening: true, novaState: NovaState.listening, transcript: '');
    await _asrService.startListening(
      onResult: (words) async {
        state = state.copyWith(transcript: words);
        if (words.toLowerCase().contains("good morning") || words.toLowerCase().contains("good")) {
          await _asrService.stopListening();
          state = state.copyWith(isListening: false, novaState: NovaState.happy, feedbackText: 'Excellent!');
          await _ttsService.playNarration(const NarrationLine(
            displayText: "Excellent!",
            semanticDescription: "Happy",
            segments: [NarrationSegment(text: "Excellent!", languageTag: 'en-IN')]
          ));
          nextBeat();
        }
      },
    );
  }

  void nextBeat() {
    if (state.lesson == null) return;
    
    if (state.currentBeatIndex + 1 < state.lesson!.beats.length) {
      state = state.copyWith(currentBeatIndex: state.currentBeatIndex + 1);
      playCurrentBeat();
    } else {
      // Transition to challenge phase
      state = state.copyWith(phase: LessonPhase.challenge, currentQuestionIndex: 0);
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
    );
    
    await _ttsService.playNarration(question.prompt);
    state = state.copyWith(isPlayingAudio: false, novaState: NovaState.idle);

    if (question.type == QuestionType.voice || question.type == QuestionType.tapOrVoice) {
      startListeningForQuestion(question);
    }
  }

  Future<void> startListeningForQuestion(LessonQuestion question) async {
    state = state.copyWith(isListening: true, novaState: NovaState.listening, transcript: '');
    await _asrService.startListening(
      onResult: (words) async {
        state = state.copyWith(transcript: words);
        final lowerWords = words.toLowerCase();
        
        // Find if spoken words match any option
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
    
    // Stop listening if we were
    if (state.isListening) {
      await _asrService.stopListening();
      state = state.copyWith(isListening: false);
    }

    final question = state.lesson!.questions[state.currentQuestionIndex];
    if (optionId == question.correctOptionId) {
      // Correct!
      state = state.copyWith(novaState: NovaState.happy, feedbackText: question.correctFeedback.first.displayText);
      await _ttsService.playNarration(question.correctFeedback.first);
      
      if (state.currentQuestionIndex + 1 < state.lesson!.questions.length) {
        state = state.copyWith(currentQuestionIndex: state.currentQuestionIndex + 1);
        _playCurrentQuestion();
      } else {
        // Finish challenge
        state = state.copyWith(phase: LessonPhase.summary);
        _playSummary();
      }
    } else {
      // Incorrect
      state = state.copyWith(novaState: NovaState.talking, feedbackText: question.retryFeedback.first.displayText);
      await _ttsService.playNarration(question.retryFeedback.first);
      state = state.copyWith(novaState: NovaState.idle);
      
      if (question.type == QuestionType.voice || question.type == QuestionType.tapOrVoice) {
        startListeningForQuestion(question);
      }
    }
  }

  Future<void> _playSummary() async {
    if (state.lesson == null) return;
    final summary = state.lesson!.summary;
    
    state = state.copyWith(
      isPlayingAudio: true, 
      novaState: NovaState.talking,
      feedbackText: summary.overallNarration.displayText,
    );
    
    await _ttsService.playNarration(summary.overallNarration);
    state = state.copyWith(
      phase: LessonPhase.celebration, 
      isPlayingAudio: false, 
      novaState: NovaState.happy,
      feedbackText: 'Lesson Complete!',
    );
  }

  @override
  void dispose() {
    _asrService.stopListening();
    _ttsService.stop();
  }
}

final lessonEngineProvider = NotifierProvider<LessonEngine, LessonState>(
  () => LessonEngine(),
);
