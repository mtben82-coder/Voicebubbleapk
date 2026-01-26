class UnstuckResponse {
  final String insight;
  final String action;
  
  UnstuckResponse({
    required this.insight,
    required this.action,
  });
  
  // Convert to Map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'insight': insight,
      'action': action,
    };
  }
  
  // Create from JSON
  factory UnstuckResponse.fromJson(Map<String, dynamic> json) {
    return UnstuckResponse(
      insight: json['insight'] as String,
      action: json['action'] as String,
    );
  }
}
