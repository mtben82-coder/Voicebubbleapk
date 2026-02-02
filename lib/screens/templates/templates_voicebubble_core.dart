// ============================================================
//        VOICEBUBBLE CORE TEMPLATES (12 TOTAL)
// ============================================================
//
// These are our foundational templates with voice-first interview flows
// that fill out the visual template structures perfectly.
//
// Each template has 1-5 questions max, with 10/10 examples shown to the user.
// AI cleans up grammar instantly and fills template sections intelligently.
//
// ============================================================

import 'package:flutter/material.dart';
import 'template_models.dart';
import 'elite_interview_system.dart';

// ============================================================
// 1️⃣ MEETING NOTES
// ============================================================

const meetingNotesInterview = [
  InterviewQuestion(
    id: 'meeting_basics',
    question: "What's the meeting about and who was there?",
    whyItMatters: "Sets the context - date, purpose, and attendees frame everything else.",
    exampleAnswer: "Weekly product sync on Tuesday, October 15th. Attendees were Sarah from product, Mike from engineering, and Lisa from design. We were discussing the Q4 roadmap priorities.",
    proTips: [
      "Include the date",
      "List all attendees by name and role",
      "State the meeting purpose clearly",
    ],
    minSeconds: 15,
    idealSeconds: 30,
    requiresSpecifics: true,
  ),

  InterviewQuestion(
    id: 'meeting_priorities',
    question: "What were the main priorities or topics discussed?",
    whyItMatters: "Captures the core agenda items and decisions.",
    exampleAnswer: "Top priorities were: Launch the new dashboard feature by November 1st, hire two more engineers by end of Q4, and fix the critical performance bug affecting 20% of users.",
    proTips: [
      "List 2-4 key priorities",
      "Include any deadlines mentioned",
      "Note urgency or importance",
    ],
    minSeconds: 20,
    idealSeconds: 45,
  ),

  InterviewQuestion(
    id: 'meeting_actions',
    question: "What action items came out of this? Who's responsible for what?",
    whyItMatters: "Action items are the most critical output - who does what by when.",
    exampleAnswer: "Mike will fix the performance bug by Friday. Sarah will draft the job descriptions by Monday. Lisa will create mockups for the dashboard by Wednesday. I need to schedule a follow-up with the CEO.",
    proTips: [
      "Name specific people",
      "Include clear deadlines",
      "List every actionable item",
    ],
    minSeconds: 20,
    idealSeconds: 45,
    requiresSpecifics: true,
  ),

  InterviewQuestion(
    id: 'meeting_notes',
    question: "Any other important details, decisions, or notes?",
    whyItMatters: "Captures context, decisions, or risks that don't fit elsewhere.",
    exampleAnswer: "The CEO is nervous about the November deadline - might need to push it. We agreed to do daily standups until the performance bug is fixed. Marketing wants a demo ready by October 25th for the customer event.",
    proTips: [
      "Include any concerns or risks",
      "Note changes to process",
      "Capture important context",
    ],
    minSeconds: 15,
    idealSeconds: 30,
  ),
];

final meetingNotesVoiceTemplate = AppTemplate(
  id: 'meeting_notes_voice',
  name: 'Meeting Notes',
  tagline: 'Capture meetings perfectly, hands-free',
  description: 'Voice-first meeting capture with clear sections for attendees, priorities, and action items',
  category: TemplateCategory.productivity,
  icon: Icons.groups_outlined,
  gradientColors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
  sections: [
    TemplateSection(
      id: 'meeting_info',
      title: 'Meeting Information',
      hint: 'Date, topic, and context',
      aiPrompt: 'Extract: Date, meeting purpose/topic. Format: "Date: [DATE], Topic: [PURPOSE]"',
      icon: Icons.calendar_today,
      required: true,
    ),
    TemplateSection(
      id: 'attendees',
      title: 'Attendees',
      hint: 'Who was present',
      aiPrompt: 'Extract all mentioned names and roles. List as bullet points. Format: "- [Name] ([Role])"',
      icon: Icons.people,
      multiLine: true,
    ),
    TemplateSection(
      id: 'priorities',
      title: 'Priorities',
      hint: 'Main topics and priorities discussed',
      aiPrompt: 'Extract key priorities, agenda items, and main discussion points. List as bullet points.',
      icon: Icons.star,
      multiLine: true,
    ),
    TemplateSection(
      id: 'action_items',
      title: 'Action Items',
      hint: 'Tasks and next steps',
      aiPrompt: 'Extract all action items with person responsible and deadline. Format as checkboxes: "- [ ] [Person]: [Task] (by [Deadline])"',
      icon: Icons.check_circle_outline,
      multiLine: true,
    ),
    TemplateSection(
      id: 'notes',
      title: 'Notes',
      hint: 'Additional context and details',
      aiPrompt: 'Extract any additional context, decisions, concerns, or risks. Format as bullet points.',
      icon: Icons.note,
      multiLine: true,
    ),
  ],
  interviewFlow: meetingNotesInterview,
  aiSystemPrompt: '''You are filling out structured meeting notes. 
Extract information precisely and organize it clearly:
- Meeting Info: Date and purpose/topic
- Attendees: Names and roles as bullet list
- Priorities: Key discussion points as bullet list
- Action Items: Tasks with person and deadline as checkboxes
- Notes: Context, decisions, risks as bullet list
Clean up grammar but preserve all names, dates, and specifics.''',
);

// ============================================================
// 2️⃣ DAILY JOURNAL
// ============================================================

