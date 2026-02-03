// ============================================================
//        TEMPLATE AI PROCESSING SERVICE
// ============================================================
//
// Processes voice answers from templates and fills them perfectly
// using the existing AI backend.
//
// ============================================================

import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import '../models/recording_item.dart';
import '../screens/templates/template_models.dart';

class TemplateAIService {
  // Use same backend as main AI service
  static const String _backendUrl = 'https://voicebubble-production.up.railway.app';
  
  final Dio _dio = Dio();
  
  TemplateAIService() {
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
    _dio.options.connectTimeout = const Duration(seconds: 60);
    _dio.options.receiveTimeout = const Duration(seconds: 60);
  }
  
  /// Process template answers and create a filled RecordingItem
  Future<RecordingItem> processTemplateAnswers({
    required AppTemplate template,
    required Map<String, String> answers,
  }) async {
    try {
      // Send to backend to process with AI
      final response = await _dio.post(
        '$_backendUrl/api/template/process',
        data: {
          'templateId': template.id,
          'templateName': template.name,
          'sections': template.sections.map((s) => {
            'id': s.id,
            'title': s.title,
            'aiPrompt': s.aiPrompt,
            'required': s.required,
          }).toList(),
          'answers': answers,
          'systemPrompt': template.aiSystemPrompt,
        },
      );
      
      // Backend returns filled sections and final markdown
      final filledSections = response.data['sections'] as Map<String, dynamic>;
      final finalMarkdown = response.data['markdown'] as String;
      
      // Create RecordingItem
      return RecordingItem(
        id: const Uuid().v4(),
        timestamp: DateTime.now(),
        finalText: _createRawText(answers),
        formattedContent: finalMarkdown,
        duration: const Duration(minutes: 2), // Approximate
        tags: [],
        projectId: null,
        sourceLanguage: 'en',
      );
    } catch (e) {
      print('Template processing error: $e');
      // Fallback: create basic markdown from answers
      return _createFallbackItem(template, answers);
    }
  }
  
  /// Fallback if AI service fails - create basic structured output
  RecordingItem _createFallbackItem(AppTemplate template, Map<String, String> answers) {
    final buffer = StringBuffer();
    buffer.writeln('# ${template.name}\n');
    
    // Build markdown from template sections and answers
    for (final section in template.sections) {
      final answer = answers[section.id] ?? '';
      if (answer.isNotEmpty) {
        buffer.writeln('## ${section.title}');
        buffer.writeln(answer);
        buffer.writeln();
      }
    }
    
    return RecordingItem(
      id: const Uuid().v4(),
      timestamp: DateTime.now(),
      finalText: _createRawText(answers),
      formattedContent: buffer.toString(),
      duration: const Duration(minutes: 2),
      tags: [],
      projectId: null,
      sourceLanguage: 'en',
    );
  }
  
  String _createRawText(Map<String, String> answers) {
    return answers.values.join(' ');
  }
  
  /// Clean up a single voice answer (grammar, clarity)
  Future<String> cleanupAnswer(String rawAnswer) async {
    if (rawAnswer.trim().isEmpty) return '';
    
    try {
      final response = await _dio.post(
        '$_backendUrl/api/transform-text',
        data: {
          'text': rawAnswer,
          'action': 'grammar', // Fix grammar and clarity
        },
      );
      
      return response.data['transformedText'] ?? rawAnswer;
    } catch (e) {
      print('Cleanup error: $e');
      return rawAnswer; // Return original if cleanup fails
    }
  }
}
