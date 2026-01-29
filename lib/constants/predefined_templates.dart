import '../models/document_template.dart';

// ============================================================
//        PREDEFINED TEMPLATES - THE PRODUCTIVITY ARSENAL
// ============================================================
//
// 6 legendary templates that will make users abandon
// every other writing tool on the planet.
//
// ============================================================

class PredefinedTemplates {
  static List<DocumentTemplate> getAllTemplates() {
    return [
      _blogPostTemplate(),
      _bookChapterTemplate(),
      _meetingNotesTemplate(),
      _businessEmailTemplate(),
      _scriptDialogueTemplate(),
      _journalEntryTemplate(),
    ];
  }

  static DocumentTemplate _blogPostTemplate() {
    return DocumentTemplate(
      id: 'blog_post_ultimate',
      name: 'Blog Post',
      description: 'Create engaging blog posts that captivate readers from start to finish',
      category: 'writing',
      icon: '📝',
      estimatedTimeMinutes: 20,
      wordCountEstimate: 800,
      tags: ['blog', 'content', 'writing', 'marketing'],
      structure: '''# [Voice: Blog Title]

## Introduction
[Voice: Hook your readers with an engaging opening. What problem are you solving or what story are you telling?]

## Main Content

### Key Point 1
[Voice: Explain your first main point with details and examples]

### Key Point 2  
[Voice: Share your second key insight with supporting evidence]

### Key Point 3
[Voice: Present your third important point with practical tips]

## Conclusion
[Voice: Wrap up with a powerful conclusion and call-to-action]

---
*Published with VoiceBubble - The Voice-First Writing Studio*''',
      voicePrompts: [
        VoicePrompt(
          id: 'blog_title',
          placeholder: '[Voice: Blog Title]',
          prompt: 'What\'s the title of your blog post? Make it catchy and specific.',
          example: 'Say something like: "5 Proven Strategies to Double Your Productivity"',
          estimatedSeconds: 10,
        ),
        VoicePrompt(
          id: 'blog_intro',
          placeholder: '[Voice: Hook your readers with an engaging opening. What problem are you solving or what story are you telling?]',
          prompt: 'Start with a hook that grabs attention. What problem does your post solve?',
          example: 'Try: "Have you ever felt overwhelmed by your endless to-do list? You\'re not alone..."',
          estimatedSeconds: 45,
        ),
        VoicePrompt(
          id: 'blog_point1',
          placeholder: '[Voice: Explain your first main point with details and examples]',
          prompt: 'Share your first key insight. Be specific and include examples.',
          example: 'Explain a strategy, tell a story, or share research that supports your point.',
          estimatedSeconds: 60,
        ),
        VoicePrompt(
          id: 'blog_point2',
          placeholder: '[Voice: Share your second key insight with supporting evidence]',
          prompt: 'What\'s your second main point? Back it up with evidence or examples.',
          example: 'Share another strategy, case study, or personal experience.',
          estimatedSeconds: 60,
        ),
        VoicePrompt(
          id: 'blog_point3',
          placeholder: '[Voice: Present your third important point with practical tips]',
          prompt: 'Give readers actionable advice they can implement immediately.',
          example: 'Share specific steps, tools, or techniques they can use right away.',
          estimatedSeconds: 60,
        ),
        VoicePrompt(
          id: 'blog_conclusion',
          placeholder: '[Voice: Wrap up with a powerful conclusion and call-to-action]',
          prompt: 'Summarize your key points and tell readers what to do next.',
          example: 'Say: "To recap, we covered X, Y, and Z. Now I want you to try..."',
          estimatedSeconds: 45,
        ),
      ],
    );
  }

