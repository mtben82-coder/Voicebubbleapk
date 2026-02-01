// ============================================================
//        MASTER TEMPLATE REGISTRY
// ============================================================
//
// This file exports ALL templates and provides helper functions
// for accessing them throughout the app.
//
// ============================================================

import 'template_models.dart';
import 'templates_life_professional.dart';
import 'templates_legal_emotional.dart';
import 'templates_productivity.dart';
import 'templates_social_ecommerce.dart';
import 'templates_health_learning_personal.dart';
import 'templates_bonus.dart';

// ============================================================
// ALL TEMPLATES
// ============================================================

/// Complete list of all templates
final List<AppTemplate> allTemplates = [
  // 🚀 Life-Changing (5)
  resumeTemplate,
  coverLetterTemplate,
  collegeEssayTemplate,
  pitchDeckTemplate,
  immigrationLetterTemplate,
  
  // 💼 Professional (5)
  meetingNotesTemplate,
  salesCrmTemplate,
  performanceReviewTemplate,
  clientIntakeTemplate,
  incidentReportTemplate,
  
  // ⚖️ Legal & Finance (4)
  insuranceAppealTemplate,
  demandLetterTemplate,
  realEstateOfferTemplate,
  freelanceProposalTemplate,
  
  // 💕 Emotional (3)
  weddingSpeechTemplate,
  eulogyTemplate,
  weddingVowsTemplate,
  
  // 📊 Productivity (9)
  expenseTrackerTemplate,
  timeTrackerTemplate,
  inventoryLogTemplate,
  contactListTemplate,
  calendarEventTemplate,
  taskListTemplate,
  quickNoteTemplate,
  projectBriefTemplate,
  trelloCardTemplate,
  
  // 📱 Social Media (5)
  linkedInPostTemplate,
  instagramCaptionTemplate,
  twitterThreadTemplate,
  youtubeDescriptionTemplate,
  tiktokCaptionTemplate,
  
  // 🛒 E-Commerce (3)
  productListingTemplate,
  productReviewRequestTemplate,
  salesEmailTemplate,
  
  // 🏥 Health (4)
  foodLogTemplate,
  symptomTrackerTemplate,
  workoutLogTemplate,
  medicalHistoryTemplate,
  
  // 📚 Learning (3)
  flashcardTemplate,
  studyNotesTemplate,
  bookSummaryTemplate,
  
  // 🧘 Personal (5)
  dailyJournalTemplate,
  gratitudeJournalTemplate,
  dreamJournalTemplate,
  goalSettingTemplate,
  weeklyReviewTemplate,
  
  // 🎁 BONUS PACK (10)
  podcastShowNotesTemplate,
  blogPostTemplate,
  newsletterTemplate,
  soapNoteTemplate,
  grantProposalTemplate,
  standupUpdateTemplate,
  oneOnOneNotesTemplate,
  decisionMatrixTemplate,
  habitTrackerSetupTemplate,
];

// ============================================================
// TEMPLATE ACCESS HELPERS
// ============================================================

/// Get template by ID
AppTemplate? getTemplate(String id) {
  try {
    return allTemplates.firstWhere((t) => t.id == id);
  } catch (_) {
    return null;
  }
}

/// Get templates by category
List<AppTemplate> getTemplatesByCategory(TemplateCategory category) {
  return allTemplates.where((t) => t.category == category).toList();
}

/// Get free templates only
List<AppTemplate> getFreeTemplates() {
  return allTemplates.where((t) => !t.isPro).toList();
}

/// Get pro templates only
List<AppTemplate> getProTemplates() {
  return allTemplates.where((t) => t.isPro).toList();
}

/// Get templates by target app
List<AppTemplate> getTemplatesByTargetApp(String app) {
  return allTemplates
      .where((t) => t.targetApp?.toLowerCase().contains(app.toLowerCase()) ?? false)
      .toList();
}

/// Search templates by name or description
List<AppTemplate> searchTemplates(String query) {
  final q = query.toLowerCase();
  return allTemplates.where((t) {
    return t.name.toLowerCase().contains(q) ||
           t.description.toLowerCase().contains(q) ||
           t.tagline.toLowerCase().contains(q) ||
           (t.targetApp?.toLowerCase().contains(q) ?? false);
  }).toList();
}

/// Get featured templates for homepage
List<AppTemplate> getFeaturedTemplates() {
  return [
    resumeTemplate,
    meetingNotesTemplate,
    linkedInPostTemplate,
    weddingSpeechTemplate,
    expenseTrackerTemplate,
    flashcardTemplate,
  ];
}

/// Get quick templates (single section, < 2 minutes)
List<AppTemplate> getQuickTemplates() {
  return allTemplates.where((t) => t.sections.length <= 2).toList();
}

// ============================================================
// STATISTICS
// ============================================================

/// Total number of templates
int get totalTemplateCount => allTemplates.length;

/// Number of free templates
int get freeTemplateCount => getFreeTemplates().length;

/// Number of pro templates
int get proTemplateCount => getProTemplates().length;

/// Templates per category
Map<TemplateCategory, int> get templatesPerCategory {
  final map = <TemplateCategory, int>{};
  for (final category in TemplateCategory.values) {
    map[category] = getTemplatesByCategory(category).length;
  }
  return map;
}