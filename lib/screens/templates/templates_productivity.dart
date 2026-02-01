// ============================================================
//        ELITE TEMPLATES — PRODUCTIVITY INTEGRATIONS
// ============================================================

import 'package:flutter/material.dart';
import 'template_models.dart';

// ============================================================
// 📊 PRODUCTIVITY TEMPLATES
// ============================================================

const expenseTrackerTemplate = AppTemplate(
  id: 'expense_tracker',
  name: 'Expense Tracker',
  description: 'Log expenses for Sheets or Excel',
  tagline: 'Voice your spending',
  category: TemplateCategory.productivity,
  icon: Icons.receipt_long,
  gradientColors: [Color(0xFF10B981), Color(0xFF059669)],
  isPro: false,
  estimatedMinutes: 1,
  defaultExport: ExportFormat.csv,
  targetApp: 'Google Sheets / Excel',
  availableExports: [ExportFormat.csv, ExportFormat.text, ExportFormat.json],
  aiSystemPrompt: '''Extract expense data into structured format. Each expense needs: date, description, amount, category. Output as clean CSV rows ready for spreadsheet import.''',
  sections: [
    TemplateSection(
      id: 'expenses',
      title: 'Your Expenses',
      hint: 'List what you spent, amounts, when. You can do multiple at once.',
      aiPrompt: 'Extract each expense with date, description, amount, and categorize it.',
      icon: Icons.attach_money,
      placeholder: 'Uber to airport \$45 yesterday, coffee this morning \$6, lunch with client \$85 on Tuesday',
      suggestions: ['Today', 'Yesterday', 'This week'],
    ),
  ],
);

const timeTrackerTemplate = AppTemplate(
  id: 'time_tracker',
  name: 'Time Tracker',
  description: 'Log hours for timesheets',
  tagline: 'Track your time by voice',
  category: TemplateCategory.productivity,
  icon: Icons.timer,
  gradientColors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
  isPro: false,
  estimatedMinutes: 1,
  defaultExport: ExportFormat.csv,
  targetApp: 'Google Sheets / Excel',
  availableExports: [ExportFormat.csv, ExportFormat.text, ExportFormat.json],
  aiSystemPrompt: '''Extract time entries into structured format. Each entry needs: date, project/client, hours, task description. Output as clean CSV rows ready for timesheet import.''',
  sections: [
    TemplateSection(
      id: 'time',
      title: 'Time Worked',
      hint: 'What did you work on? How long? Which project or client?',
      aiPrompt: 'Extract each time entry with date, project, hours, and description.',
      icon: Icons.schedule,
      placeholder: '3 hours on Acme website today, 2 hours client calls yesterday, 5 hours coding for Project Alpha on Monday',
    ),
  ],
);

const inventoryLogTemplate = AppTemplate(
  id: 'inventory_log',
  name: 'Inventory Log',
  description: 'Track stock levels by voice',
  tagline: 'Count faster',
  category: TemplateCategory.productivity,
  icon: Icons.inventory_2,
  gradientColors: [Color(0xFFF59E0B), Color(0xFFD97706)],
  isPro: false,
  estimatedMinutes: 1,
  defaultExport: ExportFormat.csv,
  targetApp: 'Google Sheets / Excel',
  availableExports: [ExportFormat.csv, ExportFormat.text, ExportFormat.json],
  aiSystemPrompt: '''Extract inventory data into structured format. Each item needs: item name, quantity, size/variant if applicable, location. Output as clean CSV rows.''',
  sections: [
    TemplateSection(
      id: 'items',
      title: 'Inventory Count',
      hint: 'Item names, quantities, sizes, locations',
      aiPrompt: 'Extract each inventory item with name, quantity, variants, location.',
      icon: Icons.inventory,
      placeholder: '50 red t-shirts large in warehouse A, 30 blue medium same place, 10 black small in the front',
    ),
  ],
);

const contactListTemplate = AppTemplate(
  id: 'contact_list',
  name: 'Contact List',
  description: 'Build contact lists fast',
  tagline: 'Voice your contacts',
  category: TemplateCategory.productivity,
  icon: Icons.contacts,
  gradientColors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
  isPro: false,
  estimatedMinutes: 1,
  defaultExport: ExportFormat.csv,
  targetApp: 'Google Sheets / Contacts',
  availableExports: [ExportFormat.csv, ExportFormat.text, ExportFormat.json],
  aiSystemPrompt: '''Extract contact information into structured format. Each contact needs: name, email, phone, company, notes. Output as clean CSV rows.''',
  sections: [
    TemplateSection(
      id: 'contacts',
      title: 'Contacts',
      hint: 'Names, emails, phones, companies, any notes',
      aiPrompt: 'Extract each contact with full details.',
      icon: Icons.person_add,
      placeholder: 'John Smith from Acme Corp, john@acme.com, 555-1234, met at the conference, interested in our product',
    ),
  ],
);

const calendarEventTemplate = AppTemplate(
  id: 'calendar_event',
  name: 'Calendar Event',
  description: 'Create events by voice',
  tagline: 'Schedule in seconds',
  category: TemplateCategory.productivity,
  icon: Icons.event,
  gradientColors: [Color(0xFF0891B2), Color(0xFF0E7490)],
  isPro: false,
  estimatedMinutes: 1,
  defaultExport: ExportFormat.text,
  targetApp: 'Google Calendar / Outlook',
  availableExports: [ExportFormat.text, ExportFormat.json],
  aiSystemPrompt: '''Extract calendar event details. Need: title, date, time (start and end if given), location, description, any reminders. Format clearly for calendar entry.''',
  sections: [
    TemplateSection(
      id: 'event',
      title: 'Event Details',
      hint: 'What, when, where, with who, any other details',
      aiPrompt: 'Extract full event details with all relevant information.',
      icon: Icons.calendar_today,
      placeholder: 'Meeting with Sarah next Tuesday 2pm at Starbucks on Main St, discussing the project proposal, remind me an hour before',
    ),
  ],
);

const taskListTemplate = AppTemplate(
  id: 'task_list',
  name: 'Quick Tasks',
  description: 'Create tasks for Todoist, Reminders, etc.',
  tagline: 'Voice your to-dos',
  category: TemplateCategory.productivity,
  icon: Icons.checklist,
  gradientColors: [Color(0xFFEC4899), Color(0xFFBE185D)],
  isPro: false,
  estimatedMinutes: 1,
  defaultExport: ExportFormat.text,
  targetApp: 'Todoist / Reminders',
  availableExports: [ExportFormat.text, ExportFormat.markdown, ExportFormat.json],
  aiSystemPrompt: '''Extract tasks with due dates, priorities, and projects if mentioned. Format as clear task list ready for task app import.''',
  sections: [
    TemplateSection(
      id: 'tasks',
      title: 'Your Tasks',
      hint: 'What needs to be done? When? Priority? Project?',
      aiPrompt: 'Extract each task with due date, priority, and project.',
      icon: Icons.task_alt,
      placeholder: 'Call mom tomorrow, finish report by Friday high priority, buy groceries this weekend, email John about the proposal for work',
    ),
  ],
);

const quickNoteTemplate = AppTemplate(
  id: 'quick_note',
  name: 'Quick Note',
  description: 'Capture thoughts for Keep, Notes, Notion',
  tagline: 'Speak your mind',
  category: TemplateCategory.productivity,
  icon: Icons.note_add,
  gradientColors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
  isPro: false,
  estimatedMinutes: 1,
  defaultExport: ExportFormat.markdown,
  targetApp: 'Google Keep / Notes / Notion',
  availableExports: [ExportFormat.text, ExportFormat.markdown],
  aiSystemPrompt: '''Clean up the voice note into organized text. Add structure if there are multiple topics. Keep the person\'s voice but make it readable.''',
  sections: [
    TemplateSection(
      id: 'note',
      title: 'Your Note',
      hint: 'Just speak whatever\'s on your mind',
      aiPrompt: 'Structure the note clearly while preserving the original intent.',
      icon: Icons.edit_note,
      placeholder: 'Idea for the app - what if we added a feature where users can share templates, also need to remember to fix that bug Sarah mentioned',
    ),
  ],
);

const projectBriefTemplate = AppTemplate(
  id: 'project_brief',
  name: 'Project Brief',
  description: 'Create project pages for Notion, Docs',
  tagline: 'Brief projects fast',
  category: TemplateCategory.productivity,
  icon: Icons.assignment,
  gradientColors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
  isPro: false,
  estimatedMinutes: 3,
  defaultExport: ExportFormat.markdown,
  targetApp: 'Notion / Google Docs',
  availableExports: [ExportFormat.text, ExportFormat.markdown, ExportFormat.html],
  aiSystemPrompt: '''Create a comprehensive project brief document. Include all key elements: overview, goals, scope, timeline, team, and success metrics.''',
  sections: [
    TemplateSection(
      id: 'overview',
      title: 'Project Overview',
      hint: 'What is this project? Why are we doing it?',
      aiPrompt: 'Create clear project overview section.',
      icon: Icons.description,
      placeholder: 'Website redesign for Acme Corp, current site is 5 years old and not converting, need modern responsive design',
    ),
    TemplateSection(
      id: 'goals',
      title: 'Goals',
      hint: 'What are we trying to achieve? Success metrics?',
      aiPrompt: 'Define clear, measurable goals.',
      icon: Icons.flag,
      placeholder: 'Increase conversion rate from 2% to 5%, reduce bounce rate, improve mobile experience, launch in Q2',
    ),
    TemplateSection(
      id: 'scope',
      title: 'Scope',
      hint: 'What\'s included? What\'s NOT included?',
      aiPrompt: 'Define scope clearly including exclusions.',
      icon: Icons.crop,
      placeholder: 'Includes homepage, about, 5 product pages, contact form. Does not include e-commerce or blog for now',
    ),
    TemplateSection(
      id: 'team',
      title: 'Team & Timeline',
      hint: 'Who\'s involved? Key milestones?',
      aiPrompt: 'Outline team responsibilities and timeline.',
      icon: Icons.people,
      placeholder: 'Me on design, Mike on dev, Sarah managing. Design done in 2 weeks, dev 4 weeks, testing 1 week',
    ),
  ],
);

const trelloCardTemplate = AppTemplate(
  id: 'trello_card',
  name: 'Trello / Asana Card',
  description: 'Create detailed task cards by voice',
  tagline: 'Complete cards fast',
  category: TemplateCategory.productivity,
  icon: Icons.view_kanban,
  gradientColors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
  isPro: false,
  estimatedMinutes: 1,
  defaultExport: ExportFormat.markdown,
  targetApp: 'Trello / Asana / Monday',
  availableExports: [ExportFormat.text, ExportFormat.markdown],
  aiSystemPrompt: '''Create a complete task card with title, description, checklist, assignee, and due date. Format ready for project management tool.''',
  sections: [
    TemplateSection(
      id: 'card',
      title: 'Card Details',
      hint: 'Task name, description, subtasks/checklist, who, when',
      aiPrompt: 'Extract card details with checklist and metadata.',
      icon: Icons.view_kanban,
      placeholder: 'Redesign homepage, needs new hero section and testimonials, checklist: wireframe, mockup, review with client. Assign to Mike, due next Friday',
    ),
  ],
);