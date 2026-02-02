// ============================================================
//        TEMPLATE MODELS — ELITE DATA STRUCTURES
// ============================================================

import 'package:flutter/material.dart';

/// Categories for organizing templates
enum TemplateCategory {
  lifeChanging,    // Resume, College Essay, Pitch Deck
  professional,    // Meeting Notes, Sales CRM, Performance Review
  legal,           // Demand Letters, Insurance Appeals
  emotional,       // Wedding Speech, Eulogy, Vows
  productivity,    // Sheets, Calendar, Tasks, Notes
  social,          // LinkedIn, Instagram, Twitter, YouTube
  ecommerce,       // Product Listings
  health,          // Food Log, Symptom Tracker
  learning,        // Flashcards, Study Notes
  personal,        // Journal, Gratitude, Dreams
}

extension TemplateCategoryX on TemplateCategory {
  String get displayName {
    switch (this) {
      case TemplateCategory.lifeChanging: return 'Life-Changing';
      case TemplateCategory.professional: return 'Professional';
      case TemplateCategory.legal: return 'Legal & Finance';
      case TemplateCategory.emotional: return 'Speeches & Tributes';
      case TemplateCategory.productivity: return 'Productivity';
      case TemplateCategory.social: return 'Social Media';
      case TemplateCategory.ecommerce: return 'E-Commerce';
      case TemplateCategory.health: return 'Health & Fitness';
      case TemplateCategory.learning: return 'Learning';
      case TemplateCategory.personal: return 'Personal';
    }
  }

  IconData get icon {
    switch (this) {
      case TemplateCategory.lifeChanging: return Icons.rocket_launch;
      case TemplateCategory.professional: return Icons.business_center;
      case TemplateCategory.legal: return Icons.gavel;
      case TemplateCategory.emotional: return Icons.favorite;
      case TemplateCategory.productivity: return Icons.grid_view;
      case TemplateCategory.social: return Icons.share;
      case TemplateCategory.ecommerce: return Icons.storefront;
      case TemplateCategory.health: return Icons.monitor_heart;
      case TemplateCategory.learning: return Icons.school;
      case TemplateCategory.personal: return Icons.self_improvement;
    }
  }

  Color get color {
    switch (this) {
      case TemplateCategory.lifeChanging: return const Color(0xFF8B5CF6);
      case TemplateCategory.professional: return const Color(0xFF3B82F6);
      case TemplateCategory.legal: return const Color(0xFFEF4444);
      case TemplateCategory.emotional: return const Color(0xFFEC4899);
      case TemplateCategory.productivity: return const Color(0xFF10B981);
      case TemplateCategory.social: return const Color(0xFFF59E0B);
      case TemplateCategory.ecommerce: return const Color(0xFF06B6D4);
      case TemplateCategory.health: return const Color(0xFFEF4444);
      case TemplateCategory.learning: return const Color(0xFF8B5CF6);
      case TemplateCategory.personal: return const Color(0xFF10B981);
    }
  }
}

/// Export format for integrations
enum ExportFormat {
  text,       // Plain text
  markdown,   // Notion, docs
  csv,        // Sheets, Excel
  ics,        // Calendar
  html,       // Rich format
  json,       // Data exchange
}

/// A section within a template
class TemplateSection {
  final String id;
  final String title;
  final String hint;
  final String aiPrompt;
  final IconData icon;
  final bool required;
  final bool multiLine;
  final List<String>? suggestions;  // Quick fill suggestions
  final String? placeholder;

  const TemplateSection({
    required this.id,
    required this.title,
    required this.hint,
    required this.aiPrompt,
    this.icon = Icons.mic,
    this.required = true,
    this.multiLine = true,
    this.suggestions,
    this.placeholder,
  });
}

/// A complete template definition
class AppTemplate {
  final String id;
  final String name;
  final String description;
  final String tagline;
  final TemplateCategory category;
  final List<TemplateSection> sections;
  final IconData icon;
  final List<Color> gradientColors;
  final bool isPro;
  final ExportFormat defaultExport;
  final List<ExportFormat> availableExports;
  final String aiSystemPrompt;  // Master prompt for final generation
  final String? targetApp;      // e.g., "Google Sheets", "LinkedIn"
  final int estimatedMinutes;
  final List<dynamic>? interviewFlow;  // Interview questions (InterviewQuestion list)

  const AppTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.tagline,
    required this.category,
    required this.sections,
    required this.icon,
    required this.gradientColors,
    required this.aiSystemPrompt,
    this.isPro = false,
    this.defaultExport = ExportFormat.text,
    this.availableExports = const [ExportFormat.text],
    this.targetApp,
    this.estimatedMinutes = 3,
    this.interviewFlow,  // Optional voice interview questions
  });

  int get sectionCount => sections.length;
  int get requiredCount => sections.where((s) => s.required).length;
}

/// User's filled template data
class FilledTemplate {
  final String templateId;
  final Map<String, String> sectionInputs;  // Raw voice inputs
  final Map<String, String> sectionOutputs; // AI-processed outputs
  final String? finalOutput;
  final DateTime createdAt;
  final DateTime? completedAt;

  FilledTemplate({
    required this.templateId,
    Map<String, String>? sectionInputs,
    Map<String, String>? sectionOutputs,
    this.finalOutput,
    DateTime? createdAt,
    this.completedAt,
  }) : sectionInputs = sectionInputs ?? {},
       sectionOutputs = sectionOutputs ?? {},
       createdAt = createdAt ?? DateTime.now();

  double getProgress(AppTemplate template) {
    if (template.sections.isEmpty) return 0;
    final filled = sectionInputs.values.where((v) => v.isNotEmpty).length;
    return filled / template.sections.length;
  }

  bool isComplete(AppTemplate template) {
    return template.sections
        .where((s) => s.required)
        .every((s) => sectionInputs[s.id]?.isNotEmpty ?? false);
  }

  FilledTemplate copyWith({
    Map<String, String>? sectionInputs,
    Map<String, String>? sectionOutputs,
    String? finalOutput,
    DateTime? completedAt,
  }) {
    return FilledTemplate(
      templateId: templateId,
      sectionInputs: sectionInputs ?? this.sectionInputs,
      sectionOutputs: sectionOutputs ?? this.sectionOutputs,
      finalOutput: finalOutput ?? this.finalOutput,
      createdAt: createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}