  static DocumentTemplate _bookChapterTemplate() {
    return DocumentTemplate(
      id: 'book_chapter_pro',
      name: 'Book Chapter',
      description: 'Structure compelling book chapters with professional narrative flow',
      category: 'writing',
      icon: '📖',
      estimatedTimeMinutes: 45,
      wordCountEstimate: 2500,
      tags: ['book', 'chapter', 'writing', 'storytelling'],
      isPremium: true,
      structure: '''# Chapter [Voice: Chapter Number]: [Voice: Chapter Title]

## Opening Scene
[Voice: Set the scene or introduce the chapter's main concept. Draw readers in immediately.]

## Development
[Voice: Develop your main ideas, characters, or arguments. This is the meat of your chapter.]

### Key Scene/Concept 1
[Voice: First major scene, idea, or turning point]

### Key Scene/Concept 2
[Voice: Second major development or supporting idea]

### Key Scene/Concept 3
[Voice: Third important element or climactic moment]

## Resolution/Transition
[Voice: Wrap up this chapter and create a bridge to the next one. Leave readers wanting more.]

---
*Chapter word count: ~2,500 words*''',
      voicePrompts: [
        VoicePrompt(
          id: 'chapter_number',
          placeholder: '[Voice: Chapter Number]',
          prompt: 'What chapter number is this?',
          example: 'Say: "Chapter 5" or "One" or "The Beginning"',
          estimatedSeconds: 5,
        ),
        VoicePrompt(
          id: 'chapter_title',
          placeholder: '[Voice: Chapter Title]',
          prompt: 'What\'s the title of this chapter?',
          example: 'Choose something intriguing like "The Unexpected Discovery" or "Breaking Point"',
          estimatedSeconds: 10,
        ),
        VoicePrompt(
          id: 'chapter_opening',
          placeholder: '[Voice: Set the scene or introduce the chapter\'s main concept. Draw readers in immediately.]',
          prompt: 'Open with a compelling scene or concept that hooks the reader.',
          example: 'Start with action, dialogue, or an intriguing statement that makes them want to keep reading.',
          estimatedSeconds: 120,
        ),
        VoicePrompt(
          id: 'chapter_development',
          placeholder: '[Voice: Develop your main ideas, characters, or arguments. This is the meat of your chapter.]',
          prompt: 'Develop the main content of your chapter. What happens next?',
          example: 'Advance the plot, develop characters, or explore your main ideas in depth.',
          estimatedSeconds: 180,
        ),
        VoicePrompt(
          id: 'chapter_scene1',
          placeholder: '[Voice: First major scene, idea, or turning point]',
          prompt: 'Describe the first key moment or concept in this chapter.',
          example: 'This could be a crucial conversation, revelation, or important point you want to make.',
          estimatedSeconds: 120,
        ),
        VoicePrompt(
          id: 'chapter_scene2',
          placeholder: '[Voice: Second major development or supporting idea]',
          prompt: 'What\'s the second important element of this chapter?',
          example: 'Continue building tension, developing ideas, or advancing your narrative.',
          estimatedSeconds: 120,
        ),
        VoicePrompt(
          id: 'chapter_scene3',
          placeholder: '[Voice: Third important element or climactic moment]',
          prompt: 'Bring this chapter to its climactic moment or key revelation.',
          example: 'This should be the peak of tension or the most important insight of the chapter.',
          estimatedSeconds: 120,
        ),
        VoicePrompt(
          id: 'chapter_resolution',
          placeholder: '[Voice: Wrap up this chapter and create a bridge to the next one. Leave readers wanting more.]',
          prompt: 'How does this chapter end? Create a transition to the next chapter.',
          example: 'Resolve immediate tensions but create new questions or cliffhangers for the next chapter.',
          estimatedSeconds: 90,
        ),
      ],
    );
  }

  static DocumentTemplate _meetingNotesTemplate() {
    return DocumentTemplate(
      id: 'meeting_notes_pro',
      name: 'Meeting Notes',
      description: 'Capture actionable meeting notes that drive results',
      category: 'business',
      icon: '🤝',
      estimatedTimeMinutes: 10,
      wordCountEstimate: 400,
      tags: ['meeting', 'notes', 'business', 'productivity'],
      structure: '''# Meeting Notes: [Voice: Meeting Title]

**Date:** ${DateTime.now().toString().split(' ')[0]}
**Attendees:** [Voice: Who was in the meeting?]
**Duration:** [Voice: How long was the meeting?]

## Meeting Purpose
[Voice: What was the main goal or purpose of this meeting?]

## Key Discussion Points
[Voice: What were the main topics discussed? Cover the most important conversations.]

## Decisions Made
[Voice: What decisions were finalized during the meeting?]

## Action Items
[Voice: What specific tasks need to be completed? Who is responsible for each?]

## Next Steps
[Voice: What happens next? When is the follow-up meeting?]

## Additional Notes
[Voice: Any other important information or observations?]

---
*Meeting notes captured with VoiceBubble*''',
      voicePrompts: [
        VoicePrompt(
          id: 'meeting_title',
          placeholder: '[Voice: Meeting Title]',
          prompt: 'What was this meeting about?',
          example: 'Say: "Weekly Team Standup" or "Q4 Planning Session"',
          estimatedSeconds: 10,
        ),
        VoicePrompt(
          id: 'meeting_attendees',
          placeholder: '[Voice: Who was in the meeting?]',
          prompt: 'List the people who attended the meeting.',
          example: 'Say: "John, Sarah, Mike from marketing, and Lisa from design"',
          estimatedSeconds: 15,
        ),
        VoicePrompt(
          id: 'meeting_duration',
          placeholder: '[Voice: How long was the meeting?]',
          prompt: 'How long did the meeting last?',
          example: 'Say: "1 hour" or "30 minutes" or "2 hours"',
          estimatedSeconds: 5,
        ),
        VoicePrompt(
          id: 'meeting_purpose',
          placeholder: '[Voice: What was the main goal or purpose of this meeting?]',
          prompt: 'Explain why this meeting was called and what you hoped to accomplish.',
          example: 'Say: "We met to review the quarterly results and plan for next quarter"',
          estimatedSeconds: 30,
        ),
        VoicePrompt(
          id: 'meeting_discussion',
          placeholder: '[Voice: What were the main topics discussed? Cover the most important conversations.]',
          prompt: 'Summarize the key topics and conversations that took place.',
          example: 'Cover the main agenda items and any important discussions that came up.',
          estimatedSeconds: 90,
        ),
        VoicePrompt(
          id: 'meeting_decisions',
          placeholder: '[Voice: What decisions were finalized during the meeting?]',
          prompt: 'List any concrete decisions that were made.',
          example: 'Say: "We decided to launch the new feature next month and hire two more developers"',
          estimatedSeconds: 45,
        ),
        VoicePrompt(
          id: 'meeting_actions',
          placeholder: '[Voice: What specific tasks need to be completed? Who is responsible for each?]',
          prompt: 'List the action items and who is responsible for each one.',
          example: 'Say: "John will update the budget by Friday, Sarah will contact the vendor"',
          estimatedSeconds: 60,
        ),
        VoicePrompt(
          id: 'meeting_next_steps',
          placeholder: '[Voice: What happens next? When is the follow-up meeting?]',
          prompt: 'Explain the next steps and any follow-up meetings planned.',
          example: 'Say: "We\'ll meet again next Tuesday to review progress on these action items"',
          estimatedSeconds: 30,
        ),
        VoicePrompt(
          id: 'meeting_additional',
          placeholder: '[Voice: Any other important information or observations?]',
          prompt: 'Add any other notes, observations, or important information.',
          example: 'Include anything else that was mentioned or that you want to remember.',
          estimatedSeconds: 30,
          isRequired: false,
        ),
      ],
    );
  }

  static DocumentTemplate _businessEmailTemplate() {
    return DocumentTemplate(
      id: 'business_email_pro',
      name: 'Business Email',
      description: 'Craft professional emails that get results and drive action',
      category: 'business',
      icon: '📧',
      estimatedTimeMinutes: 5,
      wordCountEstimate: 200,
      tags: ['email', 'business', 'communication', 'professional'],
      structure: '''**To:** [Voice: Who are you sending this to?]
**Subject:** [Voice: Email subject line]

Dear [Voice: How do you address the recipient?],

[Voice: Opening greeting and context. Why are you writing?]

[Voice: Main message. What do you need to communicate or request?]

[Voice: Supporting details or additional information if needed.]

[Voice: Clear call to action. What do you want them to do next?]

[Voice: Professional closing and next steps.]

Best regards,
[Your name]

---
*Sent with VoiceBubble - Professional Communication Made Easy*''',
      voicePrompts: [
        VoicePrompt(
          id: 'email_recipient',
          placeholder: '[Voice: Who are you sending this to?]',
          prompt: 'Who is receiving this email?',
          example: 'Say: "john.smith@company.com" or "Sarah Johnson"',
          estimatedSeconds: 10,
        ),
        VoicePrompt(
          id: 'email_subject',
          placeholder: '[Voice: Email subject line]',
          prompt: 'What\'s the subject line for this email?',
          example: 'Be specific: "Meeting Request for Project Review" or "Follow-up on Proposal"',
          estimatedSeconds: 15,
        ),
        VoicePrompt(
          id: 'email_greeting',
          placeholder: '[Voice: How do you address the recipient?]',
          prompt: 'How should you address the recipient?',
          example: 'Say: "Mr. Johnson" or "Sarah" or "Team" depending on formality',
          estimatedSeconds: 5,
        ),
        VoicePrompt(
          id: 'email_opening',
          placeholder: '[Voice: Opening greeting and context. Why are you writing?]',
          prompt: 'Start with a greeting and explain why you\'re writing.',
          example: 'Say: "I hope this email finds you well. I\'m writing to follow up on our conversation about..."',
          estimatedSeconds: 30,
        ),
        VoicePrompt(
          id: 'email_main_message',
          placeholder: '[Voice: Main message. What do you need to communicate or request?]',
          prompt: 'What\'s the main point of your email? Be clear and direct.',
          example: 'State your request, share information, or make your main point clearly.',
          estimatedSeconds: 45,
        ),
        VoicePrompt(
          id: 'email_details',
          placeholder: '[Voice: Supporting details or additional information if needed.]',
          prompt: 'Add any supporting details or context that would be helpful.',
          example: 'Include relevant dates, numbers, or background information.',
          estimatedSeconds: 30,
          isRequired: false,
        ),
        VoicePrompt(
          id: 'email_action',
          placeholder: '[Voice: Clear call to action. What do you want them to do next?]',
          prompt: 'What specific action do you want them to take?',
          example: 'Say: "Please let me know your availability for next week" or "I\'d appreciate your feedback by Friday"',
          estimatedSeconds: 20,
        ),
        VoicePrompt(
          id: 'email_closing',
          placeholder: '[Voice: Professional closing and next steps.]',
          prompt: 'How do you want to close the email?',
          example: 'Say: "Thank you for your time. I look forward to hearing from you soon."',
          estimatedSeconds: 15,
        ),
      ],
    );
  }

  static DocumentTemplate _scriptDialogueTemplate() {
    return DocumentTemplate(
      id: 'script_dialogue_creative',
      name: 'Script/Dialogue',
      description: 'Write compelling scripts and dialogue for any creative project',
      category: 'creative',
      icon: '🎬',
      estimatedTimeMinutes: 30,
      wordCountEstimate: 1000,
      tags: ['script', 'dialogue', 'creative', 'storytelling'],
      structure: '''# [Voice: Script Title]

**Genre:** [Voice: What type of script is this?]
**Setting:** [Voice: Where and when does this take place?]

## Scene 1: [Voice: Scene description]

*[Voice: Set the scene - describe the location, time, and atmosphere]*

**[Voice: Character 1 name]:** [Voice: What does this character say first?]

**[Voice: Character 2 name]:** [Voice: How does the second character respond?]

*[Voice: Action or stage direction if needed]*

**[Voice: Character 1 name]:** [Voice: Continue the dialogue - what happens next?]

**[Voice: Character 2 name]:** [Voice: Keep the conversation flowing naturally]

## Scene 2: [Voice: Next scene description]

*[Voice: Describe the new scene or continuation]*

[Voice: Continue with more dialogue and action as needed]

## Notes
[Voice: Any additional notes about character motivations, themes, or production notes]

---
*Script created with VoiceBubble - Bring Your Stories to Life*''',
      voicePrompts: [
        VoicePrompt(
          id: 'script_title',
          placeholder: '[Voice: Script Title]',
          prompt: 'What\'s the title of your script?',
          example: 'Say: "The Coffee Shop Encounter" or "Family Reunion"',
          estimatedSeconds: 10,
        ),
        VoicePrompt(
          id: 'script_genre',
          placeholder: '[Voice: What type of script is this?]',
          prompt: 'What genre or type of script are you writing?',
          example: 'Say: "Comedy short film" or "Drama scene" or "Podcast dialogue"',
          estimatedSeconds: 10,
        ),
        VoicePrompt(
          id: 'script_setting',
          placeholder: '[Voice: Where and when does this take place?]',
          prompt: 'Describe the setting - where and when does this happen?',
          example: 'Say: "A busy coffee shop in downtown Manhattan, present day" or "A family kitchen, Sunday morning"',
          estimatedSeconds: 20,
        ),
        VoicePrompt(
          id: 'scene1_description',
          placeholder: '[Voice: Scene description]',
          prompt: 'Describe the first scene briefly.',
          example: 'Say: "The Meeting" or "Opening Confrontation" or "First Encounter"',
          estimatedSeconds: 10,
        ),
        VoicePrompt(
          id: 'scene1_setup',
          placeholder: '[Voice: Set the scene - describe the location, time, and atmosphere]',
          prompt: 'Set the scene with more detail. What\'s the atmosphere?',
          example: 'Describe the mood, lighting, sounds, and what characters are doing when scene opens.',
          estimatedSeconds: 45,
        ),
        VoicePrompt(
          id: 'character1_name',
          placeholder: '[Voice: Character 1 name]',
          prompt: 'What\'s the name of your first character?',
          example: 'Say: "SARAH" or "DETECTIVE JONES" or "MOM"',
          estimatedSeconds: 5,
        ),
        VoicePrompt(
          id: 'character1_line1',
          placeholder: '[Voice: What does this character say first?]',
          prompt: 'What\'s the first line of dialogue? Make it engaging.',
          example: 'Start with something that hooks the audience or reveals character.',
          estimatedSeconds: 30,
        ),
        VoicePrompt(
          id: 'character2_name',
          placeholder: '[Voice: Character 2 name]',
          prompt: 'What\'s the name of your second character?',
          example: 'Say: "MIKE" or "THE STRANGER" or "DAD"',
          estimatedSeconds: 5,
        ),
        VoicePrompt(
          id: 'character2_response',
          placeholder: '[Voice: How does the second character respond?]',
          prompt: 'How does the second character respond to the first line?',
          example: 'Show their personality and relationship through their response.',
          estimatedSeconds: 30,
        ),
        VoicePrompt(
          id: 'dialogue_continuation',
          placeholder: '[Voice: Continue the dialogue - what happens next?]',
          prompt: 'Continue the conversation. What develops between these characters?',
          example: 'Build tension, reveal information, or develop their relationship through dialogue.',
          estimatedSeconds: 120,
        ),
      ],
    );
  }

  static DocumentTemplate _journalEntryTemplate() {
    return DocumentTemplate(
      id: 'journal_entry_personal',
      name: 'Journal Entry',
      description: 'Reflect and capture your thoughts with guided journaling prompts',
      category: 'personal',
      icon: '📔',
      estimatedTimeMinutes: 15,
      wordCountEstimate: 500,
      tags: ['journal', 'reflection', 'personal', 'mindfulness'],
      structure: '''# Journal Entry - ${DateTime.now().toString().split(' ')[0]}

## Today's Mood
[Voice: How are you feeling today? Describe your overall mood and energy level.]

## What Happened Today
[Voice: What were the key events, conversations, or experiences from today?]

## Gratitude
[Voice: What are you grateful for today? Name at least three things.]

## Challenges & Growth
[Voice: What challenges did you face? What did you learn about yourself?]

## Tomorrow's Intentions
[Voice: What do you want to focus on tomorrow? Set positive intentions.]

## Free Thoughts
[Voice: Any other thoughts, dreams, or reflections you want to capture?]

---
*Personal reflection captured with VoiceBubble*''',
      voicePrompts: [
        VoicePrompt(
          id: 'journal_mood',
          placeholder: '[Voice: How are you feeling today? Describe your overall mood and energy level.]',
          prompt: 'Take a moment to check in with yourself. How are you feeling right now?',
          example: 'Describe your emotions, energy level, and overall state of mind.',
          estimatedSeconds: 45,
        ),
        VoicePrompt(
          id: 'journal_events',
          placeholder: '[Voice: What were the key events, conversations, or experiences from today?]',
          prompt: 'Reflect on your day. What stood out? What was significant?',
          example: 'Share the highlights, important conversations, or meaningful moments from today.',
          estimatedSeconds: 90,
        ),
        VoicePrompt(
          id: 'journal_gratitude',
          placeholder: '[Voice: What are you grateful for today? Name at least three things.]',
          prompt: 'Practice gratitude. What are you thankful for today?',
          example: 'Think of people, experiences, opportunities, or simple pleasures you appreciate.',
          estimatedSeconds: 60,
        ),
        VoicePrompt(
          id: 'journal_challenges',
          placeholder: '[Voice: What challenges did you face? What did you learn about yourself?]',
          prompt: 'Reflect on any difficulties or challenges. What did they teach you?',
          example: 'Consider obstacles you overcame and insights you gained about yourself.',
          estimatedSeconds: 75,
        ),
        VoicePrompt(
          id: 'journal_intentions',
          placeholder: '[Voice: What do you want to focus on tomorrow? Set positive intentions.]',
          prompt: 'Look ahead to tomorrow. What do you want to prioritize or achieve?',
          example: 'Set intentions for how you want to feel, what you want to accomplish, or how you want to show up.',
          estimatedSeconds: 45,
        ),
        VoicePrompt(
          id: 'journal_free_thoughts',
          placeholder: '[Voice: Any other thoughts, dreams, or reflections you want to capture?]',
          prompt: 'This is your free space. Share anything else on your mind.',
          example: 'Dreams, random thoughts, ideas, or anything else you want to remember.',
          estimatedSeconds: 60,
          isRequired: false,
        ),
      ],
    );
  }
}