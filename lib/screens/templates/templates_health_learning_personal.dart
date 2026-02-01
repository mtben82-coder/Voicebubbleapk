// ============================================================
//        ELITE TEMPLATES — HEALTH, LEARNING & PERSONAL
// ============================================================

import 'package:flutter/material.dart';
import 'template_models.dart';

// ============================================================
// 🏥 HEALTH TEMPLATES
// ============================================================

const foodLogTemplate = AppTemplate(
  id: 'food_log',
  name: 'Food Log',
  description: 'Track meals for MyFitnessPal, etc.',
  tagline: 'Voice your meals',
  category: TemplateCategory.health,
  icon: Icons.restaurant,
  gradientColors: [Color(0xFF10B981), Color(0xFF059669)],
  isPro: false,
  estimatedMinutes: 1,
  defaultExport: ExportFormat.csv,
  targetApp: 'MyFitnessPal / Sheets',
  availableExports: [ExportFormat.text, ExportFormat.csv, ExportFormat.json],
  aiSystemPrompt: '''Extract food log entries. For each item: meal type (breakfast/lunch/dinner/snack), food item, estimated portion, estimated calories if possible. Format as structured data.''',
  sections: [
    TemplateSection(
      id: 'food',
      title: 'What You Ate',
      hint: 'Describe your meals. Be as specific as you can.',
      aiPrompt: 'Extract each food item with meal type, portion, and estimated macros.',
      icon: Icons.fastfood,
      placeholder: 'Breakfast was 2 eggs scrambled with toast and coffee. Lunch was a chicken salad, no dressing. Snack was an apple.',
    ),
  ],
);

const symptomTrackerTemplate = AppTemplate(
  id: 'symptom_tracker',
  name: 'Symptom Tracker',
  description: 'Log symptoms and medications',
  tagline: 'Track your health',
  category: TemplateCategory.health,
  icon: Icons.medical_information,
  gradientColors: [Color(0xFFEF4444), Color(0xFFDC2626)],
  isPro: false,
  estimatedMinutes: 1,
  defaultExport: ExportFormat.csv,
  targetApp: 'Apple Health / Sheets',
  availableExports: [ExportFormat.text, ExportFormat.csv, ExportFormat.json],
  aiSystemPrompt: '''Extract health data: symptoms (with severity 1-10), medications taken (with dosage and time), mood, energy level, and any other health observations. Structure for health tracking.''',
  sections: [
    TemplateSection(
      id: 'health',
      title: 'How Are You Feeling?',
      hint: 'Symptoms, medications, energy, mood, anything health-related',
      aiPrompt: 'Extract all health data with severity levels and times.',
      icon: Icons.favorite,
      placeholder: 'Headache around 6 out of 10, took ibuprofen at 2pm, feeling a bit tired, mood is okay, slept 7 hours last night',
    ),
  ],
);

const workoutLogTemplate = AppTemplate(
  id: 'workout_log',
  name: 'Workout Log',
  description: 'Track exercises by voice',
  tagline: 'Voice your gains',
  category: TemplateCategory.health,
  icon: Icons.fitness_center,
  gradientColors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
  isPro: false,
  estimatedMinutes: 1,
  defaultExport: ExportFormat.csv,
  targetApp: 'Strong / Sheets',
  availableExports: [ExportFormat.text, ExportFormat.csv, ExportFormat.json],
  aiSystemPrompt: '''Extract workout data: exercise name, sets, reps, weight, any notes on form or difficulty. Format as structured workout log.''',
  sections: [
    TemplateSection(
      id: 'workout',
      title: 'Your Workout',
      hint: 'Exercises, sets, reps, weights, any notes',
      aiPrompt: 'Extract each exercise with full details.',
      icon: Icons.sports_gymnastics,
      placeholder: 'Bench press 4 sets of 8 at 185 pounds, felt good. Squats 3 sets of 10 at 225, last set was hard. 20 minutes on treadmill',
    ),
  ],
);

