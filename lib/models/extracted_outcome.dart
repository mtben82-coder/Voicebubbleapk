import 'outcome_type.dart';

class ExtractedOutcome {
  final String id;
  final OutcomeType type;
  final String text;
  
  ExtractedOutcome({
    required this.id,
    required this.type,
    required this.text,
  });
  
  // Convert to Map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toStorageString(),
      'text': text,
    };
  }
  
  // Create from JSON
  factory ExtractedOutcome.fromJson(Map<String, dynamic> json) {
    return ExtractedOutcome(
      id: json['id'] as String,
      type: OutcomeTypeExtension.fromString(json['type'] as String),
      text: json['text'] as String,
    );
  }
}