const dailyJournalInterview = [
  InterviewQuestion(
    id: 'gratitude',
    question: "What are you grateful for today?",
    whyItMatters: "Starting with gratitude sets a positive mindset.",
    exampleAnswer: "I'm grateful for my morning coffee with my partner, the beautiful sunrise on my walk, and that my project presentation went really well at work.",
    proTips: [
      "Name 2-3 specific things",
      "Mix big and small moments",
      "Be genuine, not generic",
    ],
    minSeconds: 15,
    idealSeconds: 30,
  ),

  InterviewQuestion(
    id: 'goals',
    question: "What are your main goals or intentions for today?",
    whyItMatters: "Setting clear daily goals helps you stay focused.",
    exampleAnswer: "Finish the marketing report, go to the gym for 30 minutes, and call my mom tonight. I also want to start reading that new book.",
    proTips: [
      "List 2-4 concrete goals",
      "Mix work and personal",
      "Be specific about what 'done' looks like",
    ],
    minSeconds: 15,
    idealSeconds: 30,
  ),

  InterviewQuestion(
    id: 'challenge',
    question: "What's the biggest challenge you're facing right now?",
    whyItMatters: "Acknowledging challenges helps you process and plan.",
    exampleAnswer: "I'm stressed about the product launch deadline next week. There's still a bug we haven't fixed and I'm worried we won't make it. I also haven't been sleeping well.",
    proTips: [
      "Be honest about what's hard",
      "Name the specific issue",
      "It's okay to mention stress",
    ],
    minSeconds: 15,
    idealSeconds: 30,
  ),
];

final dailyJournalVoiceTemplate = AppTemplate(
  id: 'daily_journal_voice',
  name: 'Daily Journal',
  tagline: 'Start your day with intention',
  description: 'Morning reflection with gratitude, goals, and challenges',
  category: TemplateCategory.personal,
  icon: Icons.wb_sunny_outlined,
  gradientColors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
  sections: [
    TemplateSection(
      id: 'gratitude',
      title: 'Daily Gratitude',
      hint: 'What I\'m grateful for today',
      aiPrompt: 'Extract gratitude items. Format as a paragraph or bullet list. Keep the warm, personal tone.',
      icon: Icons.favorite,
      multiLine: true,
      required: true,
    ),
    TemplateSection(
      id: 'goals',
      title: 'Daily Goals',
      hint: 'My intentions for today',
      aiPrompt: 'Extract goals and intentions. Format as bullet points with checkboxes: "- [ ] [Goal]"',
      icon: Icons.flag,
      multiLine: true,
    ),
    TemplateSection(
      id: 'challenge',
      title: 'Daily Challenge',
      hint: 'What I\'m working through',
      aiPrompt: 'Extract the challenge or difficulty. Format as a paragraph, preserving the personal reflection.',
      icon: Icons.terrain,
      multiLine: true,
    ),
    TemplateSection(
      id: 'affirmation',
      title: 'Daily Affirmation',
      hint: 'Positive intention or mantra',
      aiPrompt: 'If mentioned, extract affirmation or positive intention. Otherwise, generate one based on their goals/challenges.',
      icon: Icons.auto_awesome,
    ),
  ],
  interviewFlow: dailyJournalInterview,
  aiSystemPrompt: '''You are filling out a morning journal entry.
Extract and organize with warmth and empathy:
- Gratitude: Personal, specific things they're thankful for
- Goals: Clear, actionable daily intentions
- Challenge: Current difficulty or stress (maintain honest tone)
- Affirmation: Positive intention (extract or generate based on context)
Preserve the personal, reflective tone.''',
);

// ============================================================
// 3️⃣ GRATITUDE JOURNAL (Evening)
// ============================================================

const gratitudeJournalInterview = [
  InterviewQuestion(
    id: 'best_moment',
    question: "What was the best part of your day?",
    whyItMatters: "Ending the day with a positive memory reinforces joy.",
    exampleAnswer: "The best part was having lunch with my colleague Sarah. We laughed so hard about a story from her weekend, and it reminded me how lucky I am to work with people I genuinely like.",
    proTips: [
      "Pick one specific moment",
      "Describe it with some detail",
      "What made it special?",
    ],
    minSeconds: 15,
    idealSeconds: 30,
  ),

  InterviewQuestion(
    id: 'good_things',
    question: "Name three good things that happened today, big or small.",
    whyItMatters: "Finding three positives trains your brain to notice good things.",
    exampleAnswer: "One, my morning workout felt amazing. Two, I finally fixed that bug I'd been stuck on. Three, my partner surprised me with my favorite takeout for dinner.",
    proTips: [
      "Mix big wins and small joys",
      "Be specific",
      "Three different things",
    ],
    minSeconds: 20,
    idealSeconds: 40,
  ),

  InterviewQuestion(
    id: 'grateful_for',
    question: "Who or what are you grateful for today?",
    whyItMatters: "Naming gratitude deepens appreciation.",
    exampleAnswer: "I'm grateful for my partner who always knows when I need a hug. For my team at work who covered for me when I had a dentist appointment. And for my health - I'm feeling strong and energized lately.",
    proTips: [
      "Name specific people",
      "Include why you're grateful",
      "Mix people, circumstances, and blessings",
    ],
    minSeconds: 20,
    idealSeconds: 40,
  ),

  InterviewQuestion(
    id: 'tomorrow',
    question: "What are you looking forward to tomorrow?",
    whyItMatters: "Ending with anticipation creates positive momentum.",
    exampleAnswer: "I'm excited about my morning run through the park, a coffee chat with a mentor I haven't seen in months, and finally starting that new project I've been planning.",
    proTips: [
      "Name 1-3 things",
      "Be specific",
      "What genuinely excites you?",
    ],
    minSeconds: 15,
    idealSeconds: 30,
  ),
];

final gratitudeJournalVoiceTemplate = AppTemplate(
  id: 'gratitude_journal_voice',
  name: 'Gratitude Journal',
  tagline: 'End your day with appreciation',
  description: 'Evening reflection focused on gratitude and positivity',
  category: TemplateCategory.personal,
  icon: Icons.favorite_border,
  gradientColors: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
  sections: [
    TemplateSection(
      id: 'best_moment',
      title: 'The Best Part of the Day Was',
      hint: 'Your favorite moment today',
      aiPrompt: 'Extract the best moment. Format as a paragraph, preserving detail and emotion.',
      icon: Icons.star,
      multiLine: true,
      required: true,
    ),
    TemplateSection(
      id: 'three_good_things',
      title: '3 Good Things That Happened Today',
      hint: 'Big or small wins',
      aiPrompt: 'Extract three good things. Format as numbered list: "1. [Thing]\\n2. [Thing]\\n3. [Thing]"',
      icon: Icons.check_circle,
      multiLine: true,
    ),
    TemplateSection(
      id: 'grateful_for',
      title: '3 Things I\'m Grateful For Today',
      hint: 'People, moments, or blessings',
      aiPrompt: 'Extract gratitude items. Format as numbered list: "1. [Gratitude]\\n2. [Gratitude]\\n3. [Gratitude]"',
      icon: Icons.favorite,
      multiLine: true,
    ),
    TemplateSection(
      id: 'tomorrow',
      title: 'Tomorrow, I Look Forward To',
      hint: 'What excites you about tomorrow',
      aiPrompt: 'Extract what they\'re looking forward to. Format as a positive, forward-looking paragraph.',
      icon: Icons.wb_sunny,
      multiLine: true,
    ),
  ],
  interviewFlow: gratitudeJournalInterview,
  aiSystemPrompt: '''You are filling out an evening gratitude journal.
Extract and organize with warmth:
- Best Moment: One special moment from today (detailed paragraph)
- Three Good Things: Numbered list of 3 positive events
- Grateful For: Numbered list of 3 gratitudes
- Tomorrow: What they're looking forward to (positive paragraph)
Preserve the grateful, reflective tone. Keep it warm and personal.''',
);

// ============================================================
// 4️⃣ GROCERY LIST
// ============================================================

const groceryListInterview = [
  InterviewQuestion(
    id: 'groceries_needed',
    question: "What do you need to buy? Just say everything you need, category by category if that's easier.",
    whyItMatters: "A complete list means no forgotten items and no extra trips.",
    exampleAnswer: "For dairy I need milk, eggs, and Greek yogurt. Meat: chicken breasts and ground beef. Fruits and veggies: bananas, apples, spinach, tomatoes, and bell peppers. Frozen: a bag of mixed berries. And drinks: orange juice and sparkling water.",
    proTips: [
      "Go through your meal plan mentally",
      "Think by meal or category",
      "Check your fridge and pantry",
      "Include quantities if specific",
    ],
    minSeconds: 30,
    idealSeconds: 60,
  ),
];

final groceryListVoiceTemplate = AppTemplate(
  id: 'grocery_list_voice',
  name: 'Grocery List',
  tagline: 'Shop smarter with voice',
  description: 'Quick grocery list organized by category',
  category: TemplateCategory.personal,
  icon: Icons.shopping_cart_outlined,
  gradientColors: [Color(0xFF10B981), Color(0xFF059669)],
  sections: [
    TemplateSection(
      id: 'dairy',
      title: 'Dairy',
      hint: 'Milk, eggs, cheese, yogurt',
      aiPrompt: 'Extract dairy items. Format as checkboxes: "- [ ] [Item]"',
      icon: Icons.egg_outlined,
      multiLine: true,
    ),
    TemplateSection(
      id: 'meat',
      title: 'Meat & Seafood',
      hint: 'Proteins',
      aiPrompt: 'Extract meat and seafood items. Format as checkboxes: "- [ ] [Item]"',
      icon: Icons.set_meal_outlined,
      multiLine: true,
    ),
    TemplateSection(
      id: 'produce',
      title: 'Fruits & Veggies',
      hint: 'Fresh produce',
      aiPrompt: 'Extract fruits and vegetables. Format as checkboxes: "- [ ] [Item]"',
      icon: Icons.local_florist_outlined,
      multiLine: true,
    ),
    TemplateSection(
      id: 'frozen',
      title: 'Frozen',
      hint: 'Frozen foods',
      aiPrompt: 'Extract frozen items. Format as checkboxes: "- [ ] [Item]"',
      icon: Icons.ac_unit_outlined,
      multiLine: true,
    ),
    TemplateSection(
      id: 'drinks',
      title: 'Drinks',
      hint: 'Beverages',
      aiPrompt: 'Extract drinks and beverages. Format as checkboxes: "- [ ] [Item]"',
      icon: Icons.local_drink_outlined,
      multiLine: true,
    ),
    TemplateSection(
      id: 'other',
      title: 'Others',
      hint: 'Everything else',
      aiPrompt: 'Extract any items that don\'t fit the above categories. Format as checkboxes: "- [ ] [Item]"',
      icon: Icons.more_horiz,
      multiLine: true,
    ),
  ],
  interviewFlow: groceryListInterview,
  aiSystemPrompt: '''You are organizing a grocery list by category.
Listen for food items and categorize them:
- Dairy: milk, eggs, cheese, yogurt, butter
- Meat & Seafood: chicken, beef, fish, pork
- Fruits & Veggies: all produce
- Frozen: frozen foods
- Drinks: beverages
- Others: anything that doesn't fit above
Format each as checkboxes. Add quantities if mentioned.''',
);

// ============================================================
// 5️⃣ RECIPE
// ============================================================

const recipeInterview = [
  InterviewQuestion(
    id: 'recipe_basics',
    question: "What's the recipe name, and how long does it take to prep and cook?",
    whyItMatters: "Title and timing help you plan when to make this.",
    exampleAnswer: "It's my grandma's chicken soup. Takes about 15 minutes to prep and then simmers for an hour. Serves 6 people.",
    proTips: [
      "Give it a clear name",
      "Separate prep time and cook time",
      "Mention serving size",
    ],
    minSeconds: 10,
    idealSeconds: 20,
  ),

  InterviewQuestion(
    id: 'ingredients',
    question: "What ingredients do you need? List everything with amounts.",
    whyItMatters: "Precise ingredients mean the recipe works every time.",
    exampleAnswer: "You need 2 pounds of chicken thighs, 1 large onion diced, 3 carrots sliced, 3 celery stalks chopped, 8 cups of chicken broth, 2 bay leaves, salt and pepper to taste, and fresh parsley for garnish.",
    proTips: [
      "Include amounts (cups, tablespoons, pounds)",
      "Be specific about prep (diced, chopped, sliced)",
      "Don't forget seasonings",
    ],
    minSeconds: 30,
    idealSeconds: 60,
    requiresSpecifics: true,
  ),

  InterviewQuestion(
    id: 'directions',
    question: "Walk me through the steps to make this, from start to finish.",
    whyItMatters: "Clear steps make the recipe easy to follow.",
    exampleAnswer: "First, heat oil in a large pot over medium heat. Add the onion, carrots, and celery, cook until soft, about 5 minutes. Then add the chicken and cook until browned. Pour in the chicken broth, add the bay leaves, and bring to a boil. Reduce heat and simmer for an hour. Remove the bay leaves, season with salt and pepper, and garnish with fresh parsley before serving.",
    proTips: [
      "Go step by step in order",
      "Include cooking times and temps",
      "Mention when to add each ingredient",
    ],
    minSeconds: 30,
    idealSeconds: 60,
    requiresSpecifics: true,
  ),

  InterviewQuestion(
    id: 'notes',
    question: "Any tips, substitutions, or notes to make this recipe perfect?",
    whyItMatters: "Pro tips and notes make the difference between good and great.",
    exampleAnswer: "You can use chicken breast instead of thighs if you prefer. Add noodles or rice in the last 10 minutes if you want it heartier. It tastes even better the next day. Freezes well for up to 3 months.",
    proTips: [
      "Mention substitutions",
      "Share your secret tips",
      "Storage and reheating info",
    ],
    minSeconds: 15,
    idealSeconds: 30,
  ),
];

final recipeVoiceTemplate = AppTemplate(
  id: 'recipe_voice',
  name: 'Recipe',
  tagline: 'Save recipes by voice',
  description: 'Capture family recipes and cooking instructions',
  category: TemplateCategory.personal,
  icon: Icons.restaurant_outlined,
  gradientColors: [Color(0xFFF59E0B), Color(0xFFDC2626)],
  sections: [
    TemplateSection(
      id: 'title',
      title: 'Title',
      hint: 'Recipe name',
      aiPrompt: 'Extract recipe name/title.',
      icon: Icons.title,
      required: true,
    ),
    TemplateSection(
      id: 'times',
      title: 'Times & Servings',
      hint: 'Prep time, cook time, servings',
      aiPrompt: 'Extract prep time, cook time, and servings. Format: "Prep Time: X minutes\\nCook Time: X minutes\\nServings: X"',
      icon: Icons.timer,
    ),
    TemplateSection(
      id: 'ingredients',
      title: 'Ingredients',
      hint: 'All ingredients with amounts',
      aiPrompt: 'Extract all ingredients with amounts and prep notes. Format as bullet list: "- [Amount] [Ingredient] ([prep])"',
      icon: Icons.list,
      multiLine: true,
      required: true,
    ),
    TemplateSection(
      id: 'directions',
      title: 'Directions',
      hint: 'Step-by-step instructions',
      aiPrompt: 'Extract cooking steps in order. Format as numbered list: "1. [Step]\\n2. [Step]"',
      icon: Icons.format_list_numbered,
      multiLine: true,
      required: true,
    ),
    TemplateSection(
      id: 'notes',
      title: 'Notes',
      hint: 'Tips, substitutions, storage',
      aiPrompt: 'Extract any tips, substitutions, variations, or storage notes. Format as bullet list.',
      icon: Icons.lightbulb_outline,
      multiLine: true,
    ),
  ],
  interviewFlow: recipeInterview,
  aiSystemPrompt: '''You are capturing a recipe.
Extract and organize clearly:
- Title: Recipe name
- Times: Prep, cook, and servings
- Ingredients: All items with amounts and prep (bullet list)
- Directions: Numbered step-by-step instructions
- Notes: Tips, substitutions, storage (bullet list)
Be precise with amounts and steps.''',
);

// ============================================================
// 6️⃣ HABIT TRACKER
// ============================================================

const habitTrackerInterview = [
  InterviewQuestion(
    id: 'habits_to_track',
    question: "What habits do you want to track this week?",
    whyItMatters: "Choosing the right habits is the first step to building consistency.",
    exampleAnswer: "I want to track drinking 8 glasses of water, exercising for at least 30 minutes, reading for 20 minutes before bed, meditating for 10 minutes in the morning, and getting to bed by 10:30 PM.",
    proTips: [
      "Choose 3-5 habits max",
      "Make them specific and measurable",
      "Mix health, productivity, and wellness",
    ],
    minSeconds: 20,
    idealSeconds: 40,
  ),
];

final habitTrackerVoiceTemplate = AppTemplate(
  id: 'habit_tracker_voice',
  name: 'Habit Tracker',
  tagline: 'Build consistency, track progress',
  description: 'Weekly habit tracker with checkboxes for each day',
  category: TemplateCategory.health,
  icon: Icons.check_box_outlined,
  gradientColors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
  sections: [
    TemplateSection(
      id: 'week',
      title: 'Week Of',
      hint: 'Date range for this week',
      aiPrompt: 'Generate current week date range in format "Month DD - Month DD, YYYY"',
      icon: Icons.calendar_today,
    ),
    TemplateSection(
      id: 'habits',
      title: 'Habits to Track',
      hint: 'Your weekly habits',
      aiPrompt: '''Extract habits and create a tracking table:
| Habit | Mon | Tue | Wed | Thu | Fri | Sat | Sun |
|-------|-----|-----|-----|-----|-----|-----|-----|
| [Habit 1] | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| [Habit 2] | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
(repeat for all habits)''',
      icon: Icons.list,
      multiLine: true,
      required: true,
    ),
    TemplateSection(
      id: 'notes',
      title: 'Notes',
      hint: 'Weekly reflection',
      aiPrompt: 'Space for user to add weekly reflections or notes.',
      icon: Icons.note,
      multiLine: true,
      placeholder: 'Add your weekly reflection here...',
    ),
  ],
  interviewFlow: habitTrackerInterview,
  aiSystemPrompt: '''You are creating a weekly habit tracker.
Extract habits and create a clean tracking table with 7 columns (Mon-Sun).
Each habit gets a row with checkboxes for each day.
Keep it simple and visual.''',
);

// ============================================================
// 7️⃣ EXPENSE TRACKER
// ============================================================

const expenseTrackerInterview = [
  InterviewQuestion(
    id: 'expenses_month',
    question: "What expenses do you want to log? Tell me the date, what you bought, category, and amount for each.",
    whyItMatters: "Tracking spending helps you understand where your money goes.",
    exampleAnswer: "October 15th, coffee at Starbucks, food category, 6 dollars and 50 cents. October 16th, gas fill-up, transportation, 45 dollars. October 17th, groceries at Whole Foods, food, 127 dollars. October 18th, movie tickets, entertainment, 28 dollars.",
    proTips: [
      "Include the date for each expense",
      "Categorize: food, transport, entertainment, shopping, etc.",
      "Be specific about amounts",
      "You can add multiple expenses",
    ],
    minSeconds: 30,
    idealSeconds: 90,
    requiresMetrics: true,
  ),
];

final expenseTrackerVoiceTemplate = AppTemplate(
  id: 'expense_tracker_voice',
  name: 'Expense Tracker',
  tagline: 'Track spending effortlessly',
  description: 'Log expenses by voice with automatic categorization',
  category: TemplateCategory.productivity,
  icon: Icons.attach_money_outlined,
  gradientColors: [Color(0xFF10B981), Color(0xFF059669)],
  sections: [
    TemplateSection(
      id: 'month',
      title: 'Month Of',
      hint: 'Tracking period',
      aiPrompt: 'Extract or generate month/year being tracked.',
      icon: Icons.calendar_month,
    ),
    TemplateSection(
      id: 'expenses',
      title: 'Expenses',
      hint: 'Your expense log',
      aiPrompt: 'Extract expenses and create a table:\n'
          '| Date | Description | Category | Amount |\n'
          '|------|-------------|----------|--------|\n'
          '| MM/DD | [Item] | [Category] | \$[Amount] |\n'
          '(one row per expense)',
      icon: Icons.receipt,
      multiLine: true,
      required: true,
    ),
    TemplateSection(
      id: 'total',
      title: 'Total',
      hint: 'Sum of all expenses',
      aiPrompt: 'Calculate total of all expense amounts. Format: "**\$[Total]**"',
      icon: Icons.calculate,
    ),
    TemplateSection(
      id: 'notes',
      title: 'Notes',
      hint: 'Spending insights',
      aiPrompt: 'Space for user notes or observations about spending patterns.',
      icon: Icons.note,
      multiLine: true,
      placeholder: 'Add notes about your spending...',
    ),
  ],
  interviewFlow: expenseTrackerInterview,
  aiSystemPrompt: '''You are logging expenses.
Extract date, description, category, and amount for each expense.
Create a clean table format.
Calculate the total at the bottom.
Categories: Food, Transportation, Entertainment, Shopping, Bills, Healthcare, Other.''',
);

// ============================================================
// 8️⃣ GOAL PLANNER
// ============================================================

const goalPlannerInterview = [
  InterviewQuestion(
    id: 'goal_statement',
    question: "What's your goal? Be specific about what you want to achieve.",
    whyItMatters: "A clear goal is the foundation of success.",
    exampleAnswer: "My goal is to run a half marathon by June 1st, 2024. I've never run more than 5 miles before, but I want to challenge myself and get in better shape.",
    proTips: [
      "Make it specific and measurable",
      "Include a deadline",
      "Explain why it matters to you",
    ],
    minSeconds: 20,
    idealSeconds: 40,
    requiresSpecifics: true,
  ),

  InterviewQuestion(
    id: 'action_steps',
    question: "What are the specific steps you need to take to achieve this goal?",
    whyItMatters: "Breaking it down into steps makes big goals achievable.",
    exampleAnswer: "First, I need to buy proper running shoes. Then follow a 12-week training plan, starting with run-walk intervals. I'll run 4 times a week, gradually increasing distance. Sign up for the actual race by March. Join a running group for motivation. Track my progress in an app.",
    proTips: [
      "List 4-6 concrete action steps",
      "Put them in order if there's a sequence",
      "Make each step actionable",
    ],
    minSeconds: 30,
    idealSeconds: 60,
  ),

  InterviewQuestion(
    id: 'motivation_strategy',
    question: "Why does this goal matter to you, and how will you stay motivated?",
    whyItMatters: "Knowing your 'why' keeps you going when it gets hard.",
    exampleAnswer: "This matters because I want to prove to myself I can do hard things. I've been feeling sluggish and this will get me healthy. My strategy is to tell all my friends so I'm accountable, reward myself with a massage at milestones, and visualize crossing that finish line every morning.",
    proTips: [
      "Connect to a deeper reason",
      "Include specific motivation tactics",
      "Think about accountability",
    ],
    minSeconds: 30,
    idealSeconds: 60,
  ),
];

final goalPlannerVoiceTemplate = AppTemplate(
  id: 'goal_planner_voice',
  name: 'Goal Planner',
  tagline: 'Turn dreams into plans',
  description: 'Set goals with clear action steps and motivation',
  category: TemplateCategory.productivity,
  icon: Icons.flag_outlined,
  gradientColors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
  sections: [
    TemplateSection(
      id: 'dates',
      title: 'Dates',
      hint: 'Created and target date',
      aiPrompt: 'Extract: "Created: [Date]\\nTo Achieve By: [Target Date]"',
      icon: Icons.calendar_today,
    ),
    TemplateSection(
      id: 'goal',
      title: 'Goal',
      hint: 'Your specific goal',
      aiPrompt: 'Extract the goal statement clearly and concisely.',
      icon: Icons.star,
      multiLine: true,
      required: true,
    ),
    TemplateSection(
      id: 'action_steps',
      title: 'Action Steps',
      hint: 'How you\'ll achieve it',
      aiPrompt: 'Extract action steps. Format as numbered list: "1. [Step]\\n2. [Step]"',
      icon: Icons.format_list_numbered,
      multiLine: true,
      required: true,
    ),
    TemplateSection(
      id: 'motivation',
      title: 'Motivation',
      hint: 'Why this matters',
      aiPrompt: 'Extract why the goal matters and motivation strategy. Format as paragraph.',
      icon: Icons.favorite,
      multiLine: true,
    ),
    TemplateSection(
      id: 'strategy',
      title: 'Strategy',
      hint: 'How you\'ll approach this',
      aiPrompt: 'Extract strategy and tactics for staying on track. Format as bullet points.',
      icon: Icons.psychology,
      multiLine: true,
    ),
    TemplateSection(
      id: 'progress',
      title: 'Progress Tracker',
      hint: 'Track your journey',
      aiPrompt: 'Create space for tracking progress weekly.',
      icon: Icons.trending_up,
      multiLine: true,
      placeholder: 'Update your progress here...',
    ),
  ],
  interviewFlow: goalPlannerInterview,
  aiSystemPrompt: '''You are helping someone plan a goal.
Extract and organize:
- Goal: Clear, specific statement with deadline
- Action Steps: Numbered, actionable steps
- Motivation: Why it matters (paragraph)
- Strategy: How they'll stay on track (bullets)
- Progress: Space for updates
Keep it motivating and actionable.''',
);

// ============================================================
// 9️⃣ TO DO LIST
// ============================================================

const todoListInterview = [
  InterviewQuestion(
    id: 'tasks',
    question: "What do you need to get done? List everything on your mind.",
    whyItMatters: "Getting it all out of your head helps you focus.",
    exampleAnswer: "I need to finish the quarterly report, respond to emails from clients, call the dentist to schedule a cleaning, pick up dry cleaning, buy a birthday gift for my sister, pay the electric bill, and prep for tomorrow's presentation.",
    proTips: [
      "Brain dump everything",
      "Don't filter - just list it all",
      "Mix work and personal",
    ],
    minSeconds: 20,
    idealSeconds: 60,
  ),

  InterviewQuestion(
    id: 'priorities',
    question: "Out of everything you listed, what are your top 3 priorities today?",
    whyItMatters: "Prioritizing ensures the important stuff gets done.",
    exampleAnswer: "Priority one is finishing the quarterly report because it's due tomorrow. Priority two is prepping for my presentation. Priority three is responding to client emails because they're time-sensitive.",
    proTips: [
      "Pick exactly 3",
      "What MUST get done today?",
      "What has the biggest impact?",
    ],
    minSeconds: 15,
    idealSeconds: 30,
  ),
];

final todoListVoiceTemplate = AppTemplate(
  id: 'todo_list_voice',
  name: 'To Do List',
  tagline: 'Organize your day by voice',
  description: 'Quick task capture with smart prioritization',
  category: TemplateCategory.productivity,
  icon: Icons.check_circle_outline,
  gradientColors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
  sections: [
    TemplateSection(
      id: 'date',
      title: 'Date',
      hint: 'Today\'s date',
      aiPrompt: 'Extract or generate today\'s date.',
      icon: Icons.calendar_today,
    ),
    TemplateSection(
      id: 'todo',
      title: 'To Do',
      hint: 'All your tasks',
      aiPrompt: 'Extract all tasks. Format as checkboxes: "- [ ] [Task]"',
      icon: Icons.list,
      multiLine: true,
      required: true,
    ),
    TemplateSection(
      id: 'priorities',
      title: 'Priorities',
      hint: 'Top 3 must-dos',
      aiPrompt: 'Extract top 3 priorities. Format as numbered list: "1. [Priority]\\n2. [Priority]\\n3. [Priority]"',
      icon: Icons.star,
      multiLine: true,
    ),
    TemplateSection(
      id: 'notes',
      title: 'Notes',
      hint: 'Additional reminders',
      aiPrompt: 'Extract any additional context or notes.',
      icon: Icons.note,
      multiLine: true,
    ),
    TemplateSection(
      id: 'reminder',
      title: 'Reminder',
      hint: 'Important thing to remember',
      aiPrompt: 'Extract the most important reminder or note.',
      icon: Icons.notifications,
    ),
  ],
  interviewFlow: todoListInterview,
  aiSystemPrompt: '''You are creating a to-do list.
Extract and organize:
- To Do: All tasks as checkboxes
- Priorities: Top 3 as numbered list
- Notes: Any additional context
- Reminder: Most important thing to remember
Keep it clean and actionable.''',
);

// ============================================================
// 🔟 QUICK NOTES
// ============================================================

const quickNotesInterview = [
  InterviewQuestion(
    id: 'notes_content',
    question: "What do you want to capture?",
    whyItMatters: "Sometimes you just need to get thoughts out fast.",
    exampleAnswer: "Meeting with Sarah next Tuesday at 3 PM about the marketing campaign. She mentioned three key ideas: focus on video content, partner with micro-influencers, and launch by end of Q4. Also need to remember to send her the budget spreadsheet before the meeting.",
    proTips: [
      "Just speak naturally",
      "Don't worry about structure",
      "Capture what matters",
    ],
    minSeconds: 10,
    idealSeconds: 45,
  ),
];