const medicalHistoryTemplate = AppTemplate(
  id: 'medical_history',
  name: 'Medical History',
  description: 'Fill intake forms fast',
  tagline: 'Save time at the doctor',
  category: TemplateCategory.health,
  icon: Icons.local_hospital,
  gradientColors: [Color(0xFF0891B2), Color(0xFF0E7490)],
  isPro: true,
  estimatedMinutes: 4,
  defaultExport: ExportFormat.text,
  targetApp: 'Medical Forms',
  availableExports: [ExportFormat.text, ExportFormat.markdown],
  aiSystemPrompt: '''Organize medical history into standard intake form categories: personal info, current medications, allergies, past surgeries, chronic conditions, family history, current symptoms/reason for visit.''',
  sections: [
    TemplateSection(
      id: 'medications',
      title: 'Current Medications',
      hint: 'All medications, supplements, dosages',
      aiPrompt: 'List all medications with dosages.',
      icon: Icons.medication,
      placeholder: 'Lisinopril 10mg daily for blood pressure, vitamin D, fish oil, take allergy pill in spring',
    ),
    TemplateSection(
      id: 'allergies',
      title: 'Allergies',
      hint: 'Drug allergies, food allergies, environmental',
      aiPrompt: 'List all allergies with reaction types.',
      icon: Icons.warning,
      placeholder: 'Allergic to penicillin, gives me a rash. Seasonal allergies to pollen. No food allergies.',
    ),
    TemplateSection(
      id: 'conditions',
      title: 'Past & Current Conditions',
      hint: 'Surgeries, chronic conditions, major illnesses',
      aiPrompt: 'Document all conditions with dates if known.',
      icon: Icons.medical_services,
      placeholder: 'Had appendix out in 2015, diagnosed with high blood pressure 2020, broke arm as a kid',
    ),
    TemplateSection(
      id: 'family',
      title: 'Family History',
      hint: 'Health conditions in your family',
      aiPrompt: 'Note relevant family medical history.',
      icon: Icons.people,
      required: false,
      placeholder: 'Dad has diabetes, mom had breast cancer at 60, grandpa had heart disease',
    ),
  ],
);

// ============================================================
// 📚 LEARNING TEMPLATES
// ============================================================

const flashcardTemplate = AppTemplate(
  id: 'flashcards',
  name: 'Flashcards',
  description: 'Create cards for Anki, Quizlet by voice',
  tagline: 'Study smarter',
  category: TemplateCategory.learning,
  icon: Icons.style,
  gradientColors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
  isPro: false,
  estimatedMinutes: 2,
  defaultExport: ExportFormat.csv,
  targetApp: 'Anki / Quizlet',
  availableExports: [ExportFormat.csv, ExportFormat.text, ExportFormat.json],
  aiSystemPrompt: '''Create flashcards from the content provided. Each card needs a clear front (question/term) and back (answer/definition). Format as CSV with front,back columns. Make questions clear and specific.''',
  sections: [
    TemplateSection(
      id: 'content',
      title: 'What to Learn',
      hint: 'Terms and definitions, questions and answers, concepts to memorize',
      aiPrompt: 'Create front/back flashcard pairs from this content.',
      icon: Icons.school,
      placeholder: 'Mitochondria is the powerhouse of the cell. Photosynthesis converts light to energy. DNA is the genetic code.',
    ),
  ],
);

const studyNotesTemplate = AppTemplate(
  id: 'study_notes',
  name: 'Study Notes',
  description: 'Turn lectures or reading into notes',
  tagline: 'Capture everything',
  category: TemplateCategory.learning,
  icon: Icons.menu_book,
  gradientColors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
  isPro: false,
  estimatedMinutes: 3,
  defaultExport: ExportFormat.markdown,
  targetApp: 'Notion / Google Docs',
  availableExports: [ExportFormat.text, ExportFormat.markdown],
  aiSystemPrompt: '''Transform lecture/reading content into organized study notes. Use headers, bullet points, and highlight key concepts. Include summary at end. Make it scannable and study-friendly.''',
  sections: [
    TemplateSection(
      id: 'subject',
      title: 'Subject/Topic',
      hint: 'What class or topic is this for?',
      aiPrompt: 'Add context header for notes.',
      icon: Icons.class_,
      placeholder: 'Biology 101, Chapter 5 on cell division',
    ),
    TemplateSection(
      id: 'content',
      title: 'Main Content',
      hint: 'The lecture content, reading material, key points',
      aiPrompt: 'Organize into clear, structured notes.',
      icon: Icons.edit_note,
      placeholder: 'Professor talked about mitosis versus meiosis, the stages of each, why cells divide, what can go wrong like cancer',
    ),
    TemplateSection(
      id: 'questions',
      title: 'Questions / Unclear Parts',
      hint: 'Anything you didn\'t understand? Need to review?',
      aiPrompt: 'Add questions section for follow-up.',
      icon: Icons.help,
      required: false,
      placeholder: 'Still confused about the difference between prophase 1 and 2, need to review the diagram',
    ),
  ],
);

const bookSummaryTemplate = AppTemplate(
  id: 'book_summary',
  name: 'Book Summary',
  description: 'Summarize books you\'ve read',
  tagline: 'Remember what you read',
  category: TemplateCategory.learning,
  icon: Icons.auto_stories,
  gradientColors: [Color(0xFF10B981), Color(0xFF059669)],
  isPro: false,
  estimatedMinutes: 5,
  defaultExport: ExportFormat.markdown,
  targetApp: 'Notion / Notes',
  availableExports: [ExportFormat.text, ExportFormat.markdown],
  aiSystemPrompt: '''Create a personal book summary. Include: book info, main themes, key takeaways, memorable quotes, how it applies to reader\'s life. Make it a useful future reference.''',
  sections: [
    TemplateSection(
      id: 'book',
      title: 'Book Info',
      hint: 'Title, author, genre, why you read it',
      aiPrompt: 'Create book header.',
      icon: Icons.book,
      placeholder: 'Atomic Habits by James Clear, self-improvement, recommended by a friend',
    ),
    TemplateSection(
      id: 'summary',
      title: 'Main Ideas',
      hint: 'What\'s the book about? Key arguments or themes?',
      aiPrompt: 'Summarize core concepts.',
      icon: Icons.lightbulb,
      placeholder: 'Small habits compound over time, 1% better every day, environment matters more than willpower, identity-based habits',
    ),
    TemplateSection(
      id: 'takeaways',
      title: 'Personal Takeaways',
      hint: 'What are you going to apply? What resonated?',
      aiPrompt: 'Highlight personal applications.',
      icon: Icons.star,
      placeholder: 'Going to redesign my morning routine, remove phone from bedroom, stack new habits onto existing ones',
    ),
    TemplateSection(
      id: 'quotes',
      title: 'Favorite Quotes',
      hint: 'Any quotes or passages that stuck with you?',
      aiPrompt: 'Include memorable quotes.',
      icon: Icons.format_quote,
      required: false,
      placeholder: 'You don\'t rise to the level of your goals, you fall to the level of your systems',
    ),
  ],
);

// ============================================================
// 🧘 PERSONAL TEMPLATES
// ============================================================

const dailyJournalTemplate = AppTemplate(
  id: 'daily_journal',
  name: 'Daily Journal',
  description: 'Voice your day in seconds',
  tagline: 'Reflect daily',
  category: TemplateCategory.personal,
  icon: Icons.edit_note,
  gradientColors: [Color(0xFF10B981), Color(0xFF059669)],
  isPro: false,
  estimatedMinutes: 2,
  defaultExport: ExportFormat.markdown,
  targetApp: 'Day One / Notes',
  availableExports: [ExportFormat.text, ExportFormat.markdown],
  aiSystemPrompt: '''Format as a dated journal entry. Keep the personal voice but organize thoughts. Include: what happened, how they felt, any reflections. Don\'t over-polish—journals should feel authentic.''',
  sections: [
    TemplateSection(
      id: 'day',
      title: 'Your Day',
      hint: 'What happened today? Good, bad, interesting?',
      aiPrompt: 'Capture the day\'s events naturally.',
      icon: Icons.today,
      placeholder: 'Had a good day, morning meeting went well, finally fixed that bug at work, grabbed lunch with Sarah, gym after',
    ),
    TemplateSection(
      id: 'feelings',
      title: 'How You\'re Feeling',
      hint: 'Emotions, energy, mindset',
      aiPrompt: 'Capture emotional state authentically.',
      icon: Icons.mood,
      required: false,
      placeholder: 'Feeling pretty good, a bit tired but accomplished, less anxious than yesterday',
    ),
    TemplateSection(
      id: 'thoughts',
      title: 'Thoughts / Reflections',
      hint: 'Anything on your mind? Insights? Things to remember?',
      aiPrompt: 'Include reflections and insights.',
      icon: Icons.psychology,
      required: false,
      placeholder: 'Realized I work better in the morning, should schedule important tasks then, also need to call mom this week',
    ),
  ],
);

const gratitudeJournalTemplate = AppTemplate(
  id: 'gratitude',
  name: 'Gratitude Journal',
  description: 'Build a gratitude practice',
  tagline: 'Find the good',
  category: TemplateCategory.personal,
  icon: Icons.favorite,
  gradientColors: [Color(0xFFF59E0B), Color(0xFFD97706)],
  isPro: false,
  estimatedMinutes: 1,
  defaultExport: ExportFormat.markdown,
  targetApp: 'Notes / Day One',
  availableExports: [ExportFormat.text, ExportFormat.markdown],
  aiSystemPrompt: '''Format as a simple gratitude entry. Keep it warm and genuine. Don\'t over-elaborate—brief and heartfelt is better. Date the entry.''',
  sections: [
    TemplateSection(
      id: 'grateful',
      title: 'What Are You Grateful For?',
      hint: 'Big or small, specific things from today',
      aiPrompt: 'Format as heartfelt gratitude list.',
      icon: Icons.favorite,
      placeholder: 'Grateful for the sunny weather, my morning coffee, that my mom called to check in, having a job I enjoy',
    ),
  ],
);

const dreamJournalTemplate = AppTemplate(
  id: 'dream_journal',
  name: 'Dream Journal',
  description: 'Capture dreams before they fade',
  tagline: 'Remember your dreams',
  category: TemplateCategory.personal,
  icon: Icons.nightlight,
  gradientColors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
  isPro: false,
  estimatedMinutes: 2,
  defaultExport: ExportFormat.markdown,
  targetApp: 'Notes',
  availableExports: [ExportFormat.text, ExportFormat.markdown],
  aiSystemPrompt: '''Capture the dream as described, keeping the surreal quality. Don\'t try to make it make sense. Include: setting, people, events, feelings, symbols. Date and note sleep quality if mentioned.''',
  sections: [
    TemplateSection(
      id: 'dream',
      title: 'Your Dream',
      hint: 'Just describe what you remember, even fragments',
      aiPrompt: 'Capture dream imagery and narrative as described.',
      icon: Icons.cloud,
      placeholder: 'Was in my old high school but it was also my office somehow, couldn\'t find my locker, my dog was there, felt anxious',
    ),
    TemplateSection(
      id: 'feelings',
      title: 'Feelings / Themes',
      hint: 'How did you feel? Any recurring themes?',
      aiPrompt: 'Note emotional content and potential themes.',
      icon: Icons.psychology,
      required: false,
      placeholder: 'Felt lost and unprepared, I have this kind of dream when stressed, maybe about the presentation coming up',
    ),
  ],
);

const goalSettingTemplate = AppTemplate(
  id: 'goal_setting',
  name: 'Goal Setting',
  description: 'Set and plan meaningful goals',
  tagline: 'Dream with a plan',
  category: TemplateCategory.personal,
  icon: Icons.flag,
  gradientColors: [Color(0xFFEC4899), Color(0xFFBE185D)],
  isPro: false,
  estimatedMinutes: 3,
  defaultExport: ExportFormat.markdown,
  targetApp: 'Notion / Notes',
  availableExports: [ExportFormat.text, ExportFormat.markdown],
  aiSystemPrompt: '''Create a SMART goal plan: Specific, Measurable, Achievable, Relevant, Time-bound. Include motivation, obstacles, and first steps. Make it actionable.''',
  sections: [
    TemplateSection(
      id: 'goal',
      title: 'Your Goal',
      hint: 'What do you want to achieve? Be specific.',
      aiPrompt: 'Clarify and sharpen the goal.',
      icon: Icons.flag,
      placeholder: 'Want to run a marathon by end of year, never done more than a 5K',
    ),
    TemplateSection(
      id: 'why',
      title: 'Why This Matters',
      hint: 'Why is this goal important to you?',
      aiPrompt: 'Capture the motivation for resilience.',
      icon: Icons.favorite,
      placeholder: 'Want to prove to myself I can do hard things, get healthier, my dad ran one at my age',
    ),
    TemplateSection(
      id: 'obstacles',
      title: 'Potential Obstacles',
      hint: 'What might get in the way? How will you handle it?',
      aiPrompt: 'Anticipate challenges with solutions.',
      icon: Icons.warning,
      placeholder: 'Busy work schedule, might get injured, lose motivation in winter, need to plan around these',
    ),
    TemplateSection(
      id: 'steps',
      title: 'First Steps',
      hint: 'What can you do this week to start?',
      aiPrompt: 'Create immediate action items.',
      icon: Icons.directions_run,
      placeholder: 'Sign up for a half marathon in 3 months, get new running shoes, find a training plan online',
    ),
  ],
);

const weeklyReviewTemplate = AppTemplate(
  id: 'weekly_review',
  name: 'Weekly Review',
  description: 'Reflect on your week, plan the next',
  tagline: 'Stay on track',
  category: TemplateCategory.personal,
  icon: Icons.calendar_view_week,
  gradientColors: [Color(0xFF0891B2), Color(0xFF0E7490)],
  isPro: false,
  estimatedMinutes: 3,
  defaultExport: ExportFormat.markdown,
  targetApp: 'Notion / Notes',
  availableExports: [ExportFormat.text, ExportFormat.markdown],
  aiSystemPrompt: '''Create a structured weekly review: wins, challenges, lessons, and priorities for next week. Keep it actionable and forward-looking.''',
  sections: [
    TemplateSection(
      id: 'wins',
      title: 'Wins This Week',
      hint: 'What went well? What are you proud of?',
      aiPrompt: 'Highlight accomplishments.',
      icon: Icons.emoji_events,
      placeholder: 'Finished the big project, had a great workout Tuesday, made time for friends on Saturday',
    ),
    TemplateSection(
      id: 'challenges',
      title: 'Challenges',
      hint: 'What was hard? What didn\'t go as planned?',
      aiPrompt: 'Acknowledge difficulties honestly.',
      icon: Icons.trending_down,
      placeholder: 'Procrastinated on the report, didn\'t sleep well Wednesday, skipped gym twice',
    ),
    TemplateSection(
      id: 'lessons',
      title: 'Lessons Learned',
      hint: 'What did you learn? What would you do differently?',
      aiPrompt: 'Extract actionable lessons.',
      icon: Icons.lightbulb,
      placeholder: 'Need to start big tasks earlier, should go to bed by 11, gym in morning works better for me',
    ),
    TemplateSection(
      id: 'next_week',
      title: 'Next Week Priorities',
      hint: 'Top 3 things to focus on next week',
      aiPrompt: 'Set clear priorities for the week ahead.',
      icon: Icons.arrow_forward,
      placeholder: 'Finish client proposal, gym 4 times, call mom, start planning vacation',
    ),
  ],
);