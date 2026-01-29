import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TextTransformationService {
  static final TextTransformationService _instance = TextTransformationService._internal();
  factory TextTransformationService() => _instance;
  TextTransformationService._internal();

  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? 'https://voicebubble-production.up.railway.app';

  /// Transform text using AI
  Future<String> transformText({
    required String text,
    required String action,
    String? context,
  }) async {
    try {
      print('🤖 Transforming text: $action | "${text.substring(0, text.length > 50 ? 50 : text.length)}..."');

      final response = await http.post(
        Uri.parse('$_baseUrl/api/transform/transform'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'text': text,
          'action': action,
          'context': context,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final transformedText = data['transformedText'] as String;
          print('✅ Text transformation successful: "${transformedText.substring(0, transformedText.length > 50 ? 50 : transformedText.length)}..."');
          return transformedText;
        } else {
          throw Exception(data['error'] ?? 'Unknown error');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ Text transformation error: $e');
      rethrow;
    }
  }

  /// Transform multiple texts in batch
  Future<List<TransformationResult>> batchTransformText({
    required List<String> texts,
    required String action,
    String? context,
  }) async {
    try {
      print('🤖 Batch transforming ${texts.length} texts: $action');

      final response = await http.post(
        Uri.parse('$_baseUrl/api/transform/batch-transform'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'texts': texts,
          'action': action,
          'context': context,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final results = (data['results'] as List).map((result) {
            return TransformationResult(
              originalText: result['originalText'],
              transformedText: result['transformedText'],
              success: result['success'],
              error: result['error'],
            );
          }).toList();
          
          print('✅ Batch transformation complete: ${results.where((r) => r.success).length}/${results.length} successful');
          return results;
        } else {
          throw Exception(data['error'] ?? 'Unknown error');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ Batch text transformation error: $e');
      rethrow;
    }
  }

  /// Get available transformation actions
  Future<List<TransformationAction>> getTransformationActions() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/transform/actions'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final actions = (data['actions'] as List).map((action) {
            return TransformationAction(
              id: action['id'],
              name: action['name'],
              description: action['description'],
            );
          }).toList();
          
          return actions;
        } else {
          throw Exception(data['error'] ?? 'Unknown error');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ Get transformation actions error: $e');
      rethrow;
    }
  }
}

class TransformationResult {
  final String originalText;
  final String? transformedText;
  final bool success;
  final String? error;

  TransformationResult({
    required this.originalText,
    this.transformedText,
    required this.success,
    this.error,
  });
}

class TransformationAction {
  final String id;
  final String name;
  final String description;

  TransformationAction({
    required this.id,
    required this.name,
    required this.description,
  });
}