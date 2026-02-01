// ============================================================
//        ELITE TEMPLATES — BONUS PACK
// ============================================================
//
// Additional high-value templates for maximum coverage.
//
// ============================================================

import 'package:flutter/material.dart';
import 'template_models.dart';

// ============================================================
// 📝 CONTENT CREATION TEMPLATES
// ============================================================

const podcastShowNotesTemplate = AppTemplate(
  id: 'podcast_show_notes',
  name: 'Podcast Show Notes',
  description: 'Generate complete podcast descriptions',
  tagline: 'Content repurposing made easy',
  category: TemplateCategory.social,
  icon: Icons.podcasts,
  gradientColors: [Color(0xFF9333EA), Color(0xFF7C3AED)],
  isPro: true,
  estimatedMinutes: 3,
  defaultExport: ExportFormat.markdown,
  targetApp: 'Podcast Hosts',
  availableExports: [ExportFormat.text, ExportFormat.markdown, ExportFormat.html],
  aiSystemPrompt: '''Create comprehensive podcast show notes including: episode summary, key takeaways, timestamps, guest info, links mentioned. SEO-optimized for podcast discovery.''',
  sections: [
    TemplateSection(
      id: 'episode',
      title: 'Episode Overview',
      hint: 'Episode title, number, main topic, guest name',
      aiPrompt: 'Create engaging episode header.',
      icon: Icons.podcasts,
      placeholder: 'Episode 42, How to Build a Second Brain with guest David Allen, talking about productivity systems',
    ),
    TemplateSection(
      id: 'summary',
      title: 'What You Discussed',
      hint: 'Main topics, key points, interesting moments',
      aiPrompt: 'Create compelling episode summary.',
      icon: Icons.summarize,
      placeholder: 'Talked about GTD method, capture habits, weekly reviews, digital vs paper tools, his morning routine',
    ),
    TemplateSection(
      id: 'timestamps',
      title: 'Timestamps',
      hint: 'Key moments with approximate times',
      aiPrompt: 'Format as clickable timestamp list.',
      icon: Icons.access_time,
      placeholder: 'Intro at start, his backstory around 5 min, GTD basics at 15, tool recommendations at 30, rapid fire at 45',
    ),
    TemplateSection(
      id: 'links',
      title: 'Links & Resources',
      hint: 'Books, tools, websites mentioned',
      aiPrompt: 'List all resources mentioned.',
      icon: Icons.link,
      required: false,
      placeholder: 'His book Getting Things Done, Notion, Roam Research, his website davidallen.com',
    ),
  ],
);

const blogPostTemplate = AppTemplate(
  id: 'blog_post',
  name: 'Blog Post',
  description: 'SEO-optimized articles that rank',
  tagline: 'Write blogs by voice',
  category: TemplateCategory.social,
  icon: Icons.article,
  gradientColors: [Color(0xFF059669), Color(0xFF10B981)],
  isPro: true,
  estimatedMinutes: 5,
  defaultExport: ExportFormat.markdown,
  targetApp: 'WordPress / Medium',
  availableExports: [ExportFormat.text, ExportFormat.markdown, ExportFormat.html],
  aiSystemPrompt: '''Write an engaging, SEO-optimized blog post. Strong headline, compelling intro, scannable structure with headers, valuable content, clear conclusion with CTA. Natural keyword integration.''',
  sections: [
    TemplateSection(
      id: 'topic',
      title: 'Topic & Angle',
      hint: 'What are you writing about? What\'s your unique take?',
      aiPrompt: 'Create compelling headline and angle.',
      icon: Icons.lightbulb,
      placeholder: 'How to wake up at 5am without feeling tired, sharing my personal system that worked after 10 failed attempts',
    ),
    TemplateSection(
      id: 'audience',
      title: 'Target Reader',
      hint: 'Who is this for? What do they struggle with?',
      aiPrompt: 'Tailor language and examples to audience.',
      icon: Icons.people,
      placeholder: 'Busy professionals who want more morning time but keep hitting snooze, tried everything',
    ),
    TemplateSection(
      id: 'main_points',
      title: 'Main Points',
      hint: 'Key arguments, tips, or story beats',
      aiPrompt: 'Structure into clear, valuable sections.',
      icon: Icons.list,
      placeholder: 'Start with sleep time not wake time, light exposure trick, coffee timing, accountability system, weekend consistency',
    ),
    TemplateSection(
      id: 'keywords',
      title: 'Keywords',
      hint: 'What should this rank for in search?',
      aiPrompt: 'Integrate keywords naturally.',
      icon: Icons.search,
      required: false,
      placeholder: 'wake up early, morning routine, how to become a morning person, 5am club',
    ),
  ],
);

