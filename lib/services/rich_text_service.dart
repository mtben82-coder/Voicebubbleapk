// ============================================================
//        RICH TEXT SERVICE
// ============================================================
//
// Handles conversion between Quill Delta JSON and plain text.
// Manages formatted content storage.
//
// ============================================================

import 'dart:convert';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class RichTextService {
  /// Convert Quill Delta JSON to plain text
  String deltaToPlainText(String deltaJson) {
    try {
      final json = jsonDecode(deltaJson);
      final doc = quill.Document.fromJson(json);
      return doc.toPlainText();
    } catch (e) {
      debugPrint('Error converting delta to plain text: $e');
      return '';
    }
  }

  /// Convert plain text to Quill Delta JSON
  String plainTextToDelta(String plainText) {
    try {
      final doc = quill.Document()..insert(0, plainText);
      return jsonEncode(doc.toDelta().toJson());
    } catch (e) {
      debugPrint('Error converting plain text to delta: $e');
      return jsonEncode([{'insert': plainText}]);
    }
  }

  /// Create a Quill Document from Delta JSON or plain text fallback
  quill.Document createDocument({
    String? formattedContent,
    String? plainTextFallback,
  }) {
    if (formattedContent != null && formattedContent.isNotEmpty) {
      try {
        final json = jsonDecode(formattedContent);
        return quill.Document.fromJson(json);
      } catch (e) {
        debugPrint('Error parsing formatted content: $e');
        // Fall through to plain text
      }
    }

    // Fallback to plain text
    if (plainTextFallback != null && plainTextFallback.isNotEmpty) {
      final doc = quill.Document();
      doc.insert(0, plainTextFallback);
      return doc;
    }

    // Empty document
    return quill.Document();
  }

  /// Validate that Delta JSON is well-formed
  bool isValidDelta(String deltaJson) {
    try {
      final json = jsonDecode(deltaJson);
      quill.Document.fromJson(json);
      return true;
    } catch (e) {
      return false;
    }
  }

  void debugPrint(String message) {
    print('[RichTextService] $message');
  }
}
