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
          label: 'मोठा ट्रॅक्टर (Tractor)',
          sublabel: 'मोठे वाहन',
          visualKey: 'tractor_large',
          semanticLabel: 'Big tractor. Tap to select.',
        ),
        QuestionOption(
          id: 'bicycle',
          label: 'छोटी सायकल (Bicycle)',
          sublabel: 'छोटे वाहन',
          visualKey: 'bicycle_small',
          semanticLabel: 'Small bicycle. Tap to select.',
        ),
      ],
      correctFeedback: [
        NarrationLine(
          displayText: "शाब्बास! अगदी बरोबर! ⭐",
          semanticDescription: "NOVA celebrates.",
          segments: [NarrationSegment(text: "शाब्बास! अगदी बरोबर!", languageTag: "mr-IN")],
        ),
      ],
      retryFeedback: [
        NarrationLine(
          displayText: "छान प्रयत्न! पुन्हा एकदा बघूया.",
          semanticDescription: "NOVA is encouraging.",
          segments: [NarrationSegment(text: "छान प्रयत्न! पुन्हा एकदा बघूया.", languageTag: "mr-IN")],
        ),
      ],
    ),
    LessonQuestion(
      id: 'q2_match_pairs',
      subject: 'EVS & Maths',
      prompt: NarrationLine(
        displayText: "जोड्या जुळवा! योग्य चित्र आणि शब्दाची जोडी लावा.",
        semanticDescription: "Match each picture with its corresponding concept or word.",
        segments: [
          NarrationSegment(text: "जोड्या जुळवा! योग्य चित्र आणि शब्दाची जोडी लावा.", languageTag: "mr-IN"),
        ],
      ),
      type: QuestionType.matchPairs,
      matchingPairs: [
        MatchingPair(
          id: 'pair_sun_morning',
          leftLabel: 'सूर्य (Sun)',
          leftSublabel: 'सकाळचा सूर्य',
          leftVisualKey: 'sun',
          leftSemanticLabel: 'Sun rising in the morning',
          rightLabel: 'Morning / सकाळ',
          rightSublabel: 'सकाळची वेळ',
          rightVisualKey: 'morning_text',
          rightSemanticLabel: 'Morning / Sakal',
        ),
        MatchingPair(
          id: 'pair_bird_top',
          leftLabel: 'छतावर चिऊताई',
          leftSublabel: 'वर बसलेली',
          leftVisualKey: 'bird_roof',
          leftSemanticLabel: 'Bird sitting on the roof',
          rightLabel: 'Top / वर',
          rightSublabel: 'छतावर',
          rightVisualKey: 'top_text',
          rightSemanticLabel: 'Top / Var',
        ),
        MatchingPair(
          id: 'pair_calf_bottom',
          leftLabel: 'जमिनीवर गण्या वासरू',
          leftSublabel: 'खाली झोपलेले',
          leftVisualKey: 'calf_ground',
          leftSemanticLabel: 'Calf on the ground',
          rightLabel: 'Bottom / खाली',
          rightSublabel: 'जमिनीवर',
          rightVisualKey: 'bottom_text',
          rightSemanticLabel: 'Bottom / Khali',
        ),
      ],
      correctFeedback: [
        NarrationLine(
          displayText: "शाब्बास! सर्व जोड्या छान जुळवल्या! ⭐",
          semanticDescription: "NOVA celebrates.",
          segments: [NarrationSegment(text: "शाब्बास! सर्व जोड्या छान जुळवल्या!", languageTag: "mr-IN")],
        ),
      ],
      retryFeedback: [
        NarrationLine(
          displayText: "छान प्रयत्न! पुन्हा एकदा जोडी लावून बघूया.",
          semanticDescription: "NOVA is encouraging.",
          segments: [NarrationSegment(text: "छान प्रयत्न! पुन्हा एकदा जोडी लावून बघूया.", languageTag: "mr-IN")],
        ),
      ],
    ),
    LessonQuestion(
      id: 'q3_top_bottom',
      subject: 'Maths',
      prompt: NarrationLine(
        displayText: "छताच्या वर कोण बसले आहे?",
        semanticDescription: "Select who is sitting on the roof.",
        segments: [NarrationSegment(text: "छताच्या वर कोण बसले आहे?", languageTag: "mr-IN")],
      ),
      type: QuestionType.tap,
      correctOptionId: 'chiu',
      options: [
        QuestionOption(
          id: 'chiu',
          label: 'चिऊताई (Chiu 🐦)',
          sublabel: 'छतावर बसली आहे',
          visualKey: 'chiu_sparrow',
          semanticLabel: 'Chiu sparrow sitting on the roof.',
        ),
        QuestionOption(
          id: 'ganya',
          label: 'गण्या वासरू (Ganya 🐄)',
          sublabel: 'जमिनीवर झोपले आहे',
          visualKey: 'ganya_calf',
          semanticLabel: 'Ganya calf sleeping on the ground.',
        ),
      ],
      correctFeedback: [
        NarrationLine(
          displayText: "शाब्बास! छतावर चिऊताई बसली आहे!",
          semanticDescription: "NOVA smiles.",
          segments: [NarrationSegment(text: "शाब्बास! अगदी बरोबर!", languageTag: "mr-IN")],
        ),
      ],
      retryFeedback: [
        NarrationLine(
          displayText: "छान प्रयत्न! छताकडे पुन्हा एकदा बघूया.",
          semanticDescription: "NOVA is encouraging.",
          segments: [NarrationSegment(text: "छान प्रयत्न! पुन्हा एकदा बघूया.", languageTag: "mr-IN")],
        ),
      ],
    ),
    LessonQuestion(
      id: 'q4_greeting',
      subject: 'English',
      prompt: NarrationLine(
        displayText: "सकाळी उठल्यावर आपण काय म्हणतो?",
        semanticDescription: "What do we say when we wake up in the morning?",
        segments: [NarrationSegment(text: "सकाळी उठल्यावर आपण काय म्हणतो?", languageTag: "mr-IN")],
      ),
      type: QuestionType.tapOrVoice,
      correctOptionId: 'good_morning',
      options: [
        QuestionOption(
          id: 'good_morning',
          label: 'Good Morning ☀️',
          sublabel: 'सकाळचे अभिवादन',
          visualKey: 'sun_morning',
          semanticLabel: 'Good Morning. Rising sun.',
          spokenAliases: ['good morning', 'gud morning', 'गुड मॉर्निंग'],
        ),
        QuestionOption(
          id: 'good_night',
          label: 'Good Night 🌙',
          sublabel: 'रात्रीचे अभिवादन',
          visualKey: 'moon_night',
          semanticLabel: 'Good Night. Moon and night sky.',
          spokenAliases: ['good night', 'gud night', 'गुड नाईट'],
        ),
      ],
      correctFeedback: [
        NarrationLine(
          displayText: "शाब्बास! Good Morning! ⭐",
          semanticDescription: "NOVA celebrates.",
          segments: [
            NarrationSegment(text: "शाब्बास!", languageTag: "mr-IN"),
            NarrationSegment(text: "Good Morning!", languageTag: "en-IN"),
          ],
        ),
      ],
      retryFeedback: [
        NarrationLine(
          displayText: "छान प्रयत्न! सूर्य उगवल्यावर आपण काय म्हणतो विचार करा.",
          semanticDescription: "NOVA is encouraging.",
          segments: [NarrationSegment(text: "छान प्रयत्न! पुन्हा एकदा बघूया.", languageTag: "mr-IN")],
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
        displayText: "Good Morning — सकाळी अभिवादन",
        semanticDescription: "Good Morning greeting",
        segments: [],
      ),
      NarrationLine(
        displayText: "Top / वर — छतावर चिऊताई",
        semanticDescription: "Top concept with sparrow on roof",
        segments: [],
      ),
      NarrationLine(
        displayText: "Bottom / खाली — जमिनीवर वासरू",
        semanticDescription: "Bottom concept with calf on ground",
        segments: [],
      ),
      NarrationLine(
        displayText: "Big / मोठा — मोठा ट्रॅक्टर",
        semanticDescription: "Big concept with large tractor",
        segments: [],
      ),
      NarrationLine(
        displayText: "Small / छोटी — छोटी बादली",
        semanticDescription: "Small concept with small bucket",
        segments: [],
      ),
    ],
  ),
);
