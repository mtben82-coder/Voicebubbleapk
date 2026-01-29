import 'package:hive/hive.dart';

part 'document_template.g.dart';

// ============================================================
//        DOCUMENT TEMPLATE MODEL
// ============================================================
//
// The data structure that powers instant productivity.
// Each template is a masterpiece of structured writing.
//
// ============================================================

@HiveType(typeId: 10)
class DocumentTemplate {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  String category; // 'writing', 'business', 'creative', 'personal'

  @HiveField(4)
  String icon; // Icon name for UI

  @HiveField(5)
  String structure; // The template content with placeholders

  @HiveField(6)
  List<VoicePrompt> voicePrompts; // Guided voice sections

  @HiveField(7)
  List<String> tags; // For filtering and search

  @HiveField(8)
  int estimatedTimeMinutes; // How long to complete

  @HiveField(9)
  int wordCountEstimate; // Expected final word count

  @HiveField(10)
  bool isPremium; // Free vs Pro templates

  @HiveField(11)
  DateTime createdAt;

  DocumentTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.icon,
    required this.structure,
    required this.voicePrompts,
    this.tags = const [],
    this.estimatedTimeMinutes = 15,
    this.wordCountEstimate = 500,
    this.isPremium = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Copy with method
  DocumentTemplate copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? icon,
    String? structure,
    List<VoicePrompt>? voicePrompts,
    List<String>? tags,
    int? estimatedTimeMinutes,
    int? wordCountEstimate,
    bool? isPremium,
    DateTime? createdAt,
  }) {
    return DocumentTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      structure: structure ?? this.structure,
      voicePrompts: voicePrompts ?? List.from(this.voicePrompts),
      tags: tags ?? List.from(this.tags),
      estimatedTimeMinutes: estimatedTimeMinutes ?? this.estimatedTimeMinutes,
      wordCountEstimate: wordCountEstimate ?? this.wordCountEstimate,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

@HiveType(typeId: 11)
class VoicePrompt {
  @HiveField(0)
  String id;

  @HiveField(1)
  String placeholder; // The placeholder text in template (e.g., "[Voice: Introduction]")

  @HiveField(2)
  String prompt; // AI prompt to guide user's voice input

  @HiveField(3)
  String example; // Example of what to say

  @HiveField(4)
  int estimatedSeconds; // How long this section should take

  @HiveField(5)
  bool isRequired; // Must be filled vs optional

  VoicePrompt({
    required this.id,
    required this.placeholder,
    required this.prompt,
    required this.example,
    this.estimatedSeconds = 30,
    this.isRequired = true,
  });

  VoicePrompt copyWith({
    String? id,
    String? placeholder,
    String? prompt,
    String? example,
    int? estimatedSeconds,
    bool? isRequired,
  }) {
    return VoicePrompt(
      id: id ?? this.id,
      placeholder: placeholder ?? this.placeholder,
      prompt: prompt ?? this.prompt,
      example: example ?? this.example,
      estimatedSeconds: estimatedSeconds ?? this.estimatedSeconds,
      isRequired: isRequired ?? this.isRequired,
    );
  }
}

// Template categories for organization
enum TemplateCategory {
  writing('writing', 'Writing', '✍️'),
  business('business', 'Business', '💼'),
  creative('creative', 'Creative', '🎨'),
  personal('personal', 'Personal', '📝');

  const TemplateCategory(this.id, this.name, this.icon);
  final String id;
  final String name;
  final String icon;
}