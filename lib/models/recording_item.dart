import 'package:hive/hive.dart';
import 'outcome_type.dart';

part 'recording_item.g.dart';

@HiveType(typeId: 1)
class RecordingItem {
  @HiveField(0)
  String id;

  @HiveField(1)
  String rawTranscript;

  @HiveField(2)
  String finalText; // User editable

  @HiveField(3)
  String presetUsed; // Display name

  @HiveField(4)
  List<String> outcomes; // Store as strings for Hive

  @HiveField(5)
  String? projectId;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  List<String> editHistory; // Track refinements

  @HiveField(8)
  String presetId; // For backend API

  @HiveField(9)
  String? continuedFromId; // Link to previous item in continuation chain

  @HiveField(10)
  List<String> continuedInIds; // Items that built on this one
  
  @HiveField(11)
  bool hiddenInLibrary; // Hidden from library view
  
  @HiveField(12)
  bool hiddenInOutcomes; // Hidden from outcomes view

  RecordingItem({
    required this.id,
    required this.rawTranscript,
    required this.finalText,
    required this.presetUsed,
    required this.outcomes,
    this.projectId,
    required this.createdAt,
    required this.editHistory,
    required this.presetId,
    this.continuedFromId,
    List<String>? continuedInIds,
    this.hiddenInLibrary = false,
    this.hiddenInOutcomes = false,
  }) : continuedInIds = continuedInIds ?? [];

  // Helper getter to convert string outcomes to enum list
  List<OutcomeType> get outcomeTypes {
    return outcomes
        .map((s) => OutcomeTypeExtension.fromString(s))
        .toList();
  }

  // Helper setter to convert enum list to string list
  set outcomeTypes(List<OutcomeType> types) {
    outcomes = types.map((t) => t.toStorageString()).toList();
  }

  // Formatted date helper (matching ArchivedItem)
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays == 0) {
      return 'Today, ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }

  // Copy with method for updates
  RecordingItem copyWith({
    String? id,
    String? rawTranscript,
    String? finalText,
    String? presetUsed,
    List<String>? outcomes,
    String? projectId,
    DateTime? createdAt,
    List<String>? editHistory,
    String? presetId,
    String? continuedFromId,
    List<String>? continuedInIds,
    bool? hiddenInLibrary,
    bool? hiddenInOutcomes,
  }) {
    return RecordingItem(
      id: id ?? this.id,
      rawTranscript: rawTranscript ?? this.rawTranscript,
      finalText: finalText ?? this.finalText,
      presetUsed: presetUsed ?? this.presetUsed,
      outcomes: outcomes ?? List.from(this.outcomes),
      projectId: projectId ?? this.projectId,
      createdAt: createdAt ?? this.createdAt,
      editHistory: editHistory ?? List.from(this.editHistory),
      presetId: presetId ?? this.presetId,
      continuedFromId: continuedFromId ?? this.continuedFromId,
      continuedInIds: continuedInIds ?? List.from(this.continuedInIds),
      hiddenInLibrary: hiddenInLibrary ?? this.hiddenInLibrary,
      hiddenInOutcomes: hiddenInOutcomes ?? this.hiddenInOutcomes,
    );
  }
}
