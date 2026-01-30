// =============================================================================
// ELITE PROJECT MODELS - THE FOUNDATION
// =============================================================================
// Complete data structures for elite projects
// =============================================================================

import 'package:flutter/material.dart';

// =============================================================================
// EXPORT FORMAT ENUM
// =============================================================================

enum ExportFormat {
  pdf,
  docx,
  markdown,
  txt,
  html,
  epub,
  json,
  latex,
  rtf,
  csv,
  showNotes,
  transcript,
  script,
  description,
}

extension ExportFormatExtension on ExportFormat {
  String get displayName {
    switch (this) {
      case ExportFormat.pdf: return 'PDF';
      case ExportFormat.docx: return 'Word Document';
      case ExportFormat.markdown: return 'Markdown';
      case ExportFormat.txt: return 'Plain Text';
      case ExportFormat.html: return 'HTML';
      case ExportFormat.epub: return 'EPUB';
      case ExportFormat.json: return 'JSON';
      case ExportFormat.latex: return 'LaTeX';
      case ExportFormat.rtf: return 'Rich Text';
      case ExportFormat.csv: return 'CSV';
      case ExportFormat.showNotes: return 'Show Notes';
      case ExportFormat.transcript: return 'Transcript';
      case ExportFormat.script: return 'Script';
      case ExportFormat.description: return 'Description';
    }
  }

  String get extension {
    switch (this) {
      case ExportFormat.pdf: return '.pdf';
      case ExportFormat.docx: return '.docx';
      case ExportFormat.markdown: return '.md';
      case ExportFormat.txt: return '.txt';
      case ExportFormat.html: return '.html';
      case ExportFormat.epub: return '.epub';
      case ExportFormat.json: return '.json';
      case ExportFormat.latex: return '.tex';
      case ExportFormat.rtf: return '.rtf';
      case ExportFormat.csv: return '.csv';
      case ExportFormat.showNotes: return '.txt';
      case ExportFormat.transcript: return '.txt';
      case ExportFormat.script: return '.txt';
      case ExportFormat.description: return '.txt';
    }
  }
}

// =============================================================================
// PROJECT TYPE ENUM - 9 ELITE PROJECT TYPES
// =============================================================================

enum EliteProjectType {
  novel,
  course,
  podcast,
  youtube,
  blog,
  research,
  business,
  memoir,
  freeform,
}

extension EliteProjectTypeExtension on EliteProjectType {
  ProjectTypeMetadata get metadata => ProjectTypeMetadata.all[this]!;
  
  String get name => metadata.name;
  String get displayName => metadata.name;  // Added displayName
  String get emoji => metadata.emoji;
  String get tagline => metadata.tagline;
  String get description => metadata.description;
  Color get primaryColor => metadata.primaryColor;
  Color get accentColor => metadata.accentColor;
  IconData get icon => metadata.icon;
  List<String> get benefits => metadata.benefits;
  List<String> get exportFormats => metadata.exportFormats;
  String get progressMetric => metadata.progressMetric;
  int? get suggestedGoal => metadata.suggestedGoal;
  Duration? get suggestedTimeframe => metadata.suggestedTimeframe;
  bool get isPremium => metadata.isPremium;
}

// =============================================================================
// PROJECT TYPE METADATA
// =============================================================================

class ProjectTypeMetadata {
  final EliteProjectType type;
  final String name;
  final String emoji;
  final String tagline;
  final String description;
  final Color primaryColor;
  final Color accentColor;
  final IconData icon;
  final List<String> benefits;
  final List<String> exportFormats;
  final String progressMetric;
  final int? suggestedGoal;
  final Duration? suggestedTimeframe;
  final bool isPremium;

  const ProjectTypeMetadata({
    required this.type,
    required this.name,
    required this.emoji,
    required this.tagline,
    required this.description,
    required this.primaryColor,
    required this.accentColor,
    required this.icon,
    required this.benefits,
    required this.exportFormats,
    required this.progressMetric,
    this.suggestedGoal,
    this.suggestedTimeframe,
    this.isPremium = false,
  });

  static const Map<EliteProjectType, ProjectTypeMetadata> all = {
    EliteProjectType.novel: ProjectTypeMetadata(
      type: EliteProjectType.novel,
      name: 'Novel / Book',
      emoji: '📖',
      tagline: 'Write your masterpiece',
      description: 'Write novels, books, and long-form fiction with chapter organization.',
      primaryColor: Color(0xFF6366F1),
      accentColor: Color(0xFFEEF2FF),
      icon: Icons.auto_stories,
      benefits: ['Chapter organization', 'Character tracking', 'Plot management', 'Word count goals'],
      exportFormats: ['EPUB', 'PDF', 'DOCX', 'Markdown'],
      progressMetric: 'words',
      suggestedGoal: 50000,
      suggestedTimeframe: Duration(days: 90),
      isPremium: false,
    ),
    EliteProjectType.course: ProjectTypeMetadata(
      type: EliteProjectType.course,
      name: 'Online Course',
      emoji: '🎓',
      tagline: 'Teach the world',
      description: 'Create educational courses with lessons and modules.',
      primaryColor: Color(0xFF10B981),
      accentColor: Color(0xFFECFDF5),
      icon: Icons.school,
      benefits: ['Lesson structure', 'Module organization', 'Quiz integration', 'Progress tracking'],
      exportFormats: ['PDF', 'DOCX', 'Markdown', 'HTML'],
      progressMetric: 'lessons',
      suggestedGoal: 20,
      suggestedTimeframe: Duration(days: 60),
      isPremium: false,
    ),
    EliteProjectType.podcast: ProjectTypeMetadata(
      type: EliteProjectType.podcast,
      name: 'Podcast',
      emoji: '🎙️',
      tagline: 'Share your voice',
      description: 'Plan podcast episodes with show notes and scripts.',
      primaryColor: Color(0xFFF59E0B),
      accentColor: Color(0xFFFFFBEB),
      icon: Icons.podcasts,
      benefits: ['Episode planning', 'Show notes', 'Guest tracking', 'Script templates'],
      exportFormats: ['PDF', 'TXT', 'Markdown'],
      progressMetric: 'episodes',
      suggestedGoal: 52,
      suggestedTimeframe: Duration(days: 365),
      isPremium: false,
    ),
    EliteProjectType.youtube: ProjectTypeMetadata(
      type: EliteProjectType.youtube,
      name: 'YouTube Channel',
      emoji: '📺',
      tagline: 'Create content',
      description: 'Script videos and plan your content calendar.',
      primaryColor: Color(0xFFEF4444),
      accentColor: Color(0xFFFEF2F2),
      icon: Icons.play_circle_fill,
      benefits: ['Video scripts', 'Thumbnail ideas', 'SEO descriptions', 'Content calendar'],
      exportFormats: ['TXT', 'PDF', 'Markdown'],
      progressMetric: 'videos',
      suggestedGoal: 100,
      suggestedTimeframe: Duration(days: 365),
      isPremium: true,
    ),
    EliteProjectType.blog: ProjectTypeMetadata(
      type: EliteProjectType.blog,
      name: 'Blog / Newsletter',
      emoji: '📰',
      tagline: 'Build your audience',
      description: 'Write articles and maintain your editorial calendar.',
      primaryColor: Color(0xFF3B82F6),
      accentColor: Color(0xFFEFF6FF),
      icon: Icons.article,
      benefits: ['Editorial calendar', 'SEO optimization', 'Series organization', 'Export to platforms'],
      exportFormats: ['Markdown', 'HTML', 'PDF', 'TXT'],
      progressMetric: 'articles',
      suggestedGoal: 52,
      suggestedTimeframe: Duration(days: 365),
      isPremium: false,
    ),
    EliteProjectType.research: ProjectTypeMetadata(
      type: EliteProjectType.research,
      name: 'Research / Thesis',
      emoji: '📚',
      tagline: 'Academic excellence',
      description: 'Structure your research with proper academic formatting.',
      primaryColor: Color(0xFF8B5CF6),
      accentColor: Color(0xFFF5F3FF),
      icon: Icons.science,
      benefits: ['Academic structure', 'Citation management', 'Literature review', 'LaTeX export'],
      exportFormats: ['PDF', 'LaTeX', 'DOCX', 'Markdown'],
      progressMetric: 'sections',
      suggestedGoal: 8,
      suggestedTimeframe: Duration(days: 180),
      isPremium: true,
    ),
    EliteProjectType.business: ProjectTypeMetadata(
      type: EliteProjectType.business,
      name: 'Business Plan',
      emoji: '💼',
      tagline: 'Plan for success',
      description: 'Create investor-ready business plans.',
      primaryColor: Color(0xFF64748B),
      accentColor: Color(0xFFF8FAFC),
      icon: Icons.business_center,
      benefits: ['Standard structure', 'Financial projections', 'Market analysis', 'Executive summary'],
      exportFormats: ['PDF', 'DOCX', 'Markdown'],
      progressMetric: 'sections',
      suggestedGoal: 10,
      suggestedTimeframe: Duration(days: 30),
      isPremium: true,
    ),
    EliteProjectType.memoir: ProjectTypeMetadata(
      type: EliteProjectType.memoir,
      name: 'Memoir / Life Story',
      emoji: '📝',
      tagline: 'Preserve your legacy',
      description: 'Capture your life stories organized by era or theme.',
      primaryColor: Color(0xFFEC4899),
      accentColor: Color(0xFFFDF2F8),
      icon: Icons.history_edu,
      benefits: ['Timeline organization', 'Memory prompts', 'Era grouping', 'Family archive'],
      exportFormats: ['EPUB', 'PDF', 'DOCX'],
      progressMetric: 'stories',
      suggestedGoal: 50,
      suggestedTimeframe: Duration(days: 180),
      isPremium: true,
    ),
    EliteProjectType.freeform: ProjectTypeMetadata(
      type: EliteProjectType.freeform,
      name: 'Free Form',
      emoji: '📋',
      tagline: 'Your way',
      description: 'Organize recordings with complete flexibility.',
      primaryColor: Color(0xFF6B7280),
      accentColor: Color(0xFFF9FAFB),
      icon: Icons.folder_open,
      benefits: ['Complete flexibility', 'Custom organization', 'Quick start', 'No structure required'],
      exportFormats: ['PDF', 'DOCX', 'Markdown', 'TXT'],
      progressMetric: 'items',
      suggestedGoal: null,
      suggestedTimeframe: null,
      isPremium: false,
    ),
  };

  static ProjectTypeMetadata get(EliteProjectType type) => all[type]!;
}

// =============================================================================
// PROJECT STRUCTURE
// =============================================================================

class ProjectStructure {
  final List<ProjectSection> sections;
  final int totalSections;
  final int completedSections;

  const ProjectStructure({
    this.sections = const [],
    this.totalSections = 0,
    this.completedSections = 0,
  });

  ProjectStructure copyWith({
    List<ProjectSection>? sections,
    int? totalSections,
    int? completedSections,
  }) {
    return ProjectStructure(
      sections: sections ?? this.sections,
      totalSections: totalSections ?? this.totalSections,
      completedSections: completedSections ?? this.completedSections,
    );
  }

  Map<String, dynamic> toJson() => {
    'sections': sections.map((s) => s.toJson()).toList(),
    'totalSections': totalSections,
    'completedSections': completedSections,
  };

  factory ProjectStructure.fromJson(Map<String, dynamic> json) => ProjectStructure(
    sections: (json['sections'] as List?)?.map((s) => ProjectSection.fromJson(s)).toList() ?? [],
    totalSections: json['totalSections'] ?? 0,
    completedSections: json['completedSections'] ?? 0,
  );
}

// =============================================================================
// PROJECT SECTION
// =============================================================================

class ProjectSection {
  final String id;
  final String title;
  final String? subtitle;
  final String? description;
  final String? content;
  final SectionStatus status;
  final int order;
  final List<String> recordingIds;
  final int wordCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;
  final List<ProjectSection>? subsections;
  final List<ProjectSection> children;

