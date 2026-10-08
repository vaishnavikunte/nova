import '../domain/models/lesson_models.dart';

const Lesson level1Lesson = Lesson(
  standard: 1,
  level: 1,
  id: 'std1_level1_morning',
  titleEn: 'My Morning in the Village',
  titleMr: 'माझी सकाळ',
  theme: 'My Morning in the Village',
  concepts: [
    'EVS – Morning/Day',
    'English – Good Morning',
    'Maths – Top/Bottom',
    'Maths – Big/Small'
  ],
  beats: [
    StoryBeat(
      id: 'beat1_morning',
      sceneId: SceneId.house,
      requiresMicInteraction: true,
      narration: NarrationLine(
        displayText: "शुभ सकाळ, चिंटू! सूर्य उगवला आहे आणि सकाळ झाली आहे. जेव्हा आपण सकाळी उठतो, तेव्हा आपण 'Good Morning' म्हणतो.",
        semanticDescription: "A village morning. The sun is rising. Chintu is standing outside his house with a glowing tablet.",
        segments: [
          NarrationSegment(text: "शुभ सकाळ, चिंटू! सूर्य उगवला आहे आणि सकाळ झाली आहे. जेव्हा आपण सकाळी उठतो, तेव्हा आपण", languageTag: "mr-IN", cue: VisualCue.sun),
          NarrationSegment(text: "Good Morning", languageTag: "en-IN"),
          NarrationSegment(text: "म्हणतो.", languageTag: "mr-IN"),
        ],
      ),
    ),
    StoryBeat(
      id: 'beat2_top_bottom',
      sceneId: SceneId.roofAndGround,
      narration: NarrationLine(
        displayText: "वर बघ चिंटू! छतावर चिऊताई बसली आहे. आणि खाली बघ, जमिनीवर गण्या वासरू झोपले आहे.",
        semanticDescription: "The house roof and the ground. Chiu the sparrow is sitting on the roof. Ganya the calf is sleeping on the ground.",
        segments: [
          NarrationSegment(text: "वर बघ चिंटू!", languageTag: "mr-IN", cue: VisualCue.roof),
          NarrationSegment(text: "छतावर चिऊताई बसली आहे.", languageTag: "mr-IN", cue: VisualCue.chiu),
          NarrationSegment(text: "आणि खाली बघ,", languageTag: "mr-IN", cue: VisualCue.ground),
          NarrationSegment(text: "जमिनीवर गण्या वासरू झोपले आहे.", languageTag: "mr-IN", cue: VisualCue.ganya),
        ],
      ),
    ),
    StoryBeat(
      id: 'beat3_big_small',
      sceneId: SceneId.farm,
      narration: NarrationLine(
        displayText: "शेतात एक मोठा ट्रॅक्टर उभा आहे, आणि त्याजवळ एक छोटी बादली ठेवली आहे.",
        semanticDescription: "A farm scene. A large tractor is parked next to a small bucket.",
        segments: [
          NarrationSegment(text: "शेतात एक मोठा ट्रॅक्टर उभा आहे,", languageTag: "mr-IN", cue: VisualCue.tractor),
          NarrationSegment(text: "आणि त्याजवळ एक छोटी बादली ठेवली आहे.", languageTag: "mr-IN", cue: VisualCue.bucket),
        ],
      ),
    ),
  ],
  questions: [
    LessonQuestion(
      id: 'q1_big_small',
      subject: 'Maths',
      prompt: NarrationLine(
        displayText: "मोठ्या वाहनावर टॅप करा.",
        semanticDescription: "Select the big vehicle.",
        segments: [NarrationSegment(text: "मोठ्या वाहनावर टॅप करा.", languageTag: "mr-IN")],
      ),
      type: QuestionType.tap,
      correctOptionId: 'tractor',
      options: [
        QuestionOption(
          id: 'tractor',
          label: 'Tractor',
          visualKey: 'tractor_large',
          semanticLabel: 'Big tractor. Tap to select.',
        ),
        QuestionOption(
          id: 'bicycle',
          label: 'Bicycle',
          visualKey: 'bicycle_small',
          semanticLabel: 'Small bicycle. Tap to select.',
        ),
      ],
      correctFeedback: [
        NarrationLine(
          displayText: "Excellent! ⭐",
          semanticDescription: "NOVA celebrates.",
          segments: [NarrationSegment(text: "Excellent!", languageTag: "en-IN")],
        ),
      ],
      retryFeedback: [
        NarrationLine(
          displayText: "Try again! Look carefully.",
          semanticDescription: "NOVA is encouraging.",
          segments: [NarrationSegment(text: "Try again! Look carefully.", languageTag: "en-IN")],
        ),
      ],
    ),
    LessonQuestion(
      id: 'q2_top_bottom',
      subject: 'Maths',
      prompt: NarrationLine(
        displayText: "छताच्या वर कोण बसले आहे ते निवडा.",
        semanticDescription: "Select who is sitting on the roof.",
        segments: [NarrationSegment(text: "छताच्या वर कोण बसले आहे ते निवडा.", languageTag: "mr-IN")],
      ),
      type: QuestionType.tap,
      correctOptionId: 'chiu',
      options: [
        QuestionOption(
          id: 'chiu',
          label: 'Chiu 🐦',
          visualKey: 'chiu_sparrow',
          semanticLabel: 'Chiu sparrow sitting on top.',
        ),
        QuestionOption(
          id: 'ganya',
          label: 'Ganya 🐄',
          visualKey: 'ganya_calf',
          semanticLabel: 'Ganya calf on the ground.',
        ),
      ],
      correctFeedback: [
        NarrationLine(
          displayText: "बरोबर!",
          semanticDescription: "NOVA smiles.",
          segments: [NarrationSegment(text: "बरोबर!", languageTag: "mr-IN")],
        ),
      ],
      retryFeedback: [
        NarrationLine(
          displayText: "Let's look at the roof again!",
          semanticDescription: "NOVA is encouraging.",
          segments: [NarrationSegment(text: "Let's look at the roof again!", languageTag: "en-IN")],
        ),
      ],
    ),
    LessonQuestion(
      id: 'q3_greeting',
      subject: 'English',
      prompt: NarrationLine(
        displayText: "जेव्हा सूर्य उगवतो, तेव्हा आपण काय म्हणतो? योग्य पर्याय निवडा.",
        semanticDescription: "What do we say when the sun rises?",
        segments: [NarrationSegment(text: "जेव्हा सूर्य उगवतो, तेव्हा आपण काय म्हणतो? योग्य पर्याय निवडा.", languageTag: "mr-IN")],
      ),
      type: QuestionType.tapOrVoice,
      correctOptionId: 'good_morning',
      options: [
        QuestionOption(
          id: 'good_morning',
          label: 'Good Morning',
          visualKey: 'sun_morning',
          semanticLabel: 'Good Morning. Rising sun.',
          spokenAliases: ['good morning', 'gud morning', 'गुड मॉर्निंग'],
        ),
        QuestionOption(
          id: 'good_night',
          label: 'Good Night',
          visualKey: 'moon_night',
          semanticLabel: 'Good Night. Moon and night sky.',
          spokenAliases: ['good night', 'gud night', 'गुड नाईट'],
        ),
      ],
      correctFeedback: [
        NarrationLine(
          displayText: "Great job! ⭐",
          semanticDescription: "NOVA celebrates.",
          segments: [NarrationSegment(text: "Great job!", languageTag: "en-IN")],
        ),
      ],
      retryFeedback: [
        NarrationLine(
          displayText: "Let's think about the sun!",
          semanticDescription: "NOVA is encouraging.",
          segments: [NarrationSegment(text: "Let's think about the sun!", languageTag: "en-IN")],
        ),
      ],
    ),
  ],
  summary: LessonSummary(
    overallNarration: NarrationLine(
      displayText: "शाब्बास! आज आपण खूप काही शिकलो!\n१. सकाळी उठल्यावर आपण 'Good Morning' म्हणतो.\n२. आपण आकाशात आणि छतावर 'वर' (Top) पाहिलं.\n३. आणि ट्रॅक्टर 'मोठा' (Big) असतो हे ओळखलं.\nपुढच्या खेळात आपण मोजायला शिकूया!",
      semanticDescription: "NOVA summarizes the lesson.",
      segments: [
        NarrationSegment(text: "शाब्बास! आज आपण खूप काही शिकलो!", languageTag: "mr-IN"),
        NarrationSegment(text: "सकाळी उठल्यावर आपण 'Good Morning' म्हणतो.", languageTag: "mr-IN"),
        NarrationSegment(text: "आपण आकाशात आणि छतावर 'वर' (Top) पाहिलं.", languageTag: "mr-IN"),
        NarrationSegment(text: "आणि ट्रॅक्टर 'मोठा' (Big) असतो हे ओळखलं.", languageTag: "mr-IN"),
        NarrationSegment(text: "पुढच्या खेळात आपण मोजायला शिकूया!", languageTag: "mr-IN"),
      ],
    ),
    summaryPoints: [
      NarrationLine(
        displayText: "☀️ Good Morning",
        semanticDescription: "Good Morning",
        segments: [],
      ),
      NarrationLine(
        displayText: "⬆️ Top / वर",
        semanticDescription: "Top",
        segments: [],
      ),
      NarrationLine(
        displayText: "🚜 Big / मोठा",
        semanticDescription: "Big",
        segments: [],
      ),
    ],
  ),
);
