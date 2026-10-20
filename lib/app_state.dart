import 'package:flutter/material.dart';

/// ---------- Models ----------

class PlannerTask {
  PlannerTask({
    required this.id,
    required this.title,
    required this.time,
    required this.color,
    this.isDone = false,
  });

  final String id;
  String title;
  String time;
  final Color color;
  bool isDone;
}

class AppNotification {
  AppNotification({
    required this.id,
    required this.category, // Reminders, Courses, System
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.icon,
    required this.iconColor,
    this.isRead = false,
  });

  final String id;
  final String category;
  final String title;
  final String body;
  final String timeAgo;
  final IconData icon;
  final Color iconColor;
  bool isRead;
}

enum BookmarkType { course, note, quiz }

class BookmarkItem {
  BookmarkItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.tag,
  });

  final String id;
  final BookmarkType type;
  final String title;
  final String subtitle;
  final String tag;
}

class CourseResult {
  CourseResult({
    required this.title,
    required this.author,
    required this.rating,
    required this.lessons,
    required this.gradientColors,
    required this.description,
    required this.lessonSections,
  });

  final String title;
  final String author;
  final double rating;
  final int lessons;
  final List<Color> gradientColors;
  final String description;
  final List<LessonSection> lessonSections;
}

class LessonSection {
  const LessonSection({
    required this.title,
    required this.body,
    required this.keyTakeaway,
    required this.practicePrompt,
  });

  final String title;
  final String body;
  final String keyTakeaway;
  final String practicePrompt;
}

/// ---------- Global App State ----------

class AppState extends ChangeNotifier {
  // ----- Auth (mocked) -----
  String userName = '';
  String userEmail = '';
  bool isLoggedIn = false;

  void login(String email) {
    userEmail = email.trim();
    userName = _nameFromEmail(userEmail);
    isLoggedIn = true;
    notifyListeners();
  }