  ProjectSection({
    required this.id,
    required this.title,
    this.subtitle,
    this.description,
    this.content,
    this.status = SectionStatus.notStarted,
    this.order = 0,
    this.recordingIds = const [],
    this.wordCount = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.metadata,
    this.subsections,
    this.children = const [],
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  ProjectSection copyWith({
    String? title,
    String? subtitle,
    String? description,
    String? content,
    SectionStatus? status,
    int? order,
    List<String>? recordingIds,
    int? wordCount,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
    List<ProjectSection>? subsections,
    List<ProjectSection>? children,
  }) {
    return ProjectSection(
      id: id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      content: content ?? this.content,
      status: status ?? this.status,
      order: order ?? this.order,
      recordingIds: recordingIds ?? this.recordingIds,
      wordCount: wordCount ?? this.wordCount,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      metadata: metadata ?? this.metadata,
      subsections: subsections ?? this.subsections,
      children: children ?? this.children,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subtitle': subtitle,
    'description': description,
    'content': content,
    'status': status.name,
    'order': order,
    'recordingIds': recordingIds,
    'wordCount': wordCount,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'metadata': metadata,
    'subsections': subsections?.map((s) => s.toJson()).toList(),
    'children': children.map((c) => c.toJson()).toList(),
  };

  factory ProjectSection.fromJson(Map<String, dynamic> json) => ProjectSection(
    id: json['id'],
    title: json['title'],
    subtitle: json['subtitle'],
    description: json['description'],
    content: json['content'],
    status: SectionStatus.values.firstWhere(
      (s) => s.name == json['status'],
      orElse: () => SectionStatus.notStarted,
    ),
    order: json['order'] ?? 0,
    recordingIds: List<String>.from(json['recordingIds'] ?? []),
    wordCount: json['wordCount'] ?? 0,
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    metadata: json['metadata'],
    subsections: json['subsections'] != null
        ? (json['subsections'] as List).map((s) => ProjectSection.fromJson(s)).toList()
        : null,
    children: json['children'] != null
        ? (json['children'] as List).map((c) => ProjectSection.fromJson(c)).toList()
        : [],
  );
}

// =============================================================================
// SECTION STATUS ENUM
// =============================================================================

enum SectionStatus {
  notStarted,
  inProgress,
  drafted,
  reviewing,
  completed,
  complete,  // Alias for completed
}

extension SectionStatusExtension on SectionStatus {
  String get displayName {
    switch (this) {
      case SectionStatus.notStarted: return 'Not Started';
      case SectionStatus.inProgress: return 'In Progress';
      case SectionStatus.drafted: return 'Drafted';
      case SectionStatus.reviewing: return 'Reviewing';
      case SectionStatus.completed: return 'Completed';
      case SectionStatus.complete: return 'Complete';
    }
  }

  String get emoji {
    switch (this) {
      case SectionStatus.notStarted: return '⚪';
      case SectionStatus.inProgress: return '🔵';
      case SectionStatus.drafted: return '🟠';
      case SectionStatus.reviewing: return '🟣';
      case SectionStatus.completed: return '🟢';
      case SectionStatus.complete: return '🟢';
    }
  }

  Color get color {
    switch (this) {
      case SectionStatus.notStarted: return Colors.grey;
      case SectionStatus.inProgress: return Colors.blue;
      case SectionStatus.drafted: return Colors.orange;
      case SectionStatus.reviewing: return Colors.purple;
      case SectionStatus.completed: return Colors.green;
      case SectionStatus.complete: return Colors.green;
    }
  }
}

// =============================================================================
// PROJECT PROGRESS
// =============================================================================

class ProjectProgress {
  final int totalWordCount;
  final int sectionsComplete;
  final int totalSections;
  final DateTime? lastWorkedOn;
  final List<DailyProgress> dailyHistory;
  final int currentStreak;
  final int longestStreak;
  final Map<String, int> dailyProgress;
  final int wordCount;
  final int? targetWordCount;
  final int sessionsCount;
  final int totalTimeMinutes;
  final DateTime? lastSessionAt;

  const ProjectProgress({
    this.totalWordCount = 0,
    this.sectionsComplete = 0,
    this.totalSections = 0,
    this.lastWorkedOn,
    this.dailyHistory = const [],
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.dailyProgress = const {},
    this.wordCount = 0,
    this.targetWordCount,
    this.sessionsCount = 0,
    this.totalTimeMinutes = 0,
    this.lastSessionAt,
  });

  double get percentComplete {
    if (totalSections == 0) return 0.0;
    return (sectionsComplete / totalSections).clamp(0.0, 1.0);
  }

  ProjectProgress copyWith({
    int? totalWordCount,
    int? sectionsComplete,
    int? totalSections,
    DateTime? lastWorkedOn,
    List<DailyProgress>? dailyHistory,
    int? currentStreak,
    int? longestStreak,
    Map<String, int>? dailyProgress,
    int? wordCount,
    int? targetWordCount,
    int? sessionsCount,
    int? totalTimeMinutes,
    DateTime? lastSessionAt,
  }) {
    return ProjectProgress(
      totalWordCount: totalWordCount ?? this.totalWordCount,
      sectionsComplete: sectionsComplete ?? this.sectionsComplete,
      totalSections: totalSections ?? this.totalSections,
      lastWorkedOn: lastWorkedOn ?? this.lastWorkedOn,
      dailyHistory: dailyHistory ?? this.dailyHistory,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      dailyProgress: dailyProgress ?? this.dailyProgress,
      wordCount: wordCount ?? this.wordCount,
      targetWordCount: targetWordCount ?? this.targetWordCount,
      sessionsCount: sessionsCount ?? this.sessionsCount,
      totalTimeMinutes: totalTimeMinutes ?? this.totalTimeMinutes,
      lastSessionAt: lastSessionAt ?? this.lastSessionAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'totalWordCount': totalWordCount,
    'sectionsComplete': sectionsComplete,
    'totalSections': totalSections,
    'lastWorkedOn': lastWorkedOn?.toIso8601String(),
    'dailyHistory': dailyHistory.map((d) => d.toJson()).toList(),
    'currentStreak': currentStreak,
    'longestStreak': longestStreak,
    'dailyProgress': dailyProgress,
    'wordCount': wordCount,
    'targetWordCount': targetWordCount,
    'sessionsCount': sessionsCount,
    'totalTimeMinutes': totalTimeMinutes,
    'lastSessionAt': lastSessionAt?.toIso8601String(),
  };

  factory ProjectProgress.fromJson(Map<String, dynamic> json) => ProjectProgress(
    totalWordCount: json['totalWordCount'] ?? 0,
    sectionsComplete: json['sectionsComplete'] ?? 0,
    totalSections: json['totalSections'] ?? 0,
    lastWorkedOn: json['lastWorkedOn'] != null ? DateTime.parse(json['lastWorkedOn']) : null,
    dailyHistory: (json['dailyHistory'] as List?)?.map((d) => DailyProgress.fromJson(d)).toList() ?? [],
    currentStreak: json['currentStreak'] ?? 0,
    longestStreak: json['longestStreak'] ?? 0,
    dailyProgress: Map<String, int>.from(json['dailyProgress'] ?? {}),
    wordCount: json['wordCount'] ?? 0,
    targetWordCount: json['targetWordCount'],
    sessionsCount: json['sessionsCount'] ?? 0,
    totalTimeMinutes: json['totalTimeMinutes'] ?? 0,
    lastSessionAt: json['lastSessionAt'] != null ? DateTime.parse(json['lastSessionAt']) : null,
  );
}

// =============================================================================
// DAILY PROGRESS
// =============================================================================

class DailyProgress {
  final DateTime date;
  final int wordsWritten;
  final int minutesWorked;
  final int sectionsCompleted;

  const DailyProgress({
    required this.date,
    this.wordsWritten = 0,
    this.minutesWorked = 0,
    this.sectionsCompleted = 0,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'wordsWritten': wordsWritten,
    'minutesWorked': minutesWorked,
    'sectionsCompleted': sectionsCompleted,
  };

  factory DailyProgress.fromJson(Map<String, dynamic> json) => DailyProgress(
    date: DateTime.parse(json['date']),
    wordsWritten: json['wordsWritten'] ?? 0,
    minutesWorked: json['minutesWorked'] ?? 0,
    sectionsCompleted: json['sectionsCompleted'] ?? 0,
  );
}

// =============================================================================
// PROJECT GOALS
// =============================================================================

class ProjectGoals {
  final int? targetWordCount;
  final DateTime? deadline;
  final int? dailyWordGoal;
  final DateTime? completionDeadline;
  final int? dailyWordTarget;
  final int? weeklySessionTarget;
  final bool isActive;

  const ProjectGoals({
    this.targetWordCount,
    this.deadline,
    this.dailyWordGoal,
    this.completionDeadline,
    this.dailyWordTarget,
    this.weeklySessionTarget,
    this.isActive = true,
  });

  ProjectGoals copyWith({
    int? targetWordCount,
    DateTime? deadline,
    int? dailyWordGoal,
    DateTime? completionDeadline,
    int? dailyWordTarget,
    int? weeklySessionTarget,
    bool? isActive,
  }) {
    return ProjectGoals(
      targetWordCount: targetWordCount ?? this.targetWordCount,
      deadline: deadline ?? this.deadline,
      dailyWordGoal: dailyWordGoal ?? this.dailyWordGoal,
      completionDeadline: completionDeadline ?? this.completionDeadline,
      dailyWordTarget: dailyWordTarget ?? this.dailyWordTarget,
      weeklySessionTarget: weeklySessionTarget ?? this.weeklySessionTarget,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() => {
    'targetWordCount': targetWordCount,
    'deadline': deadline?.toIso8601String(),
    'dailyWordGoal': dailyWordGoal,
    'completionDeadline': completionDeadline?.toIso8601String(),
    'dailyWordTarget': dailyWordTarget,
    'weeklySessionTarget': weeklySessionTarget,
    'isActive': isActive,
  };

  factory ProjectGoals.fromJson(Map<String, dynamic> json) => ProjectGoals(
    targetWordCount: json['targetWordCount'],
    deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
    dailyWordGoal: json['dailyWordGoal'],
    completionDeadline: json['completionDeadline'] != null ? DateTime.parse(json['completionDeadline']) : null,
    dailyWordTarget: json['dailyWordTarget'],
    weeklySessionTarget: json['weeklySessionTarget'],
    isActive: json['isActive'] ?? true,
  );
}

// =============================================================================
// PROJECT GOAL (Individual)
// =============================================================================

class ProjectGoal {
  final String id;
  final String name;
  final GoalType type;
  final int targetValue;
  final int currentValue;
  final DateTime? deadline;
  final bool isCompleted;
  final DateTime createdAt;

  const ProjectGoal({
    required this.id,
    required this.name,
    required this.type,
    required this.targetValue,
    this.currentValue = 0,
    this.deadline,
    this.isCompleted = false,
    required this.createdAt,
  });

  double get progressPercent => 
      targetValue > 0 ? (currentValue / targetValue).clamp(0.0, 1.0) : 0.0;

  bool get isOverdue => 
      deadline != null && DateTime.now().isAfter(deadline!) && !isCompleted;

  int get daysRemaining => 
      deadline != null ? deadline!.difference(DateTime.now()).inDays : 0;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type.name,
    'targetValue': targetValue,
    'currentValue': currentValue,
    'deadline': deadline?.toIso8601String(),
    'isCompleted': isCompleted,
    'createdAt': createdAt.toIso8601String(),
  };

  factory ProjectGoal.fromJson(Map<String, dynamic> json) => ProjectGoal(
    id: json['id'],
    name: json['name'],
    type: GoalType.values.firstWhere((t) => t.name == json['type']),
    targetValue: json['targetValue'],
    currentValue: json['currentValue'] ?? 0,
    deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
    isCompleted: json['isCompleted'] ?? false,
    createdAt: DateTime.parse(json['createdAt']),
  );
}

enum GoalType {
  words,
  sections,
  episodes,
  lessons,
  articles,
  videos,
  stories,
  custom,
}

// =============================================================================
// PLOT POINT TYPE ENUM
// =============================================================================

enum PlotPointType {
  event,
  revelation,
  conflict,
  resolution,
  foreshadowing,
  callback,
  twist,
}

// =============================================================================
// PLOT POINT
// =============================================================================

class PlotPoint {
  final String id;
  final String description;
  final String? sectionId;
  final int order;
  final bool isResolved;
  final PlotPointType type;

  const PlotPoint({
    required this.id,
    required this.description,
    this.sectionId,
    this.order = 0,
    this.isResolved = false,
    this.type = PlotPointType.event,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'description': description,
    'sectionId': sectionId,
    'order': order,
    'isResolved': isResolved,
    'type': type.name,
  };

  factory PlotPoint.fromJson(Map<String, dynamic> json) => PlotPoint(
    id: json['id'],
    description: json['description'],
    sectionId: json['sectionId'],
    order: json['order'] ?? 0,
    isResolved: json['isResolved'] ?? false,
    type: json['type'] != null
        ? PlotPointType.values.firstWhere(
            (t) => t.name == json['type'],
            orElse: () => PlotPointType.event,
          )
        : PlotPointType.event,
  );
}

// =============================================================================
// CHARACTER MEMORY
// =============================================================================

class CharacterMemory {
  final String id;
  final String name;
  final String description;
  final List<String> traits;
  final Map<String, String> relationships;
  final String? backstory;
  final Map<String, dynamic>? customFields;
  final String? voiceStyle;
  final String? appearance;

  const CharacterMemory({
    required this.id,
    required this.name,
    this.description = '',
    this.traits = const [],
    this.relationships = const {},
    this.backstory,
    this.customFields,
    this.voiceStyle,
    this.appearance,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'traits': traits,
    'relationships': relationships,
    'backstory': backstory,
    'customFields': customFields,
    'voiceStyle': voiceStyle,
    'appearance': appearance,
  };

  factory CharacterMemory.fromJson(Map<String, dynamic> json) => CharacterMemory(
    id: json['id'],
    name: json['name'],
    description: json['description'] ?? '',
    traits: List<String>.from(json['traits'] ?? []),
    relationships: Map<String, String>.from(json['relationships'] ?? {}),
    backstory: json['backstory'],
    customFields: json['customFields'],
    voiceStyle: json['voiceStyle'],
    appearance: json['appearance'],
  );
}

// =============================================================================
// LOCATION MEMORY
// =============================================================================

class LocationMemory {
  final String id;
  final String name;
  final String description;
  final List<String> features;
  final String? mood;
  final String? atmosphere;

  const LocationMemory({
    required this.id,
    required this.name,
    this.description = '',
    this.features = const [],
    this.mood,
    this.atmosphere,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'features': features,
    'mood': mood,
    'atmosphere': atmosphere,
  };

  factory LocationMemory.fromJson(Map<String, dynamic> json) => LocationMemory(
    id: json['id'],
    name: json['name'],
    description: json['description'] ?? '',
    features: List<String>.from(json['features'] ?? []),
    mood: json['mood'],
    atmosphere: json['atmosphere'],
  );
}

// =============================================================================
// CONCEPT MEMORY
// =============================================================================

class ConceptMemory {
  final String id;
  final String name;
  final String definition;
  final List<String> relatedTerms;

  const ConceptMemory({
    required this.id,
    required this.name,
    required this.definition,
    this.relatedTerms = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'definition': definition,
    'relatedTerms': relatedTerms,
  };

  factory ConceptMemory.fromJson(Map<String, dynamic> json) => ConceptMemory(
    id: json['id'],
    name: json['name'],
    definition: json['definition'],
    relatedTerms: List<String>.from(json['relatedTerms'] ?? []),
  );
}

// =============================================================================
// TOPIC MEMORY
// =============================================================================

class TopicMemory {
  final String id;
  final String name;
  final String description;
  final List<String> keyPoints;

  const TopicMemory({
    required this.id,
    required this.name,
    this.description = '',
    this.keyPoints = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'keyPoints': keyPoints,
  };

  factory TopicMemory.fromJson(Map<String, dynamic> json) => TopicMemory(
    id: json['id'],
    name: json['name'],
    description: json['description'] ?? '',
    keyPoints: List<String>.from(json['keyPoints'] ?? []),
  );
}

// =============================================================================
// FACT MEMORY
// =============================================================================

class FactMemory {
  final String id;
  final String fact;
  final String? category;
  final bool isImportant;

  const FactMemory({
    required this.id,
    required this.fact,
    this.category,
    this.isImportant = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'fact': fact,
    'category': category,
    'isImportant': isImportant,
  };

  factory FactMemory.fromJson(Map<String, dynamic> json) => FactMemory(
    id: json['id'],
    fact: json['fact'],
    category: json['category'],
    isImportant: json['isImportant'] ?? false,
  );
}

// =============================================================================
// STYLE MEMORY
// =============================================================================

class StyleMemory {
  final String? tone;
  final String? pointOfView;
  final String? tense;
  final List<String> avoidWords;
  final List<String> preferWords;
  final String? customInstructions;

  const StyleMemory({
    this.tone,
    this.pointOfView,
    this.tense,
    this.avoidWords = const [],
    this.preferWords = const [],
    this.customInstructions,
  });

  String toContextString() {
    final parts = <String>[];
    if (tone != null) parts.add('Tone: $tone');
    if (pointOfView != null) parts.add('POV: $pointOfView');
    if (tense != null) parts.add('Tense: $tense');
    if (avoidWords.isNotEmpty) parts.add('Avoid: ${avoidWords.join(", ")}');
    if (preferWords.isNotEmpty) parts.add('Prefer: ${preferWords.join(", ")}');
    if (customInstructions != null) parts.add('Instructions: $customInstructions');
    return parts.join('\n');
  }

  Map<String, dynamic> toJson() => {
    'tone': tone,
    'pointOfView': pointOfView,
    'tense': tense,
    'avoidWords': avoidWords,
    'preferWords': preferWords,
    'customInstructions': customInstructions,
  };

  factory StyleMemory.fromJson(Map<String, dynamic> json) => StyleMemory(
    tone: json['tone'],
    pointOfView: json['pointOfView'],
    tense: json['tense'],
    avoidWords: List<String>.from(json['avoidWords'] ?? []),
    preferWords: List<String>.from(json['preferWords'] ?? []),
    customInstructions: json['customInstructions'],
  );
}

// =============================================================================
// PROJECT AI MEMORY
// =============================================================================

class ProjectAIMemory {
  final List<CharacterMemory> characters;
  final List<LocationMemory> locations;
  final List<TopicMemory> topics;
  final List<FactMemory> facts;
  final List<PlotPoint> plotPoints;
  final StyleMemory style;

  const ProjectAIMemory({
    this.characters = const [],
    this.locations = const [],
    this.topics = const [],
    this.facts = const [],
    this.plotPoints = const [],
    this.style = const StyleMemory(),
  });

  String toContextString() {
    final parts = <String>[];
    
    if (characters.isNotEmpty) {
      parts.add('Characters: ${characters.map((c) => c.name).join(", ")}');
    }
    if (locations.isNotEmpty) {
      parts.add('Locations: ${locations.map((l) => l.name).join(", ")}');
    }
    if (topics.isNotEmpty) {
      parts.add('Topics: ${topics.map((t) => t.name).join(", ")}');
    }
    if (facts.isNotEmpty) {
      parts.add('Facts: ${facts.map((f) => f.fact).join("; ")}');
    }
    
    final styleContext = style.toContextString();
    if (styleContext.isNotEmpty) {
      parts.add('Style:\n$styleContext');
    }
    
    return parts.join('\n\n');
  }

  ProjectAIMemory copyWith({
    List<CharacterMemory>? characters,
    List<LocationMemory>? locations,
    List<TopicMemory>? topics,
    List<FactMemory>? facts,
    List<PlotPoint>? plotPoints,
    StyleMemory? style,
  }) {
    return ProjectAIMemory(
      characters: characters ?? this.characters,
      locations: locations ?? this.locations,
      topics: topics ?? this.topics,
      facts: facts ?? this.facts,
      plotPoints: plotPoints ?? this.plotPoints,
      style: style ?? this.style,
    );
  }

  Map<String, dynamic> toJson() => {
    'characters': characters.map((c) => c.toJson()).toList(),
    'locations': locations.map((l) => l.toJson()).toList(),
    'topics': topics.map((t) => t.toJson()).toList(),
    'facts': facts.map((f) => f.toJson()).toList(),
    'plotPoints': plotPoints.map((p) => p.toJson()).toList(),
    'style': style.toJson(),
  };

  factory ProjectAIMemory.fromJson(Map<String, dynamic> json) => ProjectAIMemory(
    characters: (json['characters'] as List?)?.map((c) => CharacterMemory.fromJson(c)).toList() ?? [],
    locations: (json['locations'] as List?)?.map((l) => LocationMemory.fromJson(l)).toList() ?? [],
    topics: (json['topics'] as List?)?.map((t) => TopicMemory.fromJson(t)).toList() ?? [],
    facts: (json['facts'] as List?)?.map((f) => FactMemory.fromJson(f)).toList() ?? [],
    plotPoints: (json['plotPoints'] as List?)?.map((p) => PlotPoint.fromJson(p)).toList() ?? [],
    style: json['style'] != null ? StyleMemory.fromJson(json['style']) : const StyleMemory(),
  );
}

// =============================================================================
// PROJECT MEMORY (with Maps)
// =============================================================================

class ProjectMemory {
  final Map<String, CharacterMemory> characters;
  final Map<String, LocationMemory> locations;
  final Map<String, ConceptMemory> concepts;
  final List<PlotPoint> plotPoints;
  final Map<String, String> customFacts;
  final String? voiceStyle;
  final String? targetAudience;
  final DateTime lastUpdated;
  final List<TopicMemory> topics;
  final List<FactMemory> facts;
  final StyleMemory style;

  const ProjectMemory({
    this.characters = const {},
    this.locations = const {},
    this.concepts = const {},
    this.plotPoints = const [],
    this.customFacts = const {},
    this.voiceStyle,
    this.targetAudience,
    required this.lastUpdated,
    this.topics = const [],
    this.facts = const [],
    this.style = const StyleMemory(),
  });

  String toContextString() {
    final parts = <String>[];
    
    if (characters.isNotEmpty) {
      parts.add('Characters: ${characters.values.map((c) => c.name).join(", ")}');
    }
    if (locations.isNotEmpty) {
      parts.add('Locations: ${locations.values.map((l) => l.name).join(", ")}');
    }
    if (topics.isNotEmpty) {
      parts.add('Topics: ${topics.map((t) => t.name).join(", ")}');
    }
    if (facts.isNotEmpty) {
      parts.add('Facts: ${facts.map((f) => f.fact).join("; ")}');
    }
    if (voiceStyle != null) {
      parts.add('Voice Style: $voiceStyle');
    }
    
    final styleContext = style.toContextString();
    if (styleContext.isNotEmpty) {
      parts.add('Style:\n$styleContext');
    }
    
    return parts.join('\n\n');
  }

  ProjectMemory copyWith({
    Map<String, CharacterMemory>? characters,
    Map<String, LocationMemory>? locations,
    Map<String, ConceptMemory>? concepts,
    List<PlotPoint>? plotPoints,
    Map<String, String>? customFacts,
    String? voiceStyle,
    String? targetAudience,
    DateTime? lastUpdated,
    List<TopicMemory>? topics,
    List<FactMemory>? facts,
    StyleMemory? style,
  }) {
    return ProjectMemory(
      characters: characters ?? this.characters,
      locations: locations ?? this.locations,
      concepts: concepts ?? this.concepts,
      plotPoints: plotPoints ?? this.plotPoints,
      customFacts: customFacts ?? this.customFacts,
      voiceStyle: voiceStyle ?? this.voiceStyle,
      targetAudience: targetAudience ?? this.targetAudience,
      lastUpdated: lastUpdated ?? DateTime.now(),
      topics: topics ?? this.topics,
      facts: facts ?? this.facts,
      style: style ?? this.style,
    );
  }

  Map<String, dynamic> toJson() => {
    'characters': characters.map((k, v) => MapEntry(k, v.toJson())),
    'locations': locations.map((k, v) => MapEntry(k, v.toJson())),
    'concepts': concepts.map((k, v) => MapEntry(k, v.toJson())),
    'plotPoints': plotPoints.map((p) => p.toJson()).toList(),
    'customFacts': customFacts,
    'voiceStyle': voiceStyle,
    'targetAudience': targetAudience,
    'lastUpdated': lastUpdated.toIso8601String(),
    'topics': topics.map((t) => t.toJson()).toList(),
    'facts': facts.map((f) => f.toJson()).toList(),
    'style': style.toJson(),
  };

  factory ProjectMemory.fromJson(Map<String, dynamic> json) => ProjectMemory(
    characters: (json['characters'] as Map<String, dynamic>?)
        ?.map((k, v) => MapEntry(k, CharacterMemory.fromJson(v))) ?? {},
    locations: (json['locations'] as Map<String, dynamic>?)
        ?.map((k, v) => MapEntry(k, LocationMemory.fromJson(v))) ?? {},
    concepts: (json['concepts'] as Map<String, dynamic>?)
        ?.map((k, v) => MapEntry(k, ConceptMemory.fromJson(v))) ?? {},
    plotPoints: (json['plotPoints'] as List?)
        ?.map((p) => PlotPoint.fromJson(p)).toList() ?? [],
    customFacts: Map<String, String>.from(json['customFacts'] ?? {}),
    voiceStyle: json['voiceStyle'],
    targetAudience: json['targetAudience'],
    lastUpdated: json['lastUpdated'] != null 
        ? DateTime.parse(json['lastUpdated']) 
        : DateTime.now(),
    topics: (json['topics'] as List?)
        ?.map((t) => TopicMemory.fromJson(t)).toList() ?? [],
    facts: (json['facts'] as List?)
        ?.map((f) => FactMemory.fromJson(f)).toList() ?? [],
    style: json['style'] != null 
        ? StyleMemory.fromJson(json['style']) 
        : const StyleMemory(),
  );
}

// =============================================================================
// PROJECT TEMPLATE
// =============================================================================

class ProjectTemplate {
  final String id;
  final String name;
  final String description;
  final EliteProjectType type;
  final List<ProjectSection> sections;
  final ProjectGoals? suggestedGoals;
  final StyleMemory? suggestedStyle;
  final String? icon;

  const ProjectTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.sections = const [],
    this.suggestedGoals,
    this.suggestedStyle,
    this.icon,
  });

  ProjectStructure generateStructure() {
    return ProjectStructure(
      sections: sections,
      totalSections: sections.length,
      completedSections: 0,
    );
  }
}

// =============================================================================
// PROJECT PRESET
// =============================================================================

class ProjectPreset {
  final String id;
  final String name;
  final String description;
  final String prompt;
  final EliteProjectType projectType;

  const ProjectPreset({
    required this.id,
    required this.name,
    required this.description,
    required this.prompt,
    required this.projectType,
  });
}

// =============================================================================
// ELITE PROJECT - THE MAIN MODEL
// =============================================================================

class EliteProject {
  final String id;
  final String name;
  final String? description;
  final String? subtitle;
  final EliteProjectType type;
  final int colorIndex;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastOpenedAt;
  final List<ProjectSection> sections;
  final String? currentSectionId;
  final ProjectStructure structure;
  final List<ProjectGoal> goals;
  final int totalWordCount;
  final ProjectProgress progress;
  final ProjectGoals? projectGoals;
  final ProjectMemory? memory;
  final ProjectAIMemory aiMemory;
  final Map<String, dynamic>? settings;
  final String? templateId;
  final String? coverImagePath;
  final List<String> tags;
  final List<String> itemIds;
  final bool isArchived;
  final bool isPinned;

  EliteProject({
    required this.id,
    required this.name,
    this.description,
    this.subtitle,
    required this.type,
    this.colorIndex = 0,
    required this.createdAt,
    required this.updatedAt,
    this.lastOpenedAt,
    this.sections = const [],
    this.currentSectionId,
    ProjectStructure? structure,
    this.goals = const [],
    this.totalWordCount = 0,
    ProjectProgress? progress,
    this.projectGoals,
    this.memory,
    ProjectAIMemory? aiMemory,
    this.settings,
    this.templateId,
    this.coverImagePath,
    this.tags = const [],
    this.itemIds = const [],
    this.isArchived = false,
    this.isPinned = false,
  }) : structure = structure ?? const ProjectStructure(),
       progress = progress ?? const ProjectProgress(),
       aiMemory = aiMemory ?? const ProjectAIMemory();

  ProjectTypeMetadata get metadata => ProjectTypeMetadata.get(type);

  double get progressPercent {
    if (sections.isEmpty) return 0.0;
    final completed = sections.where((s) => 
      s.status == SectionStatus.completed || s.status == SectionStatus.complete
    ).length;
    return completed / sections.length;
  }

  int get completedSectionsCount => 
      sections.where((s) => 
        s.status == SectionStatus.completed || s.status == SectionStatus.complete
      ).length;

  ProjectSection? get currentSection => 
      currentSectionId != null 
          ? sections.firstWhere(
              (s) => s.id == currentSectionId, 
              orElse: () => sections.isNotEmpty ? sections.first : ProjectSection(id: '', title: ''),
            )
          : sections.isNotEmpty ? sections.first : null;

  EliteProject copyWith({
    String? name,
    String? description,
    String? subtitle,
    EliteProjectType? type,
    int? colorIndex,
    DateTime? updatedAt,
    DateTime? lastOpenedAt,
    List<ProjectSection>? sections,
    String? currentSectionId,
    ProjectStructure? structure,
    List<ProjectGoal>? goals,
    int? totalWordCount,
    ProjectProgress? progress,
    ProjectGoals? projectGoals,
    ProjectMemory? memory,
    ProjectAIMemory? aiMemory,
    Map<String, dynamic>? settings,
    String? templateId,
    String? coverImagePath,
    List<String>? tags,
    List<String>? itemIds,
    bool? isArchived,
    bool? isPinned,
  }) {
    return EliteProject(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      subtitle: subtitle ?? this.subtitle,
      type: type ?? this.type,
      colorIndex: colorIndex ?? this.colorIndex,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      lastOpenedAt: lastOpenedAt ?? this.lastOpenedAt,
      sections: sections ?? this.sections,
      currentSectionId: currentSectionId ?? this.currentSectionId,
      structure: structure ?? this.structure,
      goals: goals ?? this.goals,
      totalWordCount: totalWordCount ?? this.totalWordCount,
      progress: progress ?? this.progress,
      projectGoals: projectGoals ?? this.projectGoals,
      memory: memory ?? this.memory,
      aiMemory: aiMemory ?? this.aiMemory,
      settings: settings ?? this.settings,
      templateId: templateId ?? this.templateId,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      tags: tags ?? this.tags,
      itemIds: itemIds ?? this.itemIds,
      isArchived: isArchived ?? this.isArchived,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'subtitle': subtitle,
    'type': type.name,
    'colorIndex': colorIndex,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'lastOpenedAt': lastOpenedAt?.toIso8601String(),
    'sections': sections.map((s) => s.toJson()).toList(),
    'currentSectionId': currentSectionId,
    'structure': structure.toJson(),
    'goals': goals.map((g) => g.toJson()).toList(),
    'totalWordCount': totalWordCount,
    'progress': progress.toJson(),
    'projectGoals': projectGoals?.toJson(),
    'memory': memory?.toJson(),
    'aiMemory': aiMemory.toJson(),
    'settings': settings,
    'templateId': templateId,
    'coverImagePath': coverImagePath,
    'tags': tags,
    'itemIds': itemIds,
    'isArchived': isArchived,
    'isPinned': isPinned,
  };

  factory EliteProject.fromJson(Map<String, dynamic> json) => EliteProject(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    subtitle: json['subtitle'],
    type: EliteProjectType.values.firstWhere(
      (t) => t.name == json['type'],
      orElse: () => EliteProjectType.freeform,
    ),
    colorIndex: json['colorIndex'] ?? 0,
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    lastOpenedAt: json['lastOpenedAt'] != null ? DateTime.parse(json['lastOpenedAt']) : null,
    sections: (json['sections'] as List?)?.map((s) => ProjectSection.fromJson(s)).toList() ?? [],
    currentSectionId: json['currentSectionId'],
    structure: json['structure'] != null 
        ? ProjectStructure.fromJson(json['structure']) 
        : const ProjectStructure(),
    goals: (json['goals'] as List?)?.map((g) => ProjectGoal.fromJson(g)).toList() ?? [],
    totalWordCount: json['totalWordCount'] ?? 0,
    progress: json['progress'] != null 
        ? ProjectProgress.fromJson(json['progress']) 
        : const ProjectProgress(),
    projectGoals: json['projectGoals'] != null 
        ? ProjectGoals.fromJson(json['projectGoals']) 
        : null,
    memory: json['memory'] != null 
        ? ProjectMemory.fromJson(json['memory']) 
        : null,
    aiMemory: json['aiMemory'] != null 
        ? ProjectAIMemory.fromJson(json['aiMemory']) 
        : const ProjectAIMemory(),
    settings: json['settings'],
    templateId: json['templateId'],
    coverImagePath: json['coverImagePath'],
    tags: List<String>.from(json['tags'] ?? []),
    itemIds: List<String>.from(json['itemIds'] ?? []),
    isArchived: json['isArchived'] ?? false,
    isPinned: json['isPinned'] ?? false,
  );
}

// =============================================================================
// PROJECT STATISTICS
// =============================================================================

class ProjectStatistics {
  final int totalProjects;
  final int activeProjects;
  final int archivedProjects;
  final int totalWords;
  final int totalSections;
  final int completedSections;
  final Map<EliteProjectType, int> projectsByType;
  final int currentStreak;
  final int longestStreak;

  const ProjectStatistics({
    this.totalProjects = 0,
    this.activeProjects = 0,
    this.archivedProjects = 0,
    this.totalWords = 0,
    this.totalSections = 0,
    this.completedSections = 0,
    this.projectsByType = const {},
    this.currentStreak = 0,
    this.longestStreak = 0,
  });

  double get completionRate => 
      totalSections > 0 ? completedSections / totalSections : 0.0;

  factory ProjectStatistics.fromProjects(List<EliteProject> projects) {
    int totalWords = 0;
    int totalSections = 0;
    int completedSections = 0;
    final typeCount = <EliteProjectType, int>{};
    int currentStreak = 0;
    int longestStreak = 0;

    for (final project in projects) {
      totalWords += project.progress.totalWordCount;
      totalSections += project.structure.sections.length;
      completedSections += project.completedSectionsCount;
      typeCount[project.type] = (typeCount[project.type] ?? 0) + 1;
      
      if (project.progress.currentStreak > currentStreak) {
        currentStreak = project.progress.currentStreak;
      }
      if (project.progress.longestStreak > longestStreak) {
        longestStreak = project.progress.longestStreak;
      }
    }

    return ProjectStatistics(
      totalProjects: projects.length,
      activeProjects: projects.where((p) => !p.isArchived).length,
      archivedProjects: projects.where((p) => p.isArchived).length,
      totalWords: totalWords,
      totalSections: totalSections,
      completedSections: completedSections,
      projectsByType: typeCount,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
    );
  }
}

// =============================================================================
// ELITE PROJECT TEMPLATE REGISTRY
// =============================================================================

class EliteProjectTemplateRegistry {
  static final Map<String, ProjectTemplate> _templates = {};

  static ProjectTemplate? getTemplate(String id) => _templates[id];

  static List<ProjectTemplate> getTemplatesForType(EliteProjectType type) {
    return _templates.values.where((t) => t.type == type).toList();
  }

  static void registerTemplate(ProjectTemplate template) {
    _templates[template.id] = template;
  }
}