const newsletterTemplate = AppTemplate(
  id: 'newsletter',
  name: 'Newsletter',
  description: 'Engaging newsletters that get opens',
  tagline: 'Grow your list',
  category: TemplateCategory.social,
  icon: Icons.mail_outline,
  gradientColors: [Color(0xFFEA580C), Color(0xFFF97316)],
  isPro: true,
  estimatedMinutes: 4,
  defaultExport: ExportFormat.html,
  targetApp: 'Substack / Mailchimp',
  availableExports: [ExportFormat.text, ExportFormat.markdown, ExportFormat.html],
  aiSystemPrompt: '''Write a newsletter that readers actually want to open. Compelling subject line, personal opening, valuable content, clear sections, strong CTA. Sound human, not corporate.''',
  sections: [
    TemplateSection(
      id: 'subject',
      title: 'Subject Line',
      hint: 'What will make them click? The hook.',
      aiPrompt: 'Create irresistible subject line.',
      icon: Icons.subject,
      placeholder: 'I made a mistake that cost me 3 months of progress, here\'s what I learned',
    ),
    TemplateSection(
      id: 'opener',
      title: 'Opening',
      hint: 'Personal touch, story, or hook to draw them in',
      aiPrompt: 'Create engaging personal opening.',
      icon: Icons.play_arrow,
      placeholder: 'Last Tuesday I was ready to quit, sitting in my car after another failed pitch, then I realized something',
    ),
    TemplateSection(
      id: 'content',
      title: 'Main Content',
      hint: 'The value, insights, updates, or story',
      aiPrompt: 'Deliver clear value with personality.',
      icon: Icons.article,
      placeholder: 'Three lessons from my failure: preparation isn\'t everything, read the room, follow up matters more than the meeting',
    ),
    TemplateSection(
      id: 'cta',
      title: 'Call to Action',
      hint: 'What do you want them to do?',
      aiPrompt: 'Create clear, compelling CTA.',
      icon: Icons.touch_app,
      placeholder: 'Reply and tell me your biggest pitch fail, launching my new course next week early access for subscribers',
    ),
  ],
);

// ============================================================
// 💼 MORE BUSINESS TEMPLATES
// ============================================================

const soapNoteTemplate = AppTemplate(
  id: 'soap_note',
  name: 'SOAP Note',
  description: 'Medical documentation by voice',
  tagline: 'Chart faster',
  category: TemplateCategory.professional,
  icon: Icons.medical_services,
  gradientColors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
  isPro: true,
  estimatedMinutes: 3,
  defaultExport: ExportFormat.text,
  targetApp: 'EHR Systems',
  availableExports: [ExportFormat.text, ExportFormat.markdown],
  aiSystemPrompt: '''Create a professional SOAP note following standard medical documentation format. Subjective, Objective, Assessment, Plan. Use appropriate medical terminology. Be thorough but concise.''',
  sections: [
    TemplateSection(
      id: 'subjective',
      title: 'Subjective',
      hint: 'Chief complaint, history, patient\'s description',
      aiPrompt: 'Format subjective findings professionally.',
      icon: Icons.person,
      placeholder: 'Patient reports 3 days of headache, described as throbbing, right side, 7 out of 10, worse in morning, some nausea',
    ),
    TemplateSection(
      id: 'objective',
      title: 'Objective',
      hint: 'Vitals, exam findings, test results',
      aiPrompt: 'Format objective findings with proper notation.',
      icon: Icons.monitor_heart,
      placeholder: 'BP 128/82, HR 76, temp normal, neuro exam normal, no papilledema, mild tenderness right temple',
    ),
    TemplateSection(
      id: 'assessment',
      title: 'Assessment',
      hint: 'Diagnosis or differential',
      aiPrompt: 'State assessment clearly with reasoning.',
      icon: Icons.psychology,
      placeholder: 'Likely migraine without aura, rule out tension headache, low concern for secondary causes given normal exam',
    ),
    TemplateSection(
      id: 'plan',
      title: 'Plan',
      hint: 'Treatment, medications, follow-up',
      aiPrompt: 'Detail treatment plan with specifics.',
      icon: Icons.checklist,
      placeholder: 'Start sumatriptan 50mg PRN, headache diary, avoid triggers, return if worse or new symptoms, follow up 2 weeks',
    ),
  ],
);

const grantProposalTemplate = AppTemplate(
  id: 'grant_proposal',
  name: 'Grant Proposal',
  description: 'Win funding for your project',
  tagline: 'Get funded',
  category: TemplateCategory.professional,
  icon: Icons.account_balance,
  gradientColors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
  isPro: true,
  estimatedMinutes: 8,
  defaultExport: ExportFormat.markdown,
  availableExports: [ExportFormat.text, ExportFormat.markdown, ExportFormat.html],
  aiSystemPrompt: '''Write a compelling grant proposal. Clear problem statement, innovative solution, qualified team, realistic budget, measurable outcomes. Match the funder\'s priorities.''',
  sections: [
    TemplateSection(
      id: 'summary',
      title: 'Executive Summary',
      hint: 'One paragraph overview of the entire proposal',
      aiPrompt: 'Create compelling executive summary.',
      icon: Icons.summarize,
      placeholder: 'We\'re requesting \$50K to expand our coding bootcamp for underserved youth, will serve 200 students, 80% job placement rate',
    ),
    TemplateSection(
      id: 'problem',
      title: 'Problem Statement',
      hint: 'What problem exists? Who\'s affected? Why does it matter?',
      aiPrompt: 'Present problem with data and human impact.',
      icon: Icons.error_outline,
      placeholder: 'Youth unemployment at 25% in our area, lack of tech skills, companies hiring but can\'t find talent locally',
    ),
    TemplateSection(
      id: 'solution',
      title: 'Your Solution',
      hint: 'What will you do? How does it work? Why is it effective?',
      aiPrompt: 'Explain solution with clear methodology.',
      icon: Icons.lightbulb,
      placeholder: '12-week intensive bootcamp, project-based learning, industry mentors, job placement support, proven curriculum',
    ),
    TemplateSection(
      id: 'outcomes',
      title: 'Expected Outcomes',
      hint: 'Measurable results, how you\'ll track success',
      aiPrompt: 'Define specific, measurable outcomes.',
      icon: Icons.trending_up,
      placeholder: '200 students trained, 80% complete, 75% employed within 6 months, track 1 year post-graduation',
    ),
    TemplateSection(
      id: 'budget',
      title: 'Budget Overview',
      hint: 'How will funds be used? Key line items.',
      aiPrompt: 'Present budget clearly and justify costs.',
      icon: Icons.attach_money,
      placeholder: '\$30K instructors, \$10K equipment and software, \$5K student support, \$5K admin and evaluation',
    ),
    TemplateSection(
      id: 'team',
      title: 'Team & Qualifications',
      hint: 'Who will execute? Why are you qualified?',
      aiPrompt: 'Establish team credibility.',
      icon: Icons.people,
      placeholder: 'Led by former Google engineer, partnered with local college, board includes industry leaders, 3 years running similar programs',
    ),
  ],
);

const standupUpdateTemplate = AppTemplate(
  id: 'standup_update',
  name: 'Standup Update',
  description: 'Daily standups in 30 seconds',
  tagline: 'Quick status updates',
  category: TemplateCategory.professional,
  icon: Icons.update,
  gradientColors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
  isPro: false,
  estimatedMinutes: 1,
  defaultExport: ExportFormat.text,
  targetApp: 'Slack / Teams',
  availableExports: [ExportFormat.text, ExportFormat.markdown],
  aiSystemPrompt: '''Format as a clear, concise standup update. Yesterday, Today, Blockers. Bullet points, no fluff. Ready to paste into Slack.''',
  sections: [
    TemplateSection(
      id: 'update',
      title: 'Your Update',
      hint: 'What did you do, what will you do, any blockers?',
      aiPrompt: 'Format as Yesterday/Today/Blockers.',
      icon: Icons.update,
      placeholder: 'Yesterday finished the login page, today working on dashboard, blocked waiting for API docs from backend team',
    ),
  ],
);

const oneOnOneNotesTemplate = AppTemplate(
  id: 'one_on_one',
  name: '1:1 Meeting Notes',
  description: 'Track manager/report conversations',
  tagline: 'Better 1:1s',
  category: TemplateCategory.professional,
  icon: Icons.people,
  gradientColors: [Color(0xFF10B981), Color(0xFF059669)],
  isPro: false,
  estimatedMinutes: 2,
  defaultExport: ExportFormat.markdown,
  targetApp: 'Notion / Docs',
  availableExports: [ExportFormat.text, ExportFormat.markdown],
  aiSystemPrompt: '''Create structured 1:1 meeting notes. Include: wins, challenges, discussion points, action items, career topics. Professional but conversational tone.''',
  sections: [
    TemplateSection(
      id: 'person',
      title: 'Who & When',
      hint: 'Person\'s name, date, recurring or special topic',
      aiPrompt: 'Create meeting header.',
      icon: Icons.person,
      placeholder: 'Weekly 1:1 with Sarah, January 15, also discussing promotion timeline',
    ),
    TemplateSection(
      id: 'discussed',
      title: 'What You Discussed',
      hint: 'Topics covered, updates shared, concerns raised',
      aiPrompt: 'Organize discussion points clearly.',
      icon: Icons.chat,
      placeholder: 'She\'s feeling overwhelmed with the new project, wants more clarity on priorities, excited about the conference opportunity',
    ),
    TemplateSection(
      id: 'actions',
      title: 'Action Items',
      hint: 'What did you agree to do? What will they do?',
      aiPrompt: 'List action items with owners.',
      icon: Icons.task_alt,
      placeholder: 'I\'ll talk to product about scope, she\'ll draft the Q2 plan, we\'ll review comp next month',
    ),
  ],
);

// ============================================================
// 🎯 PERSONAL EFFECTIVENESS TEMPLATES
// ============================================================

const decisionMatrixTemplate = AppTemplate(
  id: 'decision_matrix',
  name: 'Decision Matrix',
  description: 'Make better decisions systematically',
  tagline: 'Decide with clarity',
  category: TemplateCategory.personal,
  icon: Icons.balance,
  gradientColors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
  isPro: false,
  estimatedMinutes: 3,
  defaultExport: ExportFormat.markdown,
  availableExports: [ExportFormat.text, ExportFormat.markdown, ExportFormat.csv],
  aiSystemPrompt: '''Create a decision matrix analyzing options against criteria. Weight factors by importance. Provide clear recommendation with reasoning.''',
  sections: [
    TemplateSection(
      id: 'decision',
      title: 'The Decision',
      hint: 'What are you trying to decide?',
      aiPrompt: 'Frame the decision clearly.',
      icon: Icons.help,
      placeholder: 'Should I take the new job offer or stay at my current company?',
    ),
    TemplateSection(
      id: 'options',
      title: 'Your Options',
      hint: 'List the choices you\'re considering',
      aiPrompt: 'List all viable options.',
      icon: Icons.list,
      placeholder: 'Stay at current job, take the new offer, negotiate with current company, keep looking',
    ),
    TemplateSection(
      id: 'factors',
      title: 'What Matters',
      hint: 'Factors that are important to you, weighted by priority',
      aiPrompt: 'Identify and weight decision criteria.',
      icon: Icons.priority_high,
      placeholder: 'Salary very important, work-life balance most important, growth opportunities important, location less important',
    ),
    TemplateSection(
      id: 'analysis',
      title: 'How Each Scores',
      hint: 'Rate each option on your factors',
      aiPrompt: 'Analyze options against criteria.',
      icon: Icons.analytics,
      placeholder: 'New job better salary but longer commute, current job better balance but limited growth, negotiating might get best of both',
    ),
  ],
);

const habitTrackerSetupTemplate = AppTemplate(
  id: 'habit_tracker',
  name: 'Habit Tracker Setup',
  description: 'Design your habit system',
  tagline: 'Build better habits',
  category: TemplateCategory.personal,
  icon: Icons.repeat,
  gradientColors: [Color(0xFF10B981), Color(0xFF059669)],
  isPro: false,
  estimatedMinutes: 3,
  defaultExport: ExportFormat.markdown,
  targetApp: 'Notion / Sheets',
  availableExports: [ExportFormat.text, ExportFormat.markdown, ExportFormat.csv],
  aiSystemPrompt: '''Create a habit tracking system. Define habits clearly with cues, routines, rewards. Include implementation intentions and tracking method.''',
  sections: [
    TemplateSection(
      id: 'habits',
      title: 'Habits to Build',
      hint: 'What habits do you want? Be specific about when/how.',
      aiPrompt: 'Define habits with specific triggers and actions.',
      icon: Icons.add_task,
      placeholder: 'Meditate 10 min every morning after coffee, read 20 pages before bed, gym 3x per week on MWF',
    ),
    TemplateSection(
      id: 'why',
      title: 'Why These Matter',
      hint: 'Your motivation, the outcome you want',
      aiPrompt: 'Connect habits to meaningful goals.',
      icon: Icons.favorite,
      placeholder: 'Want to be calmer at work, always wanted to read more, getting back in shape for my health',
    ),
    TemplateSection(
      id: 'obstacles',
      title: 'Potential Obstacles',
      hint: 'What might get in the way? How will you handle it?',
      aiPrompt: 'Anticipate and plan for obstacles.',
      icon: Icons.warning,
      placeholder: 'Mornings are rushed, might skip reading when tired, gym excuses when busy',
    ),
    TemplateSection(
      id: 'system',
      title: 'Your System',
      hint: 'How will you track? What\'s your streak goal?',
      aiPrompt: 'Design tracking and accountability system.',
      icon: Icons.check_box,
      placeholder: 'Track in app, aim for 21 day streak first, accountability partner is my wife, reward at 30 days',
    ),
  ],
);