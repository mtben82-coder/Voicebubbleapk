import '../models/template.dart';

class BuiltInTemplates {
  // ============================================================
  // 🎯 ACTIVE TEMPLATES (12 TOTAL - MATCHING VISUAL TEMPLATES)
  // ============================================================

  // TEMPLATE 1: MEETING NOTES ✅
  static const Template meetingNotes = Template(
    id: 'meeting_notes',
    name: 'Meeting Notes',
    description: 'Capture meeting details, decisions, and action items',
    category: TemplateCategory.productivity,
    icon: '📝',
    content: '''# Meeting Notes

**Date:** [Date]
**Page:** [Page]
**Meeting Information:** [Topic/Purpose]

## Attendees
- 

## Priorities
- 

## Action Items
- [ ] 
- [ ] 

## Notes
''',
    backgroundId: 'color_sky',
  );

  // TEMPLATE 2: DAILY JOURNAL ✅
  static const Template dailyJournal = Template(
    id: 'daily_journal',
    name: 'Daily Journal',
    description: 'Reflect on your day with gratitude and goals',
    category: TemplateCategory.personal,
    icon: '📔',
    content: '''# Daily Journal

**Date:** [Date]

## Daily Gratitude
[What I'm grateful for today]

## Daily Goals
- 
- 

## Daily Challenge
[Challenge I'm facing]

## Daily Affirmation
[Positive intention]

## Notes
''',
    backgroundId: 'gradient_peach',
  );

  // TEMPLATE 3: GRATITUDE JOURNAL ✅
  static const Template gratitudeJournal = Template(
    id: 'gratitude_journal',
    name: 'Gratitude Journal',
    description: 'Evening reflection and gratitude practice',
    category: TemplateCategory.personal,
    icon: '🙏',
    content: '''# Gratitude Journal - Evening Log

**Date:** [Date]

## The Best Part of the Day Was
[Your favorite moment]

## 3 Good Things That Happened Today
1. 
2. 
3. 

## People I'm Grateful For
- 
- 
- 

## 3 Things I'm Grateful For Today
1. 
2. 
3. 

## Tomorrow, I Look Forward To
[What excites you about tomorrow]
''',
    backgroundId: 'gradient_lavender',
  );

  // TEMPLATE 4: PROJECT PLANNER ✅
  static const Template projectPlan = Template(
    id: 'project_plan',
    name: 'Project Planner',
    description: 'Plan and organize project milestones',
    category: TemplateCategory.productivity,
    icon: '📊',
    content: '''# Project Planner

**Project Name:** [Name]
**Date:** [Date]
**Client:** [Client Name]

## Strategy
- 
- 
- 

## To Do List
- [ ] 
- [ ] 
- [ ] 
- [ ] 
- [ ] 

## Subject/Topics
- [ ] 
- [ ] 
- [ ] 

## Goals
- 
- 
- 

## Notes
[Additional project notes]
''',
    backgroundId: 'color_blue',
  );

  // TEMPLATE 5: WEEKLY REFLECTION ✅
  static const Template weeklyReview = Template(
    id: 'weekly_review',
    name: 'Weekly Reflection',
    description: 'Reflect on the week and plan ahead',
    category: TemplateCategory.productivity,
    icon: '📅',
    content: '''# Weekly Reflection

**Week:** [Week of Date]
**Overview:** [Brief summary]

## My Favorite Moments
- 
- 
- 

## I'm Most Grateful For
- 
- 
- 

## Key Accomplishment
[Your biggest win this week]

## I Plan To Do More
- 

## I Plan To Do Less
- 

## I'll Take Care Of Myself By
- 

## I'm So Excited For
[What you're looking forward to]
''',
    backgroundId: 'gradient_lavender',
  );

  // TEMPLATE 6: GROCERY LIST ✅
  static const Template groceryList = Template(
    id: 'grocery_list',
    name: 'Grocery List',
    description: 'Organize your shopping needs by category',
    category: TemplateCategory.personal,
    icon: '🛒',
    content: '''# Grocery List

**Week of:** [Date]

## Dairy
- [ ] 
- [ ] 
- [ ] 

## Meat & Seafood
- [ ] 
- [ ] 
- [ ] 

## Fruits & Veggies
- [ ] 
- [ ] 
- [ ] 

## Frozen
- [ ] 
- [ ] 
- [ ] 

## Drinks
- [ ] 
- [ ] 

## Others
- [ ] 
- [ ] 
''',
    backgroundId: 'color_mint',
  );