final quickNotesVoiceTemplate = AppTemplate(
  id: 'quick_notes_voice',
  name: 'Quick Notes',
  tagline: 'Capture thoughts instantly',
  description: 'Fast, unstructured note-taking for quick thoughts',
  category: TemplateCategory.personal,
  icon: Icons.edit_note_outlined,
  gradientColors: [Color(0xFF6B7280), Color(0xFF4B5563)],
  sections: [
    TemplateSection(
      id: 'main_notes',
      title: 'Main Notes',
      hint: 'Your thoughts and ideas',
      aiPrompt: 'Extract the main content. Clean up grammar but preserve all information. Format as paragraphs.',
      icon: Icons.note,
      multiLine: true,
      required: true,
    ),
    TemplateSection(
      id: 'ideas',
      title: 'Quick Ideas',
      hint: 'Key takeaways',
      aiPrompt: 'Extract any distinct ideas or takeaways. Format as emoji bullets: "💡 [Idea]"',
      icon: Icons.lightbulb_outline,
      multiLine: true,
    ),
  ],
  interviewFlow: quickNotesInterview,
  aiSystemPrompt: '''You are capturing quick notes.
Clean up grammar but preserve all information.
Main Notes: Primary content as paragraphs
Quick Ideas: Extract distinct ideas as emoji bullets (💡)
Keep it simple and fast.''',
);

// ============================================================
// 1️⃣1️⃣ PROJECT SCHEDULE
// ============================================================

const projectScheduleInterview = [
  InterviewQuestion(
    id: 'project_info',
    question: "What's the project name, and who's the client or stakeholder?",
    whyItMatters: "Setting clear context for the project plan.",
    exampleAnswer: "Project name is Website Redesign, client is Acme Corporation, and my project lead is Sarah Johnson.",
    proTips: [
      "Name the project clearly",
      "Include client or company name",
      "Mention key stakeholders",
    ],
    minSeconds: 10,
    idealSeconds: 20,
  ),

  InterviewQuestion(
    id: 'strategy_goals',
    question: "What's the strategy or main goals for this project?",
    whyItMatters: "Goals keep the project focused and on track.",
    exampleAnswer: "Main goals are to increase conversion rate by 30%, improve mobile user experience, and reduce page load time to under 2 seconds. Strategy is to do user research first, then redesign in phases.",
    proTips: [
      "List 2-4 clear goals",
      "Include metrics if possible",
      "Mention the approach or strategy",
    ],
    minSeconds: 20,
    idealSeconds: 40,
  ),

  InterviewQuestion(
    id: 'todo_topics',
    question: "What are the main tasks or topics you need to cover?",
    whyItMatters: "Breaking the project into manageable pieces.",
    exampleAnswer: "We need to conduct user interviews, create wireframes, get stakeholder approval, build out the new design in Figma, develop the front-end, test on multiple devices, and launch with monitoring.",
    proTips: [
      "List all major tasks",
      "Think chronologically",
      "Include review and testing",
    ],
    minSeconds: 30,
    idealSeconds: 60,
  ),
];

final projectScheduleVoiceTemplate = AppTemplate(
  id: 'project_schedule_voice',
  name: 'Project Schedule',
  tagline: 'Plan projects with clarity',
  description: 'Organize project strategy, tasks, and goals',
  category: TemplateCategory.productivity,
  icon: Icons.work_outline,
  gradientColors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
  sections: [
    TemplateSection(
      id: 'project_name',
      title: 'Project Name',
      hint: 'Name of the project',
      aiPrompt: 'Extract project name.',
      icon: Icons.title,
      required: true,
    ),
    TemplateSection(
      id: 'date_client',
      title: 'Date & Client',
      hint: 'Date and client info',
      aiPrompt: 'Extract date and client/stakeholder. Format: "Date: [Date]\\nClient: [Client]"',
      icon: Icons.calendar_today,
    ),
    TemplateSection(
      id: 'strategy',
      title: 'Strategy',
      hint: 'Approach and methodology',
      aiPrompt: 'Extract strategy and approach. Format as bullet points.',
      icon: Icons.psychology,
      multiLine: true,
    ),
    TemplateSection(
      id: 'todo',
      title: 'To Do List',
      hint: 'All project tasks',
      aiPrompt: 'Extract all tasks. Format as checkboxes: "- [ ] [Task]"',
      icon: Icons.checklist,
      multiLine: true,
      required: true,
    ),
    TemplateSection(
      id: 'topics',
      title: 'Subject/Topics',
      hint: 'Key areas or phases',
      aiPrompt: 'Extract main topics, phases, or subject areas. Format as checkboxes: "- [ ] [Topic]"',
      icon: Icons.topic,
      multiLine: true,
    ),
    TemplateSection(
      id: 'goals',
      title: 'Goals',
      hint: 'Success metrics',
      aiPrompt: 'Extract goals and success metrics. Format as bullet points.',
      icon: Icons.flag,
      multiLine: true,
    ),
    TemplateSection(
      id: 'notes',
      title: 'Notes',
      hint: 'Additional context',
      aiPrompt: 'Extract any additional notes or context.',
      icon: Icons.note,
      multiLine: true,
    ),
  ],
  interviewFlow: projectScheduleInterview,
  aiSystemPrompt: '''You are creating a project schedule.
Extract and organize:
- Project Name: Clear title
- Date & Client: Date and stakeholder info
- Strategy: Approach and methodology (bullets)
- To Do: All tasks (checkboxes)
- Topics: Main phases or subject areas (checkboxes)
- Goals: Success metrics (bullets)
- Notes: Additional context
Keep it organized and actionable.''',
);

// ============================================================
// 1️⃣2️⃣ WEEKLY REFLECTION
// ============================================================

const weeklyReflectionInterview = [
  InterviewQuestion(
    id: 'favorite_moments',
    question: "What were your favorite moments this week?",
    whyItMatters: "Celebrating wins reinforces positive patterns.",
    exampleAnswer: "My favorite moments were having dinner with my best friend on Tuesday, crushing my presentation at work on Wednesday, and the long hike I took on Saturday morning. I also loved finishing that book I've been reading.",
    proTips: [
      "Name 2-4 specific moments",
      "Mix personal and professional",
      "What made you smile?",
    ],
    minSeconds: 20,
    idealSeconds: 40,
  ),

  InterviewQuestion(
    id: 'gratitude_accomplishments',
    question: "What are you grateful for this week, and what's your key accomplishment?",
    whyItMatters: "Gratitude and achievement tracking builds momentum.",
    exampleAnswer: "I'm grateful for my supportive team at work, my health, and the beautiful weather we had. My key accomplishment was finally launching that project I've been working on for two months. It's live and getting positive feedback.",
    proTips: [
      "Name 2-3 gratitudes",
      "Pick ONE key accomplishment",
      "What are you most proud of?",
    ],
    minSeconds: 20,
    idealSeconds: 40,
  ),

  InterviewQuestion(
    id: 'do_more_less',
    question: "What do you want to do more of next week? And what do you want to do less of?",
    whyItMatters: "Reflection leads to intentional change.",
    exampleAnswer: "I want to do more exercising - I only worked out twice this week and I felt sluggish. I also want to read more. I want to do less mindless scrolling on social media and less staying up late.",
    proTips: [
      "Be specific about 'more'",
      "Be honest about 'less'",
      "What will you actually change?",
    ],
    minSeconds: 20,
    idealSeconds: 40,
  ),

  InterviewQuestion(
    id: 'selfcare_excited',
    question: "How will you take care of yourself next week, and what are you excited for?",
    whyItMatters: "Self-care and anticipation create positive momentum.",
    exampleAnswer: "I'll take care of myself by making sure I get 7 hours of sleep each night, meal prepping on Sunday so I eat healthy, and scheduling a massage on Wednesday. I'm excited for my friend's birthday party on Friday and starting a new project at work on Monday.",
    proTips: [
      "Name specific self-care actions",
      "What are you genuinely looking forward to?",
      "Set yourself up for a good week",
    ],
    minSeconds: 20,
    idealSeconds: 40,
  ),
];

final weeklyReflectionVoiceTemplate = AppTemplate(
  id: 'weekly_reflection_voice',
  name: 'Weekly Reflection',
  tagline: 'Reflect and reset each week',
  description: 'End-of-week review with gratitude and intentions',
  category: TemplateCategory.personal,
  icon: Icons.auto_awesome_outlined,
  gradientColors: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
  sections: [
    TemplateSection(
      id: 'week',
      title: 'Week',
      hint: 'Week date range',
      aiPrompt: 'Extract or generate week date range. Format: "Week of [Month DD - Month DD, YYYY]"',
      icon: Icons.calendar_today,
    ),
    TemplateSection(
      id: 'overview',
      title: 'Overview',
      hint: 'Brief week summary',
      aiPrompt: 'Extract brief week overview if mentioned, or generate from context.',
      icon: Icons.summarize,
    ),
    TemplateSection(
      id: 'favorite_moments',
      title: 'My Favorite Moments',
      hint: 'Week highlights',
      aiPrompt: 'Extract favorite moments. Format as bullet points with emotion.',
      icon: Icons.star,
      multiLine: true,
    ),
    TemplateSection(
      id: 'grateful_for',
      title: 'I\'m Most Grateful For',
      hint: 'This week\'s gratitudes',
      aiPrompt: 'Extract gratitudes. Format as bullet points.',
      icon: Icons.favorite,
      multiLine: true,
    ),
    TemplateSection(
      id: 'accomplishment',
      title: 'Key Accomplishment',
      hint: 'Your biggest win',
      aiPrompt: 'Extract the main accomplishment. Format as a proud, celebratory paragraph.',
      icon: Icons.emoji_events,
      multiLine: true,
    ),
    TemplateSection(
      id: 'do_more',
      title: 'I Plan To Do More',
      hint: 'Positive changes',
      aiPrompt: 'Extract what they want to do more of. Format as bullet points.',
      icon: Icons.trending_up,
      multiLine: true,
    ),
    TemplateSection(
      id: 'do_less',
      title: 'I Plan To Do Less',
      hint: 'Things to reduce',
      aiPrompt: 'Extract what they want to do less of. Format as bullet points.',
      icon: Icons.trending_down,
      multiLine: true,
    ),
    TemplateSection(
      id: 'selfcare',
      title: 'I\'ll Take Care Of Myself By',
      hint: 'Self-care intentions',
      aiPrompt: 'Extract self-care plans. Format as bullet points.',
      icon: Icons.spa,
      multiLine: true,
    ),
    TemplateSection(
      id: 'excited',
      title: 'I\'m So Excited For',
      hint: 'Looking forward to',
      aiPrompt: 'Extract what they\'re excited about. Format as an enthusiastic paragraph.',
      icon: Icons.celebration,
      multiLine: true,
    ),
  ],
  interviewFlow: weeklyReflectionInterview,
  aiSystemPrompt: '''You are helping someone reflect on their week.
Extract and organize with warmth and encouragement:
- Favorite Moments: Highlights (bullets)
- Grateful For: Gratitudes (bullets)
- Accomplishment: Main win (paragraph)
- Do More: Positive intentions (bullets)
- Do Less: Things to reduce (bullets)
- Self-Care: How they'll care for themselves (bullets)
- Excited For: What's next (enthusiastic paragraph)
Keep it positive, reflective, and forward-looking.''',
);

// ============================================================
// EXPORT ALL 12 TEMPLATES
// ============================================================

final List<AppTemplate> voicebubbleCoreTemplates = [
  meetingNotesVoiceTemplate,
  dailyJournalVoiceTemplate,
  gratitudeJournalVoiceTemplate,
  groceryListVoiceTemplate,
  recipeVoiceTemplate,
  habitTrackerVoiceTemplate,
  expenseTrackerVoiceTemplate,
  goalPlannerVoiceTemplate,
  todoListVoiceTemplate,
  quickNotesVoiceTemplate,
  projectScheduleVoiceTemplate,
  weeklyReflectionVoiceTemplate,
];