  String _nameFromEmail(String email) {
    final localPart =
        email.split('@').first.replaceAll(RegExp(r'[._-]+'), ' ').trim();
    if (localPart.isEmpty) return 'Learner';
    return localPart
        .split(RegExp(r'\s+'))
        .map((word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
  }

  void signUp(String name, String email) {
    userName = name;
    userEmail = email;
    isLoggedIn = true;
    notifyListeners();
  }

  void updateProfile({required String name, required String email}) {
    userName = name;
    userEmail = email;
    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    notifyListeners();
  }

  // ----- Appearance / Settings -----
  bool isDarkMode = false;
  double fontScale =
      0.5; // 0.0 (small) - 1.0 (large) -> maps to textScaleFactor
  String language = 'English';
  bool pushNotifications = true;
  bool emailUpdates = false;
  bool studyReminders = true;

  void toggleDarkMode(bool value) {
    isDarkMode = value;
    notifyListeners();
  }

  void setFontScale(double value) {
    fontScale = value;
    notifyListeners();
  }

  void setLanguage(String value) {
    language = value;
    notifyListeners();
  }

  String text(String key) {
    const translations = {
      'English': {
        'welcome': 'Welcome back,',
        'schedule': "Today's Schedule",
        'recommended': 'Recommended For You',
        'settings': 'Settings',
        'language': 'Language'
      },
      'Filipino': {
        'welcome': 'Maligayang pagbabalik,',
        'schedule': 'Iskedyul Ngayon',
        'recommended': 'Inirerekomenda Para sa Iyo',
        'settings': 'Mga Setting',
        'language': 'Wika'
      },
      'Spanish': {
        'welcome': 'Bienvenido de nuevo,',
        'schedule': 'Horario de hoy',
        'recommended': 'Recomendado para ti',
        'settings': 'Configuración',
        'language': 'Idioma'
      },
      'French': {
        'welcome': 'Bon retour,',
        'schedule': "Programme d'aujourd'hui",
        'recommended': 'Recommandé pour vous',
        'settings': 'Paramètres',
        'language': 'Langue'
      },
      'Japanese': {
        'welcome': 'おかえりなさい、',
        'schedule': '今日の予定',
        'recommended': 'おすすめ',
        'settings': '設定',
        'language': '言語'
      },
      'Korean': {
        'welcome': '다시 오신 것을 환영합니다,',
        'schedule': '오늘의 일정',
        'recommended': '추천 학습',
        'settings': '설정',
        'language': '언어'
      },
    };
    return translations[language]?[key] ?? translations['English']![key] ?? key;
  }

  void togglePushNotifications(bool value) {
    pushNotifications = value;
    notifyListeners();
  }

  void toggleEmailUpdates(bool value) {
    emailUpdates = value;
    notifyListeners();
  }

  void toggleStudyReminders(bool value) {
    studyReminders = value;
    notifyListeners();
  }

  double get textScaleFactor => 0.85 + (fontScale * 0.4); // 0.85x - 1.25x

  // ----- Search -----
  final List<String> recentSearches = [
    'Calculus',
    'Gravity',
    'Richard Dawkins',
    'DNA Structure'
  ];

  final List<Map<String, String>> trendingTopics = [
    {'title': 'Quantum Physics', 'subject': 'Science'},
    {'title': 'Linear Algebra', 'subject': 'Math'},
    {'title': 'French Vocabulary', 'subject': 'Language'},
  ];

  final List<CourseResult> allCourses = [
    CourseResult(
      title: 'Art Appreciation: Seeing Art',
      author: 'LearnWise Arts Team',
      rating: 5.0,
      lessons: 4,
      gradientColors: const [Color(0xFFB84A62), Color(0xFFF0A35B)],
      description:
          'Learn how to look at art with curiosity and confidence. This beginner-friendly course explains the basic ideas artists use to communicate.',
      lessonSections: const [
        LessonSection(
          title: 'What is art appreciation?',
          body:
              '## Introduction: Learning to see art\nArt appreciation is the practice of looking closely at an artwork, noticing how it is made, and thinking about what it might communicate. Art can include painting, drawing, sculpture, photography, architecture, craft, performance, and digital work. Each form uses materials and visual choices in different ways, but all can invite observation and interpretation.\n\nAppreciation is not a test with one secret answer, and you do not need to be an artist or know specialist vocabulary. Curiosity, comfort, confusion, or excitement are all useful first responses. Instead of stopping at “I like it” or “I do not like it,” ask which details led to that reaction.\n\n## Observation and response\nNotice the subject, colors, shapes, lines, textures, materials, size, and arrangement. Separate what you can directly see from what you think it might mean. For example, “a small figure stands beneath a large dark sky” is an observation; “the figure feels lonely” is an interpretation that you can support with the scale, color, and surrounding space.\n\nArt can communicate ideas, emotions, beliefs, memories, identity, or questions. Artists may plan these choices carefully, but viewers also bring their own experiences. A useful interpretation is not necessarily the only possible interpretation; it is one that considers the artwork and explains its evidence.\n\n## Why art appreciation matters\nLooking carefully can reveal how images shape memory, culture, and everyday life. It helps us recognize artistic decisions, understand perspectives beyond our own, and explain our responses more clearly. The goal is not to memorize a single meaning, but to build a thoughtful conversation between the artwork and the viewer.',
          keyTakeaway:
              'Appreciating art means observing carefully and supporting your interpretation with details you can point to.',
          practicePrompt:
              'Look at one artwork for a minute. Write down one thing you notice, one feeling it gives you, and the visual detail that may have caused that feeling.',
        ),
        LessonSection(
          title: 'Look before you judge',
          body:
              '## Start with observation\nBefore deciding what an artwork means or whether you like it, pause and describe what is actually present. Identify the subject, setting, people or objects, materials, and visible actions. Then notice the visual details: line, shape, color, light and dark, texture, space, scale, and placement. Begin with the whole work before examining one small area.\n\nObservation uses neutral, specific language. “There are three figures near the left edge” describes what can be seen. “They are escaping” suggests a story that may or may not be supported. Keeping these statements separate makes your later interpretation more careful.\n\n## Look at how the parts work\nAsk where your eyes go first, what leads them there, and what you notice next. Repeated shapes can create rhythm; strong contrast can draw attention; a large area of empty space can make a subject seem isolated. Look for relationships rather than listing details without connection. A color may matter because it is repeated, unusually bright, or different from its surroundings.\n\n## Delay your conclusion\nLabels, titles, and background information can be helpful, but read them after spending time looking when possible. An early guess can make us ignore details that do not fit it. Keep questions open: What do I notice? What evidence supports my idea? What else could explain this detail? Careful looking does not remove personal response; it gives that response a stronger foundation.',
          keyTakeaway:
              'Describe what you can see first; interpret what it might mean after you have noticed the evidence.',
          practicePrompt:
              'Choose three visible details in an artwork. Describe each without using words such as beautiful, strange, or sad.',
        ),
        LessonSection(
          title: 'A simple way to respond',
          body:
              '## Four steps for a thoughtful response\nA clear response moves from what you see toward what you think and feel. The steps can overlap, but using them in order helps keep your ideas grounded.\n\n1. **Describe:** Name the subject and visible details without judging them. What objects, people, colors, lines, or materials are present?\n2. **Analyze:** Explain how the parts work together. Where is the focal point? How do contrast, repetition, scale, or empty space guide your attention?\n3. **Interpret:** Suggest what the choices might communicate. Could the work express an idea, memory, mood, belief, or question? Consider more than one possibility.\n4. **Evaluate:** Explain what you find effective, meaningful, or challenging and why. Your evaluation should refer to details, not only preference.\n\n## Connect evidence to meaning\nAn interpretation is stronger when it points to something visible. Instead of saying “the artwork is sad,” explain that muted colors, a small isolated figure, and a large empty background create a quiet or lonely mood. Another viewer may read those same choices differently; compare interpretations by asking what evidence supports each one.\n\nDo not treat the steps as a formula that forces one answer. A new observation or historical fact can change an interpretation. A thoughtful response shows how you reached an idea and remains open to details that complicate it.',
          keyTakeaway:
              'Describe, analyze, interpret, and evaluate—using specific visual evidence to connect each step.',
          practicePrompt:
              'Write four short sentences about one artwork: what you see, how it is arranged, what it could mean, and how you respond.',
        ),
        LessonSection(
          title: 'Try it yourself',
          body:
              '## Practice a complete art response\nChoose an artwork you can revisit: a painting in a book, a sculpture in a public place, a photograph, or an image from a museum collection. Spend a minute looking before reading its label. Write down three things you can see, then choose one detail that attracts your attention.\n\nUse the four steps. Describe the subject and details. Analyze how the artist uses color, line, shape, texture, space, or composition. Offer one possible interpretation and point to evidence that supports it. Finally, explain your response: what feels interesting, powerful, confusing, or familiar to you?\n\n## Check and revise your interpretation\nIf you later learn the artist, date, place, or purpose, compare that context with your first reading. You do not have to discard your personal response. Explain what the new information adds, changes, or leaves unanswered. If another viewer disagrees, ask what they noticed and compare the evidence rather than looking for a single winner.\n\nA useful art response is specific, curious, and willing to grow as you learn.',
          keyTakeaway:
              'A strong response combines close observation, a reasoned interpretation, and openness to new context.',
          practicePrompt:
              'Give a one-minute response to an artwork: name a detail, explain its effect, suggest a meaning, and ask one question.',
        ),
      ],
    ),
    CourseResult(
      title: 'Art Appreciation: Elements',
      author: 'LearnWise Arts Team',
      rating: 4.8,
      lessons: 5,
      gradientColors: const [Color(0xFF367C8B), Color(0xFF70B7A4)],
      description:
          'Explore line, color, shape, texture, space, and form, then see how artists combine them to guide attention and create meaning.',
      lessonSections: const [
        LessonSection(
          title: 'The Building Blocks of Art',
          body:
              'Understanding the seven elements artists use to create meaning, express emotions, and communicate ideas.\n\n## Introduction: What are the elements of art?\nArt is a form of visual communication. Artists use images, lines, colors, shapes, and other visual features to express thoughts, emotions, experiences, and ideas. In a painting, drawing, sculpture, photograph, or digital artwork, different visual parts work together to create a complete composition.\n\nThese basic visual parts are called the elements of art: line, shape, form, color, value, texture, and space. Understanding these elements helps us recognize how an artwork is made, why it looks a certain way, and what the artist may be trying to communicate. Art appreciation is more than deciding whether an artwork is beautiful. It also means observing carefully, understanding artistic choices, interpreting meaning, and explaining how visual details affect our experience.\n\n## 1. Line — The path of a moving point\nA line is a mark that connects points or creates a path for the viewer’s eye. Lines can be straight, curved, thick, thin, horizontal, vertical, diagonal, broken, or zigzag. Artists use them to outline objects, divide areas, create patterns, suggest movement, and express emotions.\n\nDifferent lines can create different impressions. Horizontal lines often suggest calmness, stability, and rest, like a horizon. Vertical lines can suggest strength, height, dignity, or stability, as with tall buildings or trees. Diagonal lines often create movement, energy, tension, or action. Curved lines may suggest softness, grace, flow, or natural movement. Zigzag lines can communicate excitement, confusion, danger, or nervous energy. Thick, dark lines may emphasize an object, while thin, delicate lines can feel light or subtle.\n\nA peaceful landscape might use long horizontal lines to emphasize the horizon, while an action scene might use sharp diagonals to feel energetic. Lines may also be implied rather than physically drawn: a person’s gaze or the arrangement of objects can guide our eyes across an artwork.\n\n**Why it matters:** Line helps define objects, establish structure, direct attention, and communicate mood.\n\n## 2. Shape — The enclosed area\nA shape is a flat, two-dimensional enclosed area. Shapes have height and width but no actual physical depth. They are often created by outlines, contrasting colors, or boundaries between light and dark areas.\n\nGeometric shapes include circles, squares, rectangles, triangles, and other regular forms. They often appear organized, structured, balanced, or precise. Organic shapes are irregular and inspired by nature, such as leaves, clouds, flowers, rocks, or the human body; they can appear natural, free-flowing, or unpredictable.\n\nArtists use shapes to simplify complicated subjects, arrange objects, create patterns, and establish an artwork’s structure. A portrait, for example, can be understood through the shapes of the face, hair, clothing, and background. A circle may suggest unity or wholeness, while sharp triangular shapes may suggest tension or direction, depending on the context.\n\n**Why it matters:** Shape helps viewers recognize objects, understand composition, and notice how an artwork is organized.\n\n## 3. Form — The illusion or reality of three dimensions\nForm refers to an object’s three-dimensional structure, including height, width, and depth. A sculpture has actual physical form because it occupies space. A drawing or painting can create the illusion of form through shading, perspective, highlights, and shadows.\n\nGeometric forms include spheres, cubes, cylinders, cones, and pyramids. Organic forms include the irregular three-dimensional shapes of plants, animals, rocks, and the human body. A circle drawn on paper is a flat shape; when an artist adds shading and highlights to make it look rounded, it may appear to be a sphere. In sculpture, artists work directly with volume and physical structure, and the form may look different from different viewing angles.\n\n**Why it matters:** Form makes objects appear solid, gives artworks a sense of depth, and helps viewers understand the physical structure of subjects.\n\n## 4. Color — Creating mood, meaning, and emphasis\nColor is associated with the way we perceive light at different wavelengths. It can attract attention, distinguish objects, establish harmony, and influence the mood of a composition. Hue is the color family, such as red, blue, yellow, green, or violet. Saturation is a color’s intensity: highly saturated colors are vivid, while less saturated colors appear muted. Color value describes how light or dark a color appears.\n\nIn traditional paint-based color theory, red, yellow, and blue are primary colors; orange, green, and violet are secondary colors traditionally made by mixing pairs of primary colors. Warm colors such as reds, oranges, and yellows can suggest warmth, excitement, energy, or intensity. Cool colors such as blues, greens, and violets can suggest calmness, distance, quietness, or sadness. Complementary colors sit opposite one another on a color wheel and can create strong contrast; analogous colors sit next to one another and can create unity.\n\nColor can carry cultural or personal associations. Red may suggest love, celebration, anger, or danger depending on context. Blue may suggest peace or sadness, while green may evoke nature, growth, or renewal. These are not universal rules.\n\n**Why it matters:** Color helps establish mood, create harmony or contrast, communicate symbolism, and draw attention to important parts of an artwork.\n\n## 5. Value — The lightness or darkness of a color\nValue is how light or dark a color is. It is easy to study in black-and-white artworks, where values range from white through gray to black, but value is also present in colored artworks. Artists use value to create contrast, show the direction of light, make objects look three-dimensional, and establish atmosphere.\n\nA highlight is a particularly light area where light strongly illuminates an object. A midtone is an area of intermediate value. A shadow is darker where light is limited or blocked, and a cast shadow falls on a surface when an object blocks light. Strong differences between light and dark create high contrast and can feel dramatic; smaller differences create lower contrast and may feel softer or quieter.\n\nAn artist can use light values on a face’s forehead and cheeks and darker values under the nose, chin, and jaw to suggest volume. In a landscape, a range of values can distinguish foreground objects from distant scenery. A bright object against a dark background often stands out immediately.\n\n**Why it matters:** Value creates depth, defines form, establishes contrast, and communicates mood even when color is absent.\n\n## 6. Texture — How a surface looks or feels\nTexture refers to a surface’s quality: how something feels when touched or how an artist makes it appear to feel. Actual texture is a real physical surface, such as rough wood, soft fabric, raised paint, or a smooth sculpture. Implied texture is a visual representation that makes a flat image appear rough, smooth, soft, hard, shiny, or fuzzy.\n\nArtists create texture with different techniques and materials. Brushstrokes, layers of paint, and repeated marks can suggest surfaces. Closely spaced lines or dots can represent fur, stone, skin, or fabric. Photographers can capture tiny surface details, while sculptors can carve, polish, or roughen a material. Rough marks might represent tree bark while smoother marks suggest leaves. Rough surfaces may suggest age or ruggedness, while smooth surfaces may suggest calmness or refinement; context matters.\n\n**Why it matters:** Texture adds sensory interest, distinguishes materials, and can make artworks feel realistic, expressive, or visually engaging.\n\n## 7. Space — The area around, within, and between objects\nSpace is the area within, around, between, and beyond objects. It organizes a composition, creates a sense of distance, and affects whether an image feels crowded or open. Positive space is occupied by the main subjects or objects; negative space is the empty or less occupied area around and between them. The foreground appears closest to the viewer, the middle ground lies between, and the background appears farthest away.\n\nPerspective and overlapping can create the illusion of depth on a flat surface. In a landscape, a large tree in the foreground, smaller buildings in the middle ground, and distant mountains in the background can suggest distance. Overlapping objects often appear to sit in front of one another.\n\nNegative space is equally important. Large empty areas around one subject can create loneliness, peace, simplicity, or emphasis. A composition filled with many objects may feel busy, crowded, or energetic. Space is not merely empty; it actively shapes the relationship between subjects and viewers.\n\n**Why it matters:** Space creates depth, organizes objects, establishes balance, and influences how viewers experience an artwork.\n\n## How the seven elements work together\nThe elements rarely work independently. Imagine a painting of a sunset over the sea: horizontal lines can suggest a calm horizon, organic shapes can represent clouds, and form can give boats and rocks volume. Warm orange and red can communicate sunset light, while darker values create contrast. Textured brushstrokes can suggest waves, and foreground and background placement can create depth. We experience all these choices together as one artwork.\n\nIn a portrait, lines may define facial features, shapes establish the arrangement of the face, and form creates rounded cheeks and a nose. Color communicates skin tones and mood, value creates shadows, texture suggests hair and fabric, and space positions the subject in the composition. Ask not only which elements are present, but how the artist uses them and what effect they create.\n\n## Elements of art and principles of design\nThe elements of art are the basic visual ingredients of an artwork. Principles of design describe how artists organize and use those ingredients. Color is an element; color harmony and contrast are ways colors can be organized. Line is an element; rhythm and movement can result from how lines are repeated or arranged. Space is an element; balance can be created through the placement of positive and negative space. Common design principles include balance, contrast, emphasis, movement, pattern, rhythm, unity, and variety. This distinction helps you move from identifying details to explaining how an artwork is constructed.\n\n## How to analyze an artwork using the seven elements\n1. **Observe:** Identify the main subject and describe what you see without immediately judging it.\n2. **Identify:** Look for examples of line, shape, form, color, value, texture, and space.\n3. **Describe:** Explain specific features, such as curved lines, geometric shapes, warm colors, strong contrast, rough textures, or deep space.\n4. **Interpret:** Consider how these choices influence the mood, focus, atmosphere, or possible meaning.\n5. **Support your interpretation:** Use visible details rather than relying only on personal opinion.\n6. **Reflect:** Consider how the elements work together and influence your overall experience.\n\nInstead of saying, “The painting looks sad,” you might explain, “The painting creates a sad atmosphere through its cool, muted colors, dark values, and the large empty space surrounding the figure.” This uses visual evidence to support an interpretation.\n\n## Key idea\nThe seven elements—line, shape, form, color, value, texture, and space—are the visual building blocks of an artwork. Recognizing them helps you understand artistic techniques, interpret meaning, and explain why an artwork creates a particular effect.\n\n## Try it yourself\nChoose a painting, photograph, drawing, or sculpture you can observe. Identify at least four of the seven elements. Describe where each appears, how the artist uses it, and what it contributes to the artwork’s appearance or meaning. Try completing this sentence: “The artist uses _____ to create _____ because _____.”',
          keyTakeaway:
              'The elements—line, shape, form, color, value, texture, and space—are the visual ingredients of an artwork.',
          practicePrompt:
              'Find one example of line, shape, color, and texture in an artwork. Describe what each contributes.',
        ),
        LessonSection(
          title: 'Line and shape',
          body:
              'Lines guide the viewer’s eye, while shapes organize visual information and help artists communicate ideas.\n\n## Introduction: How line and shape build an artwork\nLine and shape are two of the most fundamental elements of art. They help artists organize images, define objects, communicate movement, and create visual interest. Even a simple drawing made with only a few lines and shapes can express an idea or tell a story.\n\nA line can outline an object, divide a composition, suggest direction, or lead the viewer’s attention toward an important subject. Shape defines enclosed areas and helps us recognize objects, patterns, and relationships within an image. Although they are closely related, line emphasizes direction and boundaries, while shape emphasizes enclosed areas.\n\nUnderstanding line and shape allows you to explain not only what appears in an artwork but also how the artist directs your attention and creates a particular visual effect.\n\n## 1. Line: Direction, movement, and expression\nA line is a mark or path that can vary in length, thickness, direction, and character. Artists use lines in drawing, painting, printmaking, sculpture, graphic design, and many other forms of visual art.\n\nDifferent lines can produce different effects:\n- Horizontal lines extend from side to side and may suggest calmness, stability, rest, or distance. They frequently appear in horizons and architectural designs.\n- Vertical lines move up and down and can suggest height, strength, dignity, or order. Tall trees and buildings are common examples.\n- Diagonal lines move at an angle and often create movement, instability, excitement, or tension.\n- Curved lines bend or flow and may suggest softness, grace, flexibility, or natural movement.\n- Zigzag lines change direction sharply and can communicate energy, confusion, danger, or excitement.\n- Broken lines contain gaps and may create a fragmented, interrupted, or rough appearance.\n- Thick and thin lines can establish emphasis, create visual hierarchy, or distinguish foreground objects from background details.\n\nLines may also be expressive. Loose, flowing lines can communicate spontaneity, while controlled, precise lines may produce a more structured appearance. Artists do not always draw every boundary explicitly. An implied line can form when several objects align, when a person looks toward something, or when the viewer mentally connects separate marks.\n\n## 2. Shape: Geometric and organic forms\nA shape is a two-dimensional enclosed area with height and width. Shapes may be defined by outlines, differences in color, changes in value, or the boundaries between an object and its surroundings.\n\nGeometric shapes have recognizable, often regular structures. Circles, squares, rectangles, triangles, and polygons are examples. They are frequently used in architecture, symbols, patterns, and designs that emphasize order and structure.\n\nOrganic shapes are irregular or free-flowing and are often inspired by nature. Leaves, clouds, flowers, rocks, and the silhouettes of animals are examples. Organic shapes can make an artwork appear natural, relaxed, or unpredictable.\n\nArtists may simplify complex subjects into basic shapes before adding details. For example, a human figure can initially be organized using circles, ovals, rectangles, and other simple forms. This helps artists establish proportions and arrange the composition. Shapes can also be symbolic. A heart shape may communicate affection, while a triangle may suggest direction or stability depending on its orientation and context. Meaning depends on the artwork rather than on a fixed rule for every shape.\n\n## 3. How lines and shapes work together\nLines and shapes frequently depend on one another. Lines can form the outlines of shapes, while the arrangement of shapes can create imaginary lines that guide the viewer’s eye.\n\nIn a landscape drawing, horizontal lines may establish the horizon, curved lines may describe clouds, and irregular shapes may represent mountains and trees. In a poster, strong diagonal lines and large geometric shapes may direct attention toward a title or central image.\n\nRepetition is another important technique. Repeating lines or shapes can establish pattern and rhythm. A series of vertical lines may suggest order, while repeated curved shapes may produce a flowing visual effect. The size and placement of shapes also affect the composition. One large shape can dominate the image, while many smaller shapes can create detail, complexity, or activity. Empty areas between shapes matter too: they help separate objects and allow the composition to breathe.\n\n## 4. Line, shape, and visual emphasis\nArtists use line and shape to establish a focal point—the area that attracts the viewer’s attention most strongly. A thick, dark outline around a bright object may make that object stand out. A group of diagonal lines may lead the viewer toward a central figure. A large shape surrounded by smaller shapes may become the main focus because of its size and position.\n\nEmphasis does not always come from making something larger or darker. An object may attract attention because it is isolated, differently shaped, or surrounded by empty space. When analyzing an artwork, consider which lines and shapes you notice first, where they lead your eyes, and whether they make the composition feel calm, energetic, balanced, or tense.\n\n## 5. How to analyze line and shape\nFollow these steps when studying an artwork:\n1. Identify the main lines and shapes.\n2. Describe the lines’ direction, thickness, and character.\n3. Determine whether the shapes are geometric, organic, or a combination of both.\n4. Observe how lines and shapes are arranged and repeated.\n5. Notice where your eyes move as you look at the artwork.\n6. Explain how the artist’s choices affect the mood, emphasis, and overall composition.\n\nInstead of saying, “The drawing looks energetic,” explain: “The artist uses sharp diagonal lines, irregular shapes, and repeated angular marks to create a strong sense of movement.” This approach connects your interpretation to visible evidence in the artwork.\n\n## Key idea\nLine and shape organize an image and guide the viewer’s attention. Lines can suggest movement and emotion, while shapes establish boundaries, structure, and visual patterns.\n\n## Try it yourself\nChoose a painting, photograph, or drawing. Identify at least three different types of lines and two shapes. Trace the main directions your eyes follow through the composition. Explain which lines or shapes attract your attention and why.',
          keyTakeaway:
              'Line and shape organize an image and guide attention. Lines suggest movement and emotion, while shapes establish boundaries, structure, and visual patterns.',
          practicePrompt:
              'Identify at least three types of lines and two shapes in an artwork. Trace where your eyes move and explain which details attract your attention.',
        ),
        LessonSection(
          title: 'Color and value',
          body:
              'Learn how colors communicate mood and meaning, and how differences between light and dark create contrast, depth, and emphasis.\n\n## Introduction: Seeing beyond color\nColor is one of the first things people often notice in an artwork. It can attract attention, distinguish objects, establish visual harmony, and influence how a scene is experienced. Value, the lightness or darkness of a color, helps define shapes, create the appearance of light, and establish contrast.\n\nColor and value are closely related, but they are not the same. Color describes properties such as hue and saturation, while value focuses on how light or dark something appears. An artwork may use many different hues but have similar values, or it may use only a few colors with strong light-dark differences.\n\nUnderstanding these elements helps you explain why certain parts of an artwork stand out, how the artist creates a particular atmosphere, and how light affects what you see.\n\n## 1. Hue: Identifying a color\nHue is the name or color family we recognize, such as red, orange, yellow, green, blue, or violet. In traditional paint-based color theory, red, yellow, and blue are commonly taught as primary colors. Mixing pairs produces the traditional secondary colors: orange, green, and violet. Modern color systems, such as digital displays and printing, use different primary-color models.\n\nArtists select hues based on their subject, intention, and the relationships between colors. A landscape might use greens and blues to depict vegetation and water, while a portrait might use a carefully selected range of skin tones. Hue can help distinguish objects, create a recognizable visual identity, and establish relationships between different areas of an image.\n\n## 2. Saturation: Vivid or muted colors\nSaturation describes the intensity or purity of a color. Highly saturated colors appear vivid and strong, while less saturated colors appear muted, subdued, or closer to gray.\n\nArtists can use saturation to establish visual hierarchy. A bright, saturated object against a muted background may become the focal point. A composition made mostly of muted colors may feel subtle or restrained, while a highly saturated palette can create a bold and lively appearance. In some landscapes, distant objects appear less distinct and less saturated than nearby objects, although the effect depends on lighting and environmental conditions.\n\n## 3. Warm and cool colors\nColors are often grouped according to their associations with warmth or coolness. Warm colors, including reds, oranges, and yellows, may suggest fire, sunlight, excitement, energy, or intensity. Cool colors, including blues, greens, and many violets, may suggest water, shade, quietness, distance, or calm.\n\nThese associations can influence how an artwork feels, but they are not universal. A red scene may communicate danger, celebration, love, or anger, depending on the subject and context. Blue may feel peaceful in one painting and lonely in another. Artists can combine warm and cool colors to create contrast, separate objects, or direct attention. A warm-colored subject against a cool background may stand out because of the visual difference.\n\n## 4. Color relationships and harmony\nColors interact with one another, so their effects depend partly on surrounding colors.\n- Complementary colors are opposite one another on a color wheel and can create strong contrast.\n- Analogous colors are next to one another on a color wheel and can produce a more unified appearance.\n- Monochromatic color schemes use variations of one hue, often changing its lightness and saturation.\n- Contrasting color schemes combine colors that differ noticeably in hue, saturation, or value.\n\nA painting dominated by neighboring blues and greens may feel visually unified. A poster combining complementary colors may feel striking and attention-grabbing. Color harmony does not mean every color must be similar. Artists can achieve unity through carefully controlled differences, repetition, and the relative amounts of each color.\n\n## 5. Value: Understanding light and dark\nValue describes the relative lightness or darkness of a color. White is generally at the light end of a grayscale range, while black is at the dark end. Artists use different values to describe illumination, create contrast, and make objects appear three-dimensional. Value is important even in colorful paintings because it helps viewers distinguish forms and understand which areas are illuminated or in shadow.\n\nCommon value terms include:\n- Highlights: the lightest areas, often where light strikes a surface most directly.\n- Midtones: values between the lightest highlights and darkest shadows.\n- Shadows: darker areas where illumination is reduced or blocked.\n- Cast shadows: shadows an object creates on another surface by blocking light.\n\nImagine a drawing of a sphere. A flat circle may appear two-dimensional. When the artist adds highlights, gradual midtones, and shadows, the circle can appear rounded and solid. Value also establishes atmosphere. A scene with many light values may feel bright or airy, while one dominated by dark values may feel mysterious, solemn, or dramatic. The subject and context determine the interpretation.\n\n## 6. Contrast, emphasis, and mood\nContrast refers to noticeable differences between visual elements. In color and value, contrast may occur between light and dark areas, warm and cool colors, or vivid and muted hues. High value contrast occurs when very light areas appear near very dark ones; it can make a subject stand out and create a dramatic effect. Low value contrast uses more similar light and dark values, often creating a softer or more unified appearance.\n\nArtists use contrast to establish emphasis. A bright object against a dark background may immediately attract attention, while a single saturated color within a muted composition may become the focal point. Color and value also influence mood together. Dark values and muted colors may suggest sadness or tension, while bright values and vivid colors may suggest excitement or celebration. These are possibilities rather than fixed meanings. Consider the subject, surrounding elements, and the artist’s overall choices rather than assigning one emotion to a particular color.\n\n## 7. How color and value work together\nColor and value frequently reinforce each other. A bright yellow object may attract attention because of its hue, but it will stand out even more if it has a much lighter value than the surrounding background. An artist can use different hues with similar values to create a harmonious composition without strong light-dark contrast. Conversely, an artwork made with a limited palette can still look dramatic when the values vary significantly.\n\nA sunset painting may contain warm orange and red hues, while dark foreground silhouettes contrast with the bright sky. The colors communicate the character of the sunset, and differences in value help establish depth and direct attention. In a portrait, subtle shifts in value can define facial features even when the artist uses a limited range of colors. This shows that value is an essential part of visual structure rather than simply another name for color.\n\n## 8. How to analyze color and value\nUse these questions when examining an artwork:\n1. Which hues are most noticeable?\n2. Are the colors warm, cool, vivid, muted, or a mixture?\n3. Where are the lightest and darkest areas?\n4. Is the value contrast strong or subtle?\n5. Which area attracts your attention first?\n6. How do the colors and values contribute to the atmosphere or meaning?\n7. How do the colors relate to the subject matter and the other elements?\n\nRather than simply saying, “The painting feels dramatic because it uses red,” explain: “The painting creates a dramatic effect through saturated red hues, deep shadows, and a bright focal area that contrasts strongly with its surroundings.” This identifies visual evidence and explains its effect without assuming a particular color always communicates the same emotion.\n\n## Key idea\nColor and value help artists establish mood, create visual contrast, guide attention, and suggest depth. Interpret these elements in the context of the entire artwork rather than assigning fixed meanings to individual colors.\n\n## Try it yourself\nChoose an artwork and identify its most vivid color and strongest light-dark contrast. Describe where they appear, what they draw your attention toward, and how they affect the artwork’s mood. Then imagine replacing the vivid colors with muted ones. Explain how this might change the overall effect.',
          keyTakeaway:
              'Color and value establish mood, contrast, emphasis, and depth. Interpret them in the context of the entire artwork.',
          practicePrompt:
              'Identify the artwork’s most vivid color and strongest light-dark contrast. Explain what they emphasize and how they affect the mood.',
        ),
        LessonSection(
          title: 'Texture, form, and space',
          body: r'''## Introduction: Understanding Texture, Form, and Space
Texture, form, and space are three important elements of art that help artists show the appearance, shape, and arrangement of objects in an artwork. They help viewers understand what an object might feel like, how it appears to have volume, and how objects relate to one another and their surroundings.

Artists use these elements in paintings, drawings, sculptures, photographs, architecture, and digital art. Although some artworks are flat, artists can use different techniques to make objects appear rough, smooth, solid, close, far away, large, or small.

For example, in a painting of a wooden table beside a glass vase, the artist may use lines and colors to make the table look rough and the glass look smooth. Shading can make the vase appear round and solid, while the arrangement of the table and vase can show which object is closer to the viewer.

Understanding texture, form, and space helps us appreciate how artists create realistic appearances, organize their compositions, and communicate ideas and emotions.

## 1. Texture — How a Surface Looks or Feels
Texture refers to the surface quality of an object. It describes how something feels when touched or how it appears to feel when we look at it.

Some objects have rough surfaces, while others are smooth, soft, hard, shiny, or bumpy. Artists use texture to make their work more interesting, realistic, and expressive.

For example, a painting of a cat may use soft-looking brushstrokes to show its fur. A painting of an old wall may use rough marks and uneven colors to make the wall appear cracked and worn.

Texture is especially important because it helps viewers imagine the surface of an object, even when they cannot physically touch it.

### A. Actual Texture
Actual texture, also called physical texture, is the real surface quality of an artwork or object. It can be felt by touching the surface.

Actual texture is common in sculpture, pottery, weaving, and other artworks made from physical materials.

For example, a sculpture made from rough stone has an actual rough texture. A ceramic bowl with a smooth, polished surface has an actual smooth texture. A woven basket has a noticeable texture because of the way its materials are arranged.

Artists can create actual texture by carving wood, shaping clay, using thick paint, attaching different materials, or leaving surfaces unfinished.

### B. Implied Texture
Implied texture is when an artist creates the appearance of a surface without making the artwork physically feel that way. The texture is suggested through lines, colors, shading, patterns, and brushstrokes.

For example, a drawing of a furry dog may use many short lines to make its fur appear soft. A painting of a glass bottle may use bright highlights and smooth color changes to make the glass look shiny.

Although the drawing itself may have a flat surface, viewers can still imagine the texture of the objects shown.

Implied texture is commonly used in paintings, drawings, photographs, and digital illustrations because artists can suggest different surfaces without using actual materials from those objects.

### C. Types of Texture in Art
Artists can represent many kinds of texture depending on the subject.

- **Rough texture:** Used to show surfaces such as rocks, tree bark, old walls, and unpolished wood.
- **Smooth texture:** Used to represent glass, polished metal, ceramic, or a calm body of water.
- **Soft texture:** Used to show fur, feathers, cotton, blankets, or clouds.
- **Hard texture:** Used to represent stone, metal, concrete, or solid wooden objects.
- **Shiny texture:** Created through highlights and strong differences between light and dark areas to suggest reflective surfaces.
- **Bumpy or uneven texture:** Used to show objects such as tree bark, certain fabrics, and rough ground.
These textures can affect the mood of an artwork. Rough surfaces may suggest age, strength, or hardship, while smooth surfaces may suggest cleanliness, calmness, or elegance. However, the meaning depends on the subject and how the artist uses the texture.

### D. How Artists Create Texture
Artists use different methods to show texture in their work.

- **Lines and marks:** Short, repeated lines can represent fur, hair, grass, or wood grain.
- **Brushstrokes:** Thick or visible brushstrokes can create an expressive or rough appearance.
- **Shading:** Light and dark areas can make a surface appear smooth, rough, shiny, or uneven.
- **Patterns:** Repeated marks can suggest scales, fabric, bricks, or other surface details.
- **Materials:** Artists can use sand, fabric, paper, wood, clay, and other materials to create physical texture.
For example, an artist drawing a pineapple may use small repeated shapes and dark lines to show its rough outer skin. The artist may use smoother shading for the cut fruit to make the two surfaces look different.

**Why it matters:** Texture makes an artwork more detailed and expressive. It helps viewers imagine how objects feel and recognize differences between materials, even when the artwork is only a drawing or painting.

## 2. Form — The Three-Dimensional Appearance of an Object
Form refers to an object that has height, width, and depth. Unlike a flat shape, a three-dimensional form occupies space and has volume.

Form is important because it helps artists show objects as solid rather than flat. It can be seen directly in sculptures and other three-dimensional artworks. In drawings and paintings, artists can create the illusion of form through shading, highlights, overlapping parts, and changes in color.

For example, a circle is a flat shape, while a sphere is a three-dimensional form. A square is a shape, while a cube is a form. A drawing of an apple may begin with a simple rounded shape, but shading can make it look like a solid apple with volume.

### A. Geometric Forms
Geometric forms are three-dimensional forms based on regular mathematical shapes. They often have clear edges, organized structures, and predictable proportions.

Common geometric forms include:

- **Sphere:** A round form, like a ball or globe.
- **Cube:** A solid form with six square faces, like a dice.
- **Cylinder:** A form with circular ends and a curved side, like a can or drinking glass.
- **Cone:** A form with a circular base that narrows to a point, like an ice cream cone.
- **Pyramid:** A form with a base and triangular sides that meet at a point.
Geometric forms are often found in buildings, furniture, product design, and modern sculptures.

For example, an artist drawing a group of objects on a table may use a cylinder for a can, a cube for a box, and a sphere for an orange. Understanding these basic forms makes it easier to draw objects with correct volume and perspective.

### B. Organic Forms
Organic forms are irregular, natural-looking forms that are often inspired by living things and nature. They usually have curved, uneven, or flowing shapes rather than perfectly straight edges.

Examples include human bodies, animals, trees, flowers, rocks, and clouds.

For example, a sculpture of a human figure uses organic form because the body has curves and different volumes. A sculpture inspired by a tree root may have irregular shapes that do not follow strict geometric rules.

Organic forms are common in nature-inspired artworks because they can express movement, growth, freedom, and natural beauty.

### C. How Artists Create the Illusion of Form
In a flat artwork, artists can use several techniques to make objects appear three-dimensional.

**1. Shading**

Shading uses different levels of light and darkness to show the rounded or solid parts of an object. Darker areas often represent parts receiving less light, while lighter areas represent parts receiving more light.

For example, when drawing a sphere, an artist can use light shading on one side and darker shading on the opposite side. This makes the sphere appear round instead of flat.

**2. Highlights**

Highlights are the lightest areas of an object. They show where light hits a surface and can help an object look rounded, smooth, or shiny.

For example, a small bright area on a drawing of an apple can make its skin appear shiny and curved.

**3. Overlapping**

Overlapping happens when one object covers part of another object. It helps viewers understand which object is in front and which is behind.

For example, if one flower covers part of another flower in a painting, the viewer can recognize that the flowers are positioned at different depths.

**4. Changes in Color and Value**

Artists can use changes in color and value to show the different sides and surfaces of an object. Value refers to how light or dark a color is.

For example, a painter may use lighter green on the side of a leaf facing the light and darker green on the shaded side. This makes the leaf appear to have more volume.

**5. Light and Shadow**

Light and shadow help show the position, size, and volume of objects. A cast shadow is the shadow an object creates on another surface when light is blocked.

For example, a shaded area beneath a cup can make it appear to rest on a table instead of floating in the air.

**Why it matters:** Form helps viewers understand the volume and structure of objects. It allows artists to create realistic subjects, design believable spaces, and make drawings and paintings appear three-dimensional.

## 3. Space — The Area Within and Around Objects
Space refers to the area within, around, between, or behind objects in an artwork. It helps show where objects are located and how much room they occupy.

Space can make an artwork look crowded or open, shallow or deep, and organized or confusing. Artists use space to guide the viewer's attention, create distance, and establish relationships between subjects.

For example, in a painting of a house in a field, the house occupies part of the picture, while the sky, grass, and open areas around it create the surrounding space.

Space is especially important in drawing, painting, photography, sculpture, and architecture because it helps viewers understand the arrangement and distance of objects.

### A. Positive Space
Positive space is the area occupied by the main subjects or objects in an artwork. It includes the people, animals, buildings, furniture, or other forms that the artist wants viewers to notice.

For example, in a drawing of a vase with flowers, the vase and flowers are the positive space because they are the main objects being shown.

In a photograph of a person standing beside a tree, the person and tree occupy the positive space.

Positive space helps identify the main subjects and gives the artwork its visible content.

### B. Negative Space
Negative space is the area around, between, or inside the main subjects of an artwork. It is often described as the empty space, but it is not useless or unimportant.

Negative space helps separate objects, improve the overall arrangement, and make the main subjects stand out. It can also create a feeling of openness, loneliness, peace, or tension.

For example, in a drawing of a single bird on a branch, the empty sky surrounding the bird is negative space. A large amount of empty sky may make the bird look small or isolated.

In a poster, enough negative space around the title and images can make the design easier to read and understand.

Positive and negative space work together. If an artwork contains too many objects and very little negative space, it may look crowded. If it contains too much empty space, the main subject may appear isolated or the artwork may feel minimal and calm. Artists choose the amount of space based on the effect they want to create.

### C. Shallow Space and Deep Space
**Shallow space** is when an artwork appears to have little depth. Objects may seem close together or arranged near the surface of the image.

For example, a decorative painting may show flowers and leaves arranged across a flat background without much difference in apparent distance.

**Deep space** is when an artwork creates the appearance of objects extending far into the distance. Artists use techniques such as perspective, overlapping, and changes in size to create this effect.

For example, a painting of a road extending toward distant mountains creates deep space because the road and landscape appear to continue far beyond the foreground.

Shallow and deep space can create different effects. Shallow space may emphasize patterns, decoration, or the arrangement of shapes. Deep space can make a scene feel realistic, wide, or immersive.

### D. How Artists Create the Illusion of Depth
Artists can make a flat surface appear to have depth by using several techniques.

**1. Overlapping**

When one object covers part of another, the covered object usually appears farther away.

For example, if a tree covers part of a house in a landscape painting, the tree appears to be in front of the house.

**2. Size and Scale**

Objects that appear smaller often seem farther away, especially when they represent objects of similar real-world size.

For example, people near the front of a road may be drawn larger than people near the distant end of the road.

**3. Linear Perspective**

Linear perspective uses lines and the apparent change in size of objects to create the illusion of depth. Parallel lines may appear to move closer together as they extend into the distance, often meeting at a vanishing point.

For example, the two sides of a straight railway track appear to move closer together as they extend toward the horizon, even though the actual tracks remain parallel.

**4. Atmospheric Perspective**

Atmospheric perspective creates the appearance of distance by making faraway objects look lighter, less detailed, and sometimes bluer or less clear than nearby objects.

For example, in a landscape painting, nearby trees may appear dark green with visible details, while distant mountains appear pale blue and less detailed.

**5. Placement**

Objects placed lower in the picture may appear closer to the viewer, while objects placed higher may appear farther away, depending on the scene and viewpoint.

For example, in a landscape, flowers near the bottom of the image may appear to be in the foreground, while distant houses near the horizon may appear farther away.

These techniques help artists create believable depth even though the canvas or paper itself remains flat.

**Why it matters:** Space helps viewers understand the location, distance, and relationship of objects. It can make an artwork appear realistic, spacious, crowded, peaceful, or dramatic.

## 4. The Relationship Between Texture, Form, and Space
Texture, form, and space are different elements of art, but they often work together to make an artwork more understandable and expressive.

Texture shows how a surface looks or feels. Form shows the volume and three-dimensional appearance of an object. Space shows where objects are placed and how they relate to their surroundings.

For example, imagine a painting of a wooden chair in a room.

- **Texture:** The artist uses lines and marks to make the wood look rough and show its grain.
- **Form:** Shading gives the seat and legs a solid, three-dimensional appearance.
- **Space:** Overlapping, perspective, and shadows show the chair's position in the room and its distance from the wall.
When these elements work together, the chair looks more believable and fits naturally into the scene.

Artists can also use these elements in creative ways. A sculpture may have rough texture and unusual organic forms placed in an open area to create a feeling of nature or freedom. A painting may use smooth surfaces, simple forms, and limited space to create a clean, modern appearance.

## 5. How These Elements Affect the Mood of an Artwork
Texture, form, and space can influence how viewers feel when looking at an artwork.

- **Rough texture:** May suggest age, strength, hardship, or a natural surface.
- **Smooth texture:** May suggest calmness, cleanliness, elegance, or simplicity.
- **Solid form:** Can make an object feel strong, heavy, or realistic.
- **Rounded organic form:** May create a natural, soft, or flowing appearance.
- **Large negative space:** May suggest loneliness, freedom, openness, or peace.
- **Crowded space:** May suggest pressure, confusion, activity, or tension.
- **Deep space:** Can create a feeling of distance, openness, or being inside a scene.
- **Shallow space:** Can emphasize patterns, shapes, and decorative arrangements.
These meanings depend on the artwork. A rough surface may suggest strength in one artwork but damage or sadness in another. Viewers should consider the subject, colors, arrangement, and overall message before interpreting the artist's choices.

## 6. How to Analyze Texture, Form, and Space in an Artwork
When studying an artwork, ask yourself these questions:

1. **What kind of texture can I see?** Does the surface appear rough, smooth, soft, shiny, or uneven?
2. **Is the texture actual or implied?** Can the surface physically be felt, or is it only suggested visually?
3. **What forms are present?** Can you identify geometric forms, organic forms, or both?
4. **How does the artist show volume?** Look for shading, highlights, shadows, and changes in color.
5. **What is the positive space?** Identify the main subjects or objects in the artwork.
6. **What is the negative space?** Observe the areas around and between the subjects.
7. **Does the artwork appear flat or deep?** Look for overlapping, perspective, size differences, and changes in detail.
8. **How do these elements affect the mood?** Explain whether they create a peaceful, realistic, crowded, dramatic, or lonely feeling.
For example, when analyzing a painting of a tree beside a river, you may notice rough implied texture on the tree bark, rounded forms in the rocks, and deep space created by the river leading toward distant mountains. The open sky creates negative space, while the tree and rocks form positive space. Together, these choices help the painting look natural and create a feeling of openness.

## 7. Why Texture, Form, and Space Are Important in Art
Texture, form, and space help artists communicate ideas and create meaningful visual experiences.

Texture allows artists to show differences between surfaces and materials. Form helps objects appear solid and gives them volume. Space organizes the subjects and creates relationships between objects and their surroundings.

These elements are not limited to traditional artworks. They are also important in graphic design, photography, architecture, fashion, product design, and digital illustration.

For example, an architect considers the forms of a building and the spaces people will use. A photographer may use the space around a subject to make the picture feel peaceful or dramatic. A graphic designer may use negative space to make a poster clear and easy to read. A sculptor may combine rough and smooth textures to create contrast and make a sculpture more interesting.

By understanding these elements, viewers can explain not only what an artwork shows but also how the artist created its appearance and meaning.

## Key Takeaway
Texture describes how a surface looks or feels, form refers to the volume and three-dimensional appearance of an object, and space describes the area around, between, and occupied by objects.

Texture may be actual or implied. Form may be geometric or organic, and artists can create the illusion of form using shading, highlights, and shadows. Space includes positive and negative space, while techniques such as overlapping, linear perspective, atmospheric perspective, and size changes can create the illusion of depth.

The most important thing to remember is that these elements work together. They help artists show surfaces, make objects appear solid, organize subjects, create depth, and communicate emotions and ideas.''',
          keyTakeaway:
              'Texture describes surface, form describes volume, and space describes the areas around and between objects. Artists combine them to create depth, organize subjects, and communicate mood.',
          practicePrompt:
              'Choose an artwork and identify its textures, forms, and use of positive and negative space. Explain how these choices create depth or affect the mood.',
        ),
        LessonSection(
          title: 'Composition and visual balance',
          body:
              '## 1. What Is Composition?\nComposition is the way an artist arranges the different elements of art within an artwork. These elements include line, shape, color, texture, space, and form. The artist decides where to place each element to make the artwork interesting, organized, and meaningful.\n\nComposition helps guide the viewer’s eyes toward important parts of the artwork. It also affects how people understand the subject, feel about the image, and connect with the artist’s message.\n\nFor example, in a painting of a person standing in a garden, the artist may place the person in the center to make them the main subject. Bright colors on the person and darker colors in the background can make the subject stand out. A good composition does not always need to look neat or perfectly organized; unusual arrangements can express strong emotions, create tension, or make viewers think more deeply.\n\n## 2. Important Elements of Composition\n### A. Placement\nPlacement refers to where objects, people, shapes, and other elements are positioned. Their positions affect what viewers notice first and how they look across the image. A person in the center may appear important; the same person near an edge may suggest loneliness, distance, or isolation.\n\n### B. Scale and Size\nScale is the size of objects in relation to one another or to the whole artwork. Artists use size to show importance, create contrast, or suggest distance. A large tree beside several small people may appear powerful or impressive. An artist may deliberately make an important figure much larger than others to communicate status or power.\n\n### C. Repetition\nRepetition occurs when an artist uses the same or similar colors, shapes, lines, patterns, or objects more than once. It creates unity, rhythm, and connection. Repeated green leaves, red flowers, and curved lines in a garden painting can help the composition feel connected rather than random.\n\n### D. Contrast\nContrast is the difference between elements. It can be created with light and dark colors, large and small shapes, rough and smooth textures, or bright and dull colors. A white flower against a dark background attracts attention because the areas differ strongly. Artists use contrast to highlight details, create interest, and communicate mood.\n\n### E. Empty Space\nEmpty space, also called negative space, is the area around, between, or within the main objects. It gives a subject room to stand out and prevents an artwork from looking crowded. It can create peace, loneliness, openness, or distance. A small person in a wide, empty landscape may appear lonely or overwhelmed; a simple drawing with open space may feel calm.\n\n## 3. Focal Point\nA focal point is the part of an artwork that attracts attention first. It is often the main subject or the detail the artist most wants people to notice. Artists can create one through size (making an object larger), color (using a bright or unusual color), contrast (placing a light object against a dark background), detail (giving one area more detail), or position (placing a subject in a noticeable area).\n\nIn a busy street painting, a person wearing a bright yellow jacket may become the focal point because the color stands out from the buildings and other people. A focal point helps viewers understand what deserves attention, though an artwork can have several focal points that guide the eye between important subjects.\n\n## 4. What Is Visual Balance?\nVisual balance describes how the visual weight of different elements is distributed throughout an artwork. Visual weight is how strongly an element attracts attention or appears important. An object may have greater visual weight because it is large, dark, brightly colored, detailed, or placed in a noticeable area.\n\nA large, dark object on the left may make that side feel heavier. The artist can balance it with several smaller, lighter objects on the right. Balance can create stability and organization, but not every artwork needs to feel stable or calm. Imbalance can express movement, conflict, confusion, excitement, or tension.\n\n## 5. Types of Visual Balance\n### A. Symmetrical Balance\nSymmetrical balance occurs when elements on one side closely match or mirror those on the other. It often creates order, stability, harmony, and formality. Imagine a building with a central entrance, two matching windows on the left, and two on the right. This type of balance is common in buildings, formal portraits, religious artworks, and designs intended to look organized.\n\n### B. Asymmetrical Balance\nAsymmetrical balance occurs when the two sides are different but still feel balanced. Objects do not need to match because visual weight can be distributed in other ways. A large tree on the left might be balanced by several smaller birds on the right. A dark object can balance a brighter one, or a large simple shape can balance several small detailed shapes. Asymmetry often feels natural, lively, and interesting.\n\n### C. Radial Balance\nRadial balance occurs when elements are arranged around a central point and spread outward in a circular pattern. Flower petals around a center and spokes extending from the middle of a wheel are examples. Radial balance is common in flowers, mandalas, circular patterns, decorative designs, and some religious artworks. It draws attention to the center and creates movement around or outward from it.\n\n### D. Intentional Imbalance\nIntentional imbalance occurs when an artist deliberately arranges elements so the artwork feels uneven, unstable, or tense. A person near one edge with a large empty area elsewhere may suggest loneliness or uncertainty. Sharp angled lines, falling objects, or elements crowded into one area can also create imbalance. An artwork does not need to look balanced to communicate a strong message.\n\n## 6. The Relationship Between Composition and Balance\nComposition and visual balance work together. Composition determines where elements are placed; balance concerns how their visual weight is distributed. In a landscape, placing a large mountain on the right and trees on the left is a compositional choice. How the mountain and trees balance each other visually is a question of balance.\n\nThe artist may also use color, contrast, scale, and empty space to guide attention. If the mountain is very dark, brighter objects on the opposite side may prevent one area from dominating. Together, composition and balance can make an artwork easier to understand, more interesting to look at, and more effective at expressing ideas.\n\n## 7. How Composition and Balance Affect Mood\nThe arrangement of visual elements influences the feelings and ideas viewers experience:\n- **Calm and peaceful:** Simple arrangements, open spaces, and balanced elements can create a quiet, relaxing feeling.\n- **Powerful and important:** A large subject, strong contrast, or central placement can make a person or object appear important.\n- **Lonely or isolated:** A small subject surrounded by a large empty space can suggest loneliness or separation.\n- **Active and energetic:** Repeated shapes, strong colors, and diagonal lines can create movement and excitement.\n- **Tense or uncomfortable:** Uneven arrangements, crowded areas, and intentional imbalance can make the scene feel unstable.\n\nThese effects are not identical for every viewer. People may interpret an artwork differently depending on their experiences, culture, and understanding.\n\n## 8. How to Analyze Composition and Visual Balance\nWhen looking at an artwork, ask:\n1. What do I notice first? Identify the focal point or area that attracts your attention.\n2. Where are the main subjects placed: in the center, near the edges, or spread across the artwork?\n3. Which elements stand out most? Consider size, color, contrast, darkness, and detail.\n4. Is the artwork symmetrical or asymmetrical? Compare the visual weight on each side.\n5. Is there radial balance? Check whether elements spread outward from a central point.\n6. How is empty space used? Does it make the artwork feel open, peaceful, lonely, or dramatic?\n7. Does the artwork feel balanced or intentionally unbalanced? Does it feel stable or tense?\n8. What mood or message does the arrangement communicate? Explain how the artist’s choices affect your interpretation.\n\nFor example, in a painting of a person standing alone in a large field, the person may be the focal point because of their placement. The large amount of empty space around them may create loneliness. Unevenly distributed colors and objects may make the artwork feel less stable or more dramatic.\n\n## 9. Why Composition and Visual Balance Are Important\nComposition and visual balance help artists organize ideas and communicate with viewers. They influence what people notice, how their eyes move, and what emotions they may experience. These concepts matter in painting, drawing, photography, graphic design, architecture, posters, advertisements, and digital art.\n\nIn a poster, a large title at the top may be noticed first, a picture may sit in the center, and smaller details may appear below. The designer uses composition to organize information and visual balance to make the poster easy to look at. Understanding these concepts helps viewers move beyond asking what an artwork shows to asking why its elements were arranged in a particular way.\n\n## Key takeaway\nComposition is how an artist arranges visual elements in an artwork, while visual balance is how the visual weight of those elements is distributed. Placement, scale, repetition, contrast, empty space, and the focal point all affect how an artwork is seen and understood.\n\nBalance can be symmetrical, asymmetrical, or radial; artists can also use intentional imbalance to create tension or express emotions. There is no single arrangement that works for every artwork. Artists choose how to organize elements based on the message, feeling, or experience they want to communicate.',
          keyTakeaway:
              'Composition arranges visual elements, while balance distributes their visual weight. Artists use both to guide attention and communicate a mood or idea.',
          practicePrompt:
              'Identify an artwork’s focal point and type of balance. Explain how placement, contrast, and empty space affect its mood.',
        ),
      ],
    ),
    CourseResult(
      title: 'Art Appreciation: Art and Culture',
      author: 'LearnWise Arts Team',
      rating: 4.9,
      lessons: 5,
      gradientColors: const [Color(0xFF8055A5), Color(0xFFD38DAD)],
      description:
          'Understand how artworks reflect the time, place, beliefs, and experiences of the people who made them.',
      lessonSections: const [
        LessonSection(
          title: 'Art has a context',
          body:
              '## What context can tell us\nContext is the set of circumstances surrounding an artwork. It can include when and where it was made, who made or commissioned it, what materials and techniques were available, where it was first shown, and who was expected to see it. Historical events, religion, politics, trade, technology, family life, geography, and local customs can all influence an artwork.\n\nThe same subject can mean different things in different places and times. A portrait may record a likeness, show social status, preserve a memory, or serve a public purpose. The materials can also offer clues about resources, technologies, and intended use. Context helps explain why a work took the form it did, but it does not automatically tell us everything an artist or audience thought.\n\n## Research with evidence\nBegin by describing what is visible. Then ask focused context questions: Who made this? When and where? Who paid for it or used it? What events or traditions might be relevant? Use reliable sources such as museum records, scholarly writing, and sources from the communities connected to the work.\n\nKeep three things distinct: what you can observe directly, what a source confirms, and what you infer. Sources may disagree or leave gaps. Acknowledge uncertainty rather than filling it with assumptions. Context should deepen close looking, not replace it.',
          keyTakeaway:
              'Context adds evidence about an artwork’s time, place, makers, purpose, and audience.',
          practicePrompt:
              'Choose an artwork and list two things you can observe directly and two context questions you would research.',
        ),
        LessonSection(
          title: 'Symbols, beliefs, and meaning',
          body:
              '## How symbols communicate\nA symbol is an image, object, color, gesture, or pattern that can carry meaning beyond its literal appearance. Symbols may refer to a belief, story, value, group, event, or shared memory. Some associations are widely recognized within a particular tradition; others are personal, local, or specific to one artwork.\n\nDo not assume that a symbol has one universal meaning. The same color or object can communicate different things across communities and historical periods. Its placement, relationship to other symbols, material, and intended use can all affect its meaning. Repeated motifs may help identify a theme, but repetition alone does not prove what the artist intended.\n\n## Interpret with context\nNotice a possible symbol and describe exactly what you see before naming its meaning. Ask whether there is reliable information about how the relevant community understands it. Consider who created the work, who used or viewed it, and where it appeared. When possible, consult sources written by people connected to that culture as well as museum or academic sources.\n\nA careful interpretation distinguishes a supported explanation from a guess. It is acceptable to say that a meaning is uncertain. Symbols are clues within a larger artwork and cultural setting, not shortcuts that explain the whole work by themselves.',
          keyTakeaway:
              'Interpret symbols in their historical and cultural setting instead of assuming they mean the same thing everywhere.',
          practicePrompt:
              'Find a repeated symbol in an artwork. Write down what you can verify about it and what remains an open question.',
        ),
        LessonSection(
          title: 'Look with respect',
          body:
              '## Art can have living meaning\nArt may be sacred, ceremonial, political, or closely connected to a community’s identity. It may have been created for a particular use rather than for display in a museum. Objects can remain important to people today, even when they are presented as historical artifacts elsewhere. Ask who made the work, how it was intended to be used, who had access to it, and whose perspective it represents.\n\nWhen viewing work from a culture other than your own, approach it with curiosity rather than treating it as an object without living meaning. Avoid assuming that one artwork represents every person in a community. People within a culture may hold different experiences and interpretations.\n\n## Practice respectful interpretation\nUse careful language when information is incomplete. Seek sources from the community as well as museum or academic writing. Notice whether the work was removed from its original setting or whether its display raises questions of ownership, access, or care. Be willing to listen when community members describe meanings that are not obvious to outside viewers.\n\nRespectful appreciation does not mean avoiding questions. It means asking them thoughtfully, checking assumptions, recognizing limits in what you know, and giving relevant voices room to be heard.',
          keyTakeaway:
              'Respectful art appreciation listens to relevant community voices and makes room for different perspectives.',
          practicePrompt:
              'Before interpreting an unfamiliar artwork, write one assumption you might be making and one perspective you should seek.',
        ),
        LessonSection(
          title: 'Art, power, and patronage',
          body:
              '## Who makes and supports art?\nPatronage is the support an artist receives from an individual, institution, government, business, or community. Support may provide money, materials, workspace, training, or a place to exhibit. Patrons and institutions can influence which subjects are produced, how a work is presented, and who gets to see it. Artists may accept, negotiate, or resist those expectations.\n\nPortraits, religious commissions, public monuments, commercial images, and protest art can all reveal relationships between art and power. A commissioned portrait may present a leader in a carefully chosen way. A public monument may express shared values while also leaving some histories out. An artwork created without formal patronage may circulate through community spaces, online platforms, or personal networks.\n\n## Ask whose story is visible\nWhen studying a work, ask who funded or requested it, who made it, who was the intended audience, where it was displayed, and whose story is centered or missing. Consider whether access to materials, education, public space, or publication affected who could create and share work.\n\nThese questions do not prove an artist’s intention by themselves. Use historical evidence and visible details together. Looking at patronage helps explain the conditions in which a work was created and how different audiences may have encountered it.',
          keyTakeaway:
              'Funding, audience, and power can shape an artwork’s purpose, visibility, and point of view.',
          practicePrompt:
              'For a public artwork or portrait, ask who commissioned it, who it was meant for, and whose viewpoint it represents.',
        ),
        LessonSection(
          title: 'Connect past and present',
          body:
              '## Meaning changes across time\nAn artwork can mean different things to different audiences and at different times. Its original purpose may be documented, but later viewers bring new questions, values, and experiences. A work may be preserved, moved, restored, reproduced, reinterpreted, or debated as communities reconsider its history.\n\nThe history of a work includes more than its creation. Its ownership, display, circulation, and reception can change. A religious object moved into a gallery, for example, may be encountered differently from the way it was used in its original setting. A public monument may be understood differently as people revisit whose history it honors.\n\n## Compare historical and present-day perspectives\nAsk what evidence tells you about the period when the work was made and what people say about it today. Avoid assuming either that the original meaning is the only valid meaning or that a modern response tells you what everyone thought in the past. Distinguish the artist’s documented intentions, the evidence of the work, and later interpretations.\n\nBoth historical context and present-day perspectives can deepen understanding. When views conflict, describe the disagreement and the reasons behind it rather than forcing a simple answer.',
          keyTakeaway:
              'An artwork’s history matters, and its meaning can continue to develop as audiences change.',
          practicePrompt:
              'Describe one likely historical meaning and one way a present-day viewer might interpret the same artwork.',
        ),
      ],
    ),
    CourseResult(
      title: 'Art Appreciation: Creative Voices',
      author: 'LearnWise Arts Team',
      rating: 4.7,
      lessons: 5,
      gradientColors: const [Color(0xFF3C6EAA), Color(0xFF79A6D2)],
      description:
          'Meet different ways artists express identity, emotion, memory, and imagination through visual choices.',
      lessonSections: const [
        LessonSection(
          title: 'Every artist has a voice',
          body:
              '## What is an artistic voice?\nAn artist’s voice is the distinctive character that emerges through choices they make in their work. It may appear in recurring subjects, materials, marks, colors, scale, viewpoints, or themes. Voice is more than a recognizable style: it can include the questions an artist returns to, the experiences they choose to share, and the way they respond to the world around them.\n\nA single artwork may not show an entire voice. Compare several works and look for patterns as well as differences. An artist may experiment with unfamiliar materials, change subjects, or adapt their approach for a particular audience. Change does not mean the artist has lost their voice; it may show growth or a response to new circumstances.\n\n## Describe choices, not labels\nWhen discussing an artist, point to visible evidence. You might notice repeated angular shapes, close attention to everyday objects, or shifts between realistic and abstract forms. Avoid reducing a person to one label or assuming that every work has the same message. Consider the work’s date, purpose, collaborators, and context as well as the artist’s recurring choices.',
          keyTakeaway:
              'An artist’s voice develops through meaningful choices that may recur and change across their work.',
          practicePrompt:
              'Compare two works by the same artist. Name one choice they share and one way their approaches differ.',
        ),
        LessonSection(
          title: 'Identity and perspective',
          body:
              '## Identity in visual art\nIdentity can include personal history, family, language, place, community, beliefs, work, and many other parts of a person’s life. It can be expressed directly through portraiture or indirectly through objects, clothing, setting, gesture, symbols, and materials. An artist may choose to present themselves, another person, a community, or an imagined identity.\n\nNo single artwork has to represent an entire community. Individuals within a group have varied experiences, and an image can reflect one person’s point of view rather than a universal truth. Consider who made the work and who had the opportunity to tell the story.\n\n## Point of view and representation\nPerspective is also the position from which a scene is seen. Ask who is looking, who is being shown, who is absent, and whose experience the image invites you to notice. A close viewpoint can make a subject feel immediate; a distant viewpoint can make it seem observed or overlooked. Pose, framing, scale, and gaze affect the relationship between viewer and subject.\n\nRepresentation shapes how people and places are understood. Analyze the choices and context, and avoid treating your first impression as the only possible reading. These questions help explain how identity and point of view influence meaning.',
          keyTakeaway:
              'Art can express personal identity and point of view without standing in for every member of a group.',
          practicePrompt:
              'Notice whose point of view an artwork centers. Identify one choice that helps communicate that perspective.',
        ),
        LessonSection(
          title: 'Emotion and memory',
          body:
              '## How artworks suggest emotion\nArtists can communicate emotion through subject matter, color, rhythm, scale, materials, marks, and the way figures or objects are arranged. A tense scene might use sharp angles, crowded space, or abrupt contrasts; a quieter scene might use repeated forms, open space, and gradual transitions. These are possibilities to investigate, not fixed rules that guarantee one feeling.\n\nAsk what in the artwork produces your response. Is it a facial expression, a gesture, the direction of lines, the distance between figures, or a shift in light? Naming the evidence makes it easier to explain how a visual choice shapes mood.\n\n## Memory and personal response\nA memory may be represented realistically, or it may appear in fragments, repeated images, altered proportions, familiar objects, or unexpected combinations. These choices can suggest how remembering feels rather than simply recording what happened. Artists may combine personal memories with shared histories, but viewers should avoid inventing a biography without evidence.\n\nYour own experiences influence what you notice, so viewers may respond differently to the same work. Connect your reaction to details in the artwork, stay open to meanings that are unfamiliar, and remember that a personal response can coexist with historical or cultural interpretations.',
          keyTakeaway:
              'Visual choices can suggest emotion and memory, while each viewer brings their own experiences to the work.',
          practicePrompt:
              'Choose one visual choice that affects the mood. Explain how the artwork might feel different if that choice changed.',
        ),
        LessonSection(
          title: 'Materials and creative choices',
          body:
              '## Materials are part of meaning\nMaterials influence what an artist can make and how an artwork is experienced. Paint can be layered, blended, or applied in visible strokes. Clay can be modeled, carved, or fired into three-dimensional forms. Photography can frame a moment; printmaking can produce repeated images; found objects can carry associations from everyday life. Artists may use traditional materials, experiment with new ones, or combine several approaches.\n\nConsider a material’s texture, scale, weight, durability, cost, availability, and cultural associations. Materials can affect who can make a work, how it travels, and how it should be handled. The choice may connect to the subject or deliberately create a contrast.\n\n## Notice the process and its effect\nThe process itself can carry meaning. Visible brushstrokes may emphasize the act of making; precise repetition may suggest systems or control; a fragile material may make the work feel temporary. Ask what the chosen material makes possible that another material might not. Consider how the work would change if it were smaller, heavier, smoother, or made from a different source.\n\nDo not assume that a material has one universal meaning. Interpret it alongside the artwork’s form, context, and visible details.',
          keyTakeaway:
              'Materials are part of an artwork’s meaning because they affect its appearance, process, and audience experience.',
          practicePrompt:
              'Imagine the artwork made in a different material. Describe one change in its appearance or meaning.',
        ),
        LessonSection(
          title: 'Make your own response',
          body:
              '## Plan a visual idea\nCreate a small artwork that communicates an idea from your own experience. Begin with a subject, feeling, memory, or question. Decide what you want a viewer to notice first, then choose a format that suits the idea: a collage, arrangement of objects, photograph, simple drawing, or digital image. Advanced drawing skills are not required.\n\nMake a few deliberate choices about color, shape, line, material, viewpoint, scale, and what to leave out. Think about how these choices support one another. For example, open space may emphasize a small subject, while repeated shapes may suggest routine or movement.\n\n## Reflect and revise\nAfter making the work, describe your choices and what you hoped they would suggest. Ask a viewer what they notice before explaining your intention. Which details stood out? What mood or meaning did they infer? The difference between your intention and their interpretation can reveal new possibilities; it does not mean one of you is automatically wrong.\n\nUse the feedback to decide whether you want to clarify, change, or keep your choices. There is no single correct result. The goal is to make choices intentionally and explain how they contribute to the experience of the work.',
          keyTakeaway:
              'Creative choices communicate; reflecting on both intention and audience response helps you learn.',
          practicePrompt:
              'Make a small image using one color, one repeated shape, and one personal memory. Explain what each choice contributes.',
        ),
      ],
    ),
  ];

  void addRecentSearch(String term) {
    if (term.trim().isEmpty) return;
    recentSearches.remove(term);
    recentSearches.insert(0, term);
    if (recentSearches.length > 6) recentSearches.removeLast();
    notifyListeners();
  }

  // ----- Planner -----
  final List<PlannerTask> tasks = [
    PlannerTask(
      id: 't1',
      title: 'Physics: Newton\'s Laws',
      time: '2:00 PM - 3:30 PM',
      color: AppColorsProxy.primary,
    ),
    PlannerTask(
      id: 't2',
      title: 'Algebra: Vectors Revision',
      time: '4:00 PM - 5:00 PM',
      color: const Color(0xFF3FA6E6),
    ),
  ];

  final List<Map<String, String>> assignments = [
    {
      'title': 'Mechanics Problem Set',
      'due': 'Due tomorrow • High Priority',
    },
  ];

  void addTask(String title, String time) {
    tasks.add(PlannerTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      time: time,
      color: AppColorsProxy
          .taskColors[tasks.length % AppColorsProxy.taskColors.length],
    ));
    notifyListeners();
  }

  void updateTask(String id, {String? title, String? time, bool? isDone}) {
    final index = tasks.indexWhere((t) => t.id == id);
    if (index == -1) return;

    final task = tasks[index];
    if (title != null && title.trim().isNotEmpty) task.title = title.trim();
    if (time != null && time.trim().isNotEmpty) task.time = time.trim();
    if (isDone != null) task.isDone = isDone;
    notifyListeners();
  }

  void toggleTaskDone(String id) {
    final task = tasks.firstWhere((t) => t.id == id);
    task.isDone = !task.isDone;
    notifyListeners();
  }

  void removeTask(String id) {
    tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  // ----- Notifications -----
  final List<AppNotification> notifications = [
    AppNotification(
      id: 'n1',
      category: 'Reminders',
      title: 'Physics Quiz due tomorrow',
      body:
          "Lesson 3: Motion & Forces quiz closes at 11:59 PM. Don't lose your 5-day streak!",
      timeAgo: '2h ago',
      icon: Icons.notifications_active_rounded,
      iconColor: const Color(0xFFE85C5C),
    ),
    AppNotification(
      id: 'n2',
      category: 'System',
      title: 'Achievement Unlocked!',
      body:
          "Congratulations! You earned the 'Ace Player' badge for scoring 100% on Calculus Basics.",
      timeAgo: '5h ago',
      icon: Icons.emoji_events_rounded,
      iconColor: const Color(0xFFF2B84B),
    ),
    AppNotification(
      id: 'n3',
      category: 'Courses',
      title: 'New course recommended',
      body:
          "Based on your interest in Physics, Dr. Helen Edwards published 'Cosmology Hub: Level 1'.",
      timeAgo: '1d ago',
      icon: Icons.auto_stories_rounded,
      iconColor: AppColorsProxy.primary,
    ),
    AppNotification(
      id: 'n4',
      category: 'System',
      title: 'System Maintenance',
      body:
          'LearnWise will be undergoing scheduled upgrades on Sunday from 2:00 AM to 4:00 AM.',
      timeAgo: '3d ago',
      icon: Icons.settings_suggest_rounded,
      iconColor: const Color(0xFF4CAF87),
    ),
  ];

  int get unreadNotificationCount =>
      notifications.where((n) => !n.isRead).length;

  void markNotificationRead(String id) {
    notifications.firstWhere((n) => n.id == id).isRead = true;
    notifyListeners();
  }

  void markAllNotificationsRead() {
    for (final n in notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void clearNotifications() {
    notifications.clear();
    notifyListeners();
  }

  // ----- Bookmarks -----
  final List<BookmarkItem> bookmarks = [
    BookmarkItem(
      id: 'b1',
      type: BookmarkType.course,
      title: 'Intro to Physics',
      subtitle: 'Dr. Helen Edwards',
      tag: 'Science',
    ),
    BookmarkItem(
      id: 'b2',
      type: BookmarkType.course,
      title: 'Algebra Foundations',
      subtitle: 'Prof. Alan Turing',
      tag: 'Math',
    ),
  ];

  bool isBookmarked(String title) => bookmarks.any((b) => b.title == title);

  void toggleBookmark(BookmarkItem item) {
    final existing = bookmarks.where((b) => b.title == item.title);
    if (existing.isNotEmpty) {
      bookmarks.removeWhere((b) => b.title == item.title);
    } else {
      bookmarks.add(item);
    }
    notifyListeners();
  }

  // ----- Notes Summarizer -----
  String? summaryResult;
  List<String> summaryTags = [];
  final Set<String> savedSummaries = {};

  void summarizeNotes(String input) {
    if (input.trim().isEmpty) {
      summaryResult = null;
      summaryTags = [];
    } else {
      // Lightweight local mock "summarization" - takes the first sentence(s)
      // and surfaces a few keywords as tags. Wire this up to a real AI backend later.
      final sentences = input
          .split(RegExp(r'(?<=[.!?])\s+'))
          .where((s) => s.trim().isNotEmpty)
          .toList();
      final keyTakeaway =
          sentences.isNotEmpty ? sentences.first.trim() : input.trim();
      summaryResult = keyTakeaway;

      final words = input
          .replaceAll(RegExp(r'[^a-zA-Z\s]'), '')
          .split(RegExp(r'\s+'))
          .where((w) => w.length > 4)
          .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
          .toSet()
          .take(4)
          .toList();
      summaryTags = words;
    }
    notifyListeners();
  }

  // ----- AI Quiz Generator -----
  String quizDifficulty = 'Medium';
  String quizQuestionType = 'Multiple Choice';
  int quizQuestionCount = 15;
  bool quizTimeLimitEnabled = true;
  int quizTimeLimitMinutes = 20;

  void setQuizDifficulty(String value) {
    quizDifficulty = value;
    notifyListeners();
  }

  void setQuizQuestionType(String value) {
    quizQuestionType = value;
    notifyListeners();
  }

  void incrementQuizQuestions() {
    if (quizQuestionCount < 50) quizQuestionCount++;
    notifyListeners();
  }

  void decrementQuizQuestions() {
    if (quizQuestionCount > 5) quizQuestionCount--;
    notifyListeners();
  }

  void toggleQuizTimeLimit(bool value) {
    quizTimeLimitEnabled = value;
    notifyListeners();
  }
}

/// Small helper so PlannerTask default colors don't need BuildContext.
class AppColorsProxy {
  static const Color primary = Color(0xFF6C63FF);
  static const List<Color> taskColors = [
    Color(0xFF6C63FF),
    Color(0xFF3FA6E6),
    Color(0xFFF2B84B),
    Color(0xFF4CAF87),
  ];
}

/// ---------- InheritedNotifier plumbing ----------

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'No AppScope found in context');
    return scope!.notifier!;
  }
}