  // TEMPLATE 7: RECIPE ✅
  static const Template recipeTemplate = Template(
    id: 'recipe',
    name: 'Recipe',
    description: 'Save your favorite recipes',
    category: TemplateCategory.personal,
    icon: '🍳',
    content: '''# Recipe

**Title:** [Recipe Name]
**Prep Time:** [X minutes]
**Cook Time:** [X minutes]
**Servings:** [X]

## Ingredients
- 
- 
- 

## Directions
1. 
2. 
3. 
4. 

## Notes
[Tips and variations]
''',
    backgroundId: 'color_peach',
  );

  // TEMPLATE 8: HABIT TRACKER ✅
  static const Template habitTracker = Template(
    id: 'habit_tracker',
    name: 'Habit Tracker',
    description: 'Track daily habits and build consistency',
    category: TemplateCategory.health,
    icon: '✅',
    content: '''# Habit Tracker

**Week of:** [Date Range]

## Habits to Track
| Habit | Mon | Tue | Wed | Thu | Fri | Sat | Sun |
|-------|-----|-----|-----|-----|-----|-----|-----|
| [Habit 1] | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| [Habit 2] | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| [Habit 3] | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| [Habit 4] | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| [Habit 5] | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |

## Notes
[Weekly reflection on habits]
''',
    backgroundId: 'gradient_mint',
  );

  // TEMPLATE 9: EXPENSE TRACKER ✅
  static const Template expenseTracker = Template(
    id: 'expense_tracker',
    name: 'Expense Tracker',
    description: 'Track your monthly expenses',
    category: TemplateCategory.productivity,
    icon: '💰',
    content: '''# Expense Tracker

**Month of:** [Month Year]

| Date | Description | Category | Amount |
|------|-------------|----------|--------|
| [MM/DD] | [Item] | [Category] | \$[Amount] |
| [MM/DD] | [Item] | [Category] | \$[Amount] |
| [MM/DD] | [Item] | [Category] | \$[Amount] |
| [MM/DD] | [Item] | [Category] | \$[Amount] |
| [MM/DD] | [Item] | [Category] | \$[Amount] |

## Total
**\$[Sum of all expenses]**

## Notes
[Spending insights]
''',
    backgroundId: 'color_mint',
  );

  // TEMPLATE 10: GOAL PLANNER ✅
  static const Template goalPlanner = Template(
    id: 'goal_planner',
    name: 'Goal Planner',
    description: 'Set and track your goals with action steps',
    category: TemplateCategory.productivity,
    icon: '🎯',
    content: '''# Goal Planner

**Created:** [Date]
**To Achieve By:** [Target Date]
**Achieved:** ☐

## Goal
[Your specific goal]

## Action Steps
1. 
2. 
3. 
4. 
5. 

## Motivation
[Why this goal matters to you]

## Strategy
[How you'll approach this]

## Progress Tracker
[Track your progress weekly]

## Reward
[What you'll reward yourself with]
''',
    backgroundId: 'gradient_ocean',
  );

  // TEMPLATE 11: TO DO LIST ✅
  static const Template todoList = Template(
    id: 'todo_list',
    name: 'To Do List',
    description: 'Organize daily tasks and priorities',
    category: TemplateCategory.productivity,
    icon: '✔️',
    content: '''# To Do List

**Date:** [Date]

## To Do
- [ ] 
- [ ] 
- [ ] 
- [ ] 
- [ ] 
- [ ] 
- [ ] 
- [ ] 

## Priorities
1. 
2. 
3. 

## Notes
[Additional reminders]

## Reminder
[Important thing to remember]

## Tomorrow
[Tasks for tomorrow]
''',
    backgroundId: 'gradient_pink',
  );

  // TEMPLATE 12: QUICK NOTES ✅
  static const Template quickNotes = Template(
    id: 'quick_notes',
    name: 'Quick Notes',
    description: 'Capture thoughts and ideas quickly',
    category: TemplateCategory.personal,
    icon: '📌',
    content: '''# Notes

## Main Notes
[Your main thoughts and notes here]

---

## Quick Ideas
💡 [Idea 1]

💡 [Idea 2]

💡 [Idea 3]
''',
    backgroundId: 'color_white',
  );

  // ============================================================
  // 📦 COMMENTED OUT - NOT MATCHING VISUAL TEMPLATES
  // ============================================================
  
  /*
  static const Template workoutLog = Template(
    id: 'workout_log',
    name: 'Workout Log',
    description: 'Track your fitness routine',
    category: TemplateCategory.health,
    icon: '💪',
    content: '''# Workout Log - [Date]

## Today's Focus: [Muscle Group/Cardio]

### Warm-up (10 min)
- 

### Main Workout
**Exercise 1:** [Name]
- Sets: 3
- Reps: 12
- Weight: 

**Exercise 2:** [Name]
- Sets: 3
- Reps: 12
- Weight: 

**Exercise 3:** [Name]
- Sets: 3
- Reps: 12
- Weight: 

### Cool Down
- 

## Notes
- Energy Level: /10
- Form Check: 
''',
    backgroundId: 'gradient_neon',
  );

  static const Template travelPlanner = Template(
    id: 'travel_planner',
    name: 'Travel Planner',
    description: 'Organize your trip details',
    category: TemplateCategory.personal,
    icon: '✈️',
    content: '''# Trip to [Destination]

**Dates:** [Start] - [End]
**Budget:** \$[Amount]

## Itinerary
### Day 1 - [Date]
- Morning: 
- Afternoon: 
- Evening: 

### Day 2 - [Date]
- Morning: 
- Afternoon: 
- Evening: 

## Packing List
- [ ] 
- [ ] 
- [ ] 

## Bookings
- Flight: 
- Hotel: 
- Activities: 

## Important Notes
- 
''',
    backgroundId: 'ocean',
  );

  static const Template bookNotes = Template(
    id: 'book_notes',
    name: 'Book Notes',
    description: 'Capture insights from your reading',
    category: TemplateCategory.creative,
    icon: '📚',
    content: '''# Book Notes: [Title]

**Author:** [Name]
**Genre:** [Type]
**Started:** [Date]
**Finished:** [Date]

## Summary
[Brief overview]

## Key Takeaways
1. 
2. 
3. 

## Favorite Quotes
> ""

> ""

## My Thoughts
[Personal reflection]

## Rating: ⭐⭐⭐⭐⭐

## Would I Recommend? 
[Yes/No and why]
''',
    backgroundId: 'gradient_purple',
  );

  static const Template brainstorm = Template(
    id: 'brainstorm',
    name: 'Brainstorm',
    description: 'Capture creative ideas freely',
    category: TemplateCategory.creative,
    icon: '💡',
    content: '''# Brainstorm: [Topic]

## Initial Thoughts
- 
- 
- 

## Wild Ideas (No Judgment!)
- 
- 
- 

## Connections & Patterns
- 

## Most Promising Ideas
1. 
2. 
3. 

## Next Steps
- [ ] 
- [ ] 
''',
    backgroundId: 'gradient_pink',
  );

  static const Template businessPlan = Template(
    id: 'business_plan',
    name: 'Business Plan',
    description: 'Outline your business strategy',
    category: TemplateCategory.business,
    icon: '💼',
    content: '''# Business Plan: [Business Name]

## Executive Summary
[Brief overview]

## Mission Statement
[Your purpose]

## Target Market
- Who: 
- Needs: 
- Size: 

## Products/Services
- 
- 

## Marketing Strategy
- 
- 

## Financial Projections
- Startup Costs: 
- Revenue Goals: 

## Key Milestones
1. 
2. 
3. 

## Challenges & Solutions
- 
''',
    backgroundId: 'color_dark',
  );

  static const Template pitchDeck = Template(
    id: 'pitch_deck',
    name: 'Pitch Deck',
    description: 'Structure your business pitch',
    category: TemplateCategory.business,
    icon: '🎤',
    content: '''# Pitch Deck: [Company Name]

## Problem
[What problem are you solving?]

## Solution
[Your unique solution]

## Market Opportunity
- Market Size: 
- Growth Rate: 

## Product Demo
[Key features]

## Business Model
[How do you make money?]

## Traction
- Users: 
- Revenue: 
- Growth: 

## Competition
[Who else does this? Why are you better?]

## Team
[Who's building this?]

## Ask
[What do you need?]
''',
    backgroundId: 'gradient_ocean',
  );

  static const Template prospectOutreach = Template(
    id: 'prospect_outreach',
    name: 'Sales Outreach',
    description: 'Template for reaching out to prospects',
    category: TemplateCategory.business,
    icon: '📧',
    content: '''# Outreach: [Prospect Name]

## Research Notes
- Company: 
- Role: 
- Pain Points: 
- Recent News: 

## Email Draft
**Subject:** [Compelling subject line]

Hi [Name],

[Opening - show you did research]

[Problem they likely face]

[How you can help]

[Soft call to action]

Best,
[Your name]

## Follow-up Sequence
- Day 3: 
- Day 7: 
- Day 14: 
''',
    backgroundId: 'color_blue',
  );

  static const Template dreamLog = Template(
    id: 'dream_log',
    name: 'Dream Log',
    description: 'Record and analyze your dreams',
    category: TemplateCategory.personal,
    icon: '🌙',
    content: '''# Dream Log - [Date]

## Dream Summary
[What happened?]

## Key Symbols
- 
- 
- 

## Emotions Felt
- 

## People/Places
- 
- 

## Recurring Themes
- 

## Interpretation
[What might this mean?]

## Clarity: [Vivid/Hazy/Fragments]
''',
    backgroundId: 'space',
  );

  static const Template moodTracker = Template(
    id: 'mood_tracker',
    name: 'Mood Tracker',
    description: 'Track your emotional wellbeing',
    category: TemplateCategory.health,
    icon: '😊',
    content: '''# Mood Tracker - [Date]

## Current Mood: [😊/😐/😔]

## Energy Level: [1-10]

## Sleep Quality: [1-10]

## What Went Well
- 
- 

## Challenges
- 

## Triggers
[What affected my mood?]
- 

## Coping Strategies Used
- 

## Gratitude
1. 
2. 
3. 

## Tomorrow's Intention
''',
    backgroundId: 'gradient_lavender',
  );

  static const Template blogOutline = Template(
    id: 'blog_outline',
    name: 'Blog Outline',
    description: 'Structure your blog post',
    category: TemplateCategory.creative,
    icon: '✍️',
    content: '''# Blog Post: [Title]

## Target Audience
[Who is this for?]

## Main Takeaway
[What will readers learn?]

## Hook/Opening
[Grab attention]

## Outline
1. **Introduction**
   - 

2. **Main Point 1**
   - 
   - 

3. **Main Point 2**
   - 
   - 

4. **Main Point 3**
   - 
   - 

5. **Conclusion**
   - 
   - Call to action: 

## SEO Keywords
- 
- 

## Related Topics to Link
- 
''',
    backgroundId: 'color_lavender',
  );

  static const Template problemSolving = Template(
    id: 'problem_solving',
    name: 'Problem Solving',
    description: 'Work through complex problems',
    category: TemplateCategory.productivity,
    icon: '🧩',
    content: '''# Problem Solving: [Problem]

## Problem Definition
[What exactly is the issue?]

## Why It Matters
[Impact if not solved]

## Current Situation
[Facts and data]

## Root Causes
1. 
2. 
3. 

## Possible Solutions
**Option 1:**
- Pros: 
- Cons: 
- Effort: 

**Option 2:**
- Pros: 
- Cons: 
- Effort: 

**Option 3:**
- Pros: 
- Cons: 
- Effort: 

## Chosen Solution
[Which and why?]

## Action Plan
1. 
2. 
3. 

## Success Metrics
[How will you know it worked?]
''',
    backgroundId: 'color_orange',
  );

  static const Template oneOnOneAgenda = Template(
    id: 'one_on_one',
    name: '1-on-1 Agenda',
    description: 'Structured template for 1-on-1 meetings',
    category: TemplateCategory.business,
    icon: '👥',
    content: '''# 1-on-1: [Name] - [Date]

## How are you doing?
[Personal check-in]

## Recent Wins
- 
- 

## Challenges/Blockers
- 

## Project Updates
- 
- 

## Career Development
[Goals, growth areas]

## Feedback
**For you:**

**For me:**

## Action Items
- [ ] 
- [ ] 

## Next Meeting: [Date]
''',
    backgroundId: 'color_sky',
  );

  static const Template eventPlanning = Template(
    id: 'event_planning',
    name: 'Event Planning',
    description: 'Organize all event details',
    category: TemplateCategory.personal,
    icon: '🎉',
    content: '''# Event: [Name]

**Date:** [Date]
**Time:** [Start - End]
**Location:** [Venue]
**Expected Guests:** [Number]

## Checklist
### 8 Weeks Before
- [ ] Set date and budget
- [ ] Book venue
- [ ] Create guest list

### 4 Weeks Before
- [ ] Send invitations
- [ ] Plan menu
- [ ] Book vendors

### 1 Week Before
- [ ] Confirm RSVPs
- [ ] Final headcount
- [ ] Prepare decorations

### Day Of
- [ ] Set up venue
- [ ] Coordinate vendors
- [ ] Enjoy!

## Budget
- Venue: \$
- Food: \$
- Decorations: \$
- Other: \$
**Total:** \$

## Notes
''',
    backgroundId: 'gradient_pink',
  );
  */

  // ============================================================
  // ALL TEMPLATES LIST (ACTIVE ONLY)
  // ============================================================
  
  static const List<Template> all = [
    meetingNotes,
    dailyJournal,
    gratitudeJournal,
    projectPlan,
    weeklyReview,
    groceryList,
    recipeTemplate,
    habitTracker,
    expenseTracker,
    goalPlanner,
    todoList,
    quickNotes,
  ];

  // Get templates by category
  static List<Template> getByCategory(TemplateCategory category) {
    return all.where((t) => t.category == category).toList();
  }

  // Get template by ID
  static Template? getById(String id) {
    try {
      return all.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }
}
