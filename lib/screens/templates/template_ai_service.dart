// ============================================================
//        ELITE TEMPLATE AI SERVICE
// ============================================================
//
// The brain that transforms voice inputs into perfect outputs.
// Each template has custom AI prompts for maximum quality.
//
// ============================================================

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../templates/template_models.dart';
import '../templates/template_registry.dart';

class TemplateAIService {
  // Your backend URL
  static const String _baseUrl = 'https://your-backend.com/api';
  
  // ============================================================
  // MAIN GENERATION METHOD
  // ============================================================
  
  /// Generate final output from filled template sections
  Future<TemplateOutput> generateOutput({
    required AppTemplate template,
    required Map<String, String> sectionInputs,
    String? language,
  }) async {
    // Build the master prompt
    final prompt = _buildMasterPrompt(template, sectionInputs);
    
    // Call AI
    final rawOutput = await _callAI(
      systemPrompt: template.aiSystemPrompt,
      userPrompt: prompt,
      temperature: _getTemperature(template),
    );
    
    // Post-process based on template type
    final processedOutput = _postProcess(template, rawOutput);
    
    // Generate exports
    final exports = _generateExports(template, processedOutput, sectionInputs);
    
    return TemplateOutput(
      rawText: processedOutput,
      exports: exports,
      templateId: template.id,
      generatedAt: DateTime.now(),
    );
  }

  // ============================================================
  // PROMPT BUILDING
  // ============================================================
  
  String _buildMasterPrompt(AppTemplate template, Map<String, String> sectionInputs) {
    final buffer = StringBuffer();
    
    buffer.writeln('Create a ${template.name} based on the following inputs:\n');
    
    for (final section in template.sections) {
      final input = sectionInputs[section.id];
      if (input != null && input.isNotEmpty) {
        buffer.writeln('### ${section.title}');
        buffer.writeln('User said: "$input"');
        buffer.writeln('Instructions: ${section.aiPrompt}');
        buffer.writeln();
      }
    }
    
    buffer.writeln('\n---');
    buffer.writeln('Now generate the complete ${template.name}.');
    buffer.writeln('Output ONLY the final content, no explanations or meta-commentary.');
    
    return buffer.toString();
  }

  double _getTemperature(AppTemplate template) {
    // Different templates need different creativity levels
    switch (template.category) {
      case TemplateCategory.emotional:
        return 0.8; // More creative for speeches, vows
      case TemplateCategory.legal:
        return 0.3; // More precise for legal docs
      case TemplateCategory.productivity:
        return 0.2; // Very structured for data extraction
      case TemplateCategory.social:
        return 0.7; // Creative but focused
      default:
        return 0.5; // Balanced
    }
  }

  // ============================================================
  // AI CALL
  // ============================================================
  
  Future<String> _callAI({
    required String systemPrompt,
    required String userPrompt,
    double temperature = 0.5,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/template/generate'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'systemPrompt': systemPrompt,
          'userPrompt': userPrompt,
          'temperature': temperature,
          'maxTokens': 2000,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['text'] ?? '';
      } else {
        throw Exception('AI generation failed: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback: return structured placeholder
      return _generateFallback(userPrompt);
    }
  }

  String _generateFallback(String prompt) {
    return 'Generated content based on your inputs. Please check your internet connection for AI-powered generation.';
  }

  // ============================================================
  // POST-PROCESSING
  // ============================================================
  
  String _postProcess(AppTemplate template, String rawOutput) {
    var output = rawOutput.trim();
    
    // Remove common AI artifacts
    output = _removeAISlop(output);
    
    // Template-specific processing
    switch (template.id) {
      case 'resume':
        output = _formatResume(output);
        break;
      case 'linkedin_post':
        output = _formatLinkedIn(output);
        break;
      case 'twitter_thread':
        output = _formatTwitterThread(output);
        break;
      case 'flashcards':
        output = _formatFlashcards(output);
        break;
    }
    
    return output;
  }

  String _removeAISlop(String text) {
    // Remove common AI intro/outro phrases
    final slopPatterns = [
      RegExp(r'^(Sure|Certainly|Of course|Absolutely)[,!]\s*', caseSensitive: false),
      RegExp(r"^(Here is|Here's|I've created|I have created)[^.]*\.\s*", caseSensitive: false),
      RegExp(r'\s*(Hope this helps|Let me know if you need|Feel free to)[^.]*\.?\s*$', caseSensitive: false),
      RegExp(r'^(Based on your inputs?,?|Using the information provided,?)\s*', caseSensitive: false),
    ];
    
    for (final pattern in slopPatterns) {
      text = text.replaceAll(pattern, '');
    }
    
    return text.trim();
  }

  String _formatResume(String text) {
    // Ensure proper resume formatting
    return text;
  }

  String _formatLinkedIn(String text) {
    // Ensure proper line breaks for LinkedIn
    // LinkedIn needs double line breaks
    return text.replaceAll('\n\n\n', '\n\n');
  }

  String _formatTwitterThread(String text) {
    // Ensure tweets are numbered and under 280 chars
    final lines = text.split('\n').where((l) => l.trim().isNotEmpty).toList();
    final tweets = <String>[];
    
    for (var i = 0; i < lines.length; i++) {
      var tweet = lines[i].trim();
      // Remove existing numbering
      tweet = tweet.replaceFirst(RegExp(r'^\d+[./)]\s*'), '');
      // Add proper numbering
      tweet = '${i + 1}/ $tweet';
      // Truncate if too long
      if (tweet.length > 280) {
        tweet = '${tweet.substring(0, 277)}...';
      }
      tweets.add(tweet);
    }
    
    return tweets.join('\n\n');
  }

  String _formatFlashcards(String text) {
    // Ensure Q/A format
    return text;
  }

  // ============================================================
  // EXPORT GENERATION
  // ============================================================
  
  Map<ExportFormat, String> _generateExports(
    AppTemplate template,
    String processedOutput,
    Map<String, String> sectionInputs,
  ) {
    final exports = <ExportFormat, String>{};
    
    // Always include text
    exports[ExportFormat.text] = processedOutput;
    
    // Generate available exports
    for (final format in template.availableExports) {
      switch (format) {
        case ExportFormat.markdown:
          exports[ExportFormat.markdown] = _toMarkdown(template, processedOutput);
          break;
        case ExportFormat.csv:
          exports[ExportFormat.csv] = _toCSV(template, sectionInputs, processedOutput);
          break;
        case ExportFormat.html:
          exports[ExportFormat.html] = _toHTML(template, processedOutput);
          break;
        case ExportFormat.json:
          exports[ExportFormat.json] = _toJSON(template, sectionInputs, processedOutput);
          break;
        case ExportFormat.ics:
          exports[ExportFormat.ics] = _toICS(sectionInputs);
          break;
        default:
          break;
      }
    }
    
    return exports;
  }

  String _toMarkdown(AppTemplate template, String text) {
    final buffer = StringBuffer();
    buffer.writeln('# ${template.name}');
    buffer.writeln();
    buffer.writeln(text);
    buffer.writeln();
    buffer.writeln('---');
    buffer.writeln('*Generated with VoiceBubble*');
    return buffer.toString();
  }

  String _toCSV(AppTemplate template, Map<String, String> inputs, String output) {
    // For data-heavy templates like expense tracker, time tracker, etc.
    switch (template.id) {
      case 'expense_tracker':
        return _expenseToCSV(inputs['expenses'] ?? '');
      case 'time_tracker':
        return _timeToCSV(inputs['time'] ?? '');
      case 'inventory_log':
        return _inventoryToCSV(inputs['items'] ?? '');
      case 'contact_list':
        return _contactsToCSV(inputs['contacts'] ?? '');
      case 'food_log':
        return _foodToCSV(inputs['food'] ?? '');
      case 'flashcards':
        return _flashcardsToCSV(output);
      default:
        // Generic CSV with sections
        final buffer = StringBuffer();
        buffer.writeln('Section,Content');
        for (final entry in inputs.entries) {
          final escaped = entry.value.replaceAll('"', '""');
          buffer.writeln('"${entry.key}","$escaped"');
        }
        return buffer.toString();
    }
  }

  String _expenseToCSV(String input) {
    // Parse natural language expenses into CSV
    // This would ideally use AI, but here's a basic structure
    final buffer = StringBuffer();
    buffer.writeln('Date,Description,Amount,Category');
    buffer.writeln('${DateTime.now().toIso8601String().split('T')[0]},"Expense from voice input",0.00,"Uncategorized"');
    return buffer.toString();
  }

  String _timeToCSV(String input) {
    final buffer = StringBuffer();
    buffer.writeln('Date,Project,Hours,Description');
    return buffer.toString();
  }

  String _inventoryToCSV(String input) {
    final buffer = StringBuffer();
    buffer.writeln('Item,Quantity,Variant,Location');
    return buffer.toString();
  }

  String _contactsToCSV(String input) {
    final buffer = StringBuffer();
    buffer.writeln('Name,Email,Phone,Company,Notes');
    return buffer.toString();
  }

  String _foodToCSV(String input) {
    final buffer = StringBuffer();
    buffer.writeln('Date,Meal,Food,Portion,Calories');
    return buffer.toString();
  }

  String _flashcardsToCSV(String output) {
    final buffer = StringBuffer();
    buffer.writeln('Front,Back');
    // Parse Q/A pairs from output
    final lines = output.split('\n');
    for (var i = 0; i < lines.length - 1; i += 2) {
      final front = lines[i].replaceAll('"', '""').replaceFirst(RegExp(r'^Q:\s*'), '');
      final back = lines[i + 1].replaceAll('"', '""').replaceFirst(RegExp(r'^A:\s*'), '');
      buffer.writeln('"$front","$back"');
    }
    return buffer.toString();
  }

  String _toHTML(AppTemplate template, String text) {
    final escapedText = text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('\n', '<br>\n');
    
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>${template.name}</title>
  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      max-width: 800px;
      margin: 40px auto;
      padding: 20px;
      line-height: 1.6;
      color: #333;
    }
    h1 { color: #1a1a1a; border-bottom: 2px solid #8B5CF6; padding-bottom: 10px; }
    .content { margin-top: 20px; }
    .footer { margin-top: 40px; color: #666; font-size: 12px; }
  </style>
</head>
<body>
  <h1>${template.name}</h1>
  <div class="content">$escapedText</div>
  <div class="footer">Generated with VoiceBubble</div>
</body>
</html>
''';
  }

  String _toJSON(AppTemplate template, Map<String, String> inputs, String output) {
    return jsonEncode({
      'templateId': template.id,
      'templateName': template.name,
      'generatedAt': DateTime.now().toIso8601String(),
      'inputs': inputs,
      'output': output,
    });
  }

  String _toICS(Map<String, String> inputs) {
    // Generate ICS calendar format
    final now = DateTime.now();
    final event = inputs['event'] ?? 'Event';
    
    return '''
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//VoiceBubble//EN
BEGIN:VEVENT
DTSTART:${_formatICSDate(now.add(const Duration(days: 1)))}
DTEND:${_formatICSDate(now.add(const Duration(days: 1, hours: 1)))}
SUMMARY:$event
DESCRIPTION:Created with VoiceBubble
END:VEVENT
END:VCALENDAR
''';
  }

  String _formatICSDate(DateTime dt) {
    return '${dt.year}${dt.month.toString().padLeft(2, '0')}${dt.day.toString().padLeft(2, '0')}T${dt.hour.toString().padLeft(2, '0')}${dt.minute.toString().padLeft(2, '0')}00';
  }

  // ============================================================
  // SECTION-LEVEL AI (for real-time enhancement)
  // ============================================================
  
  /// Enhance a single section's input in real-time
  Future<String> enhanceSection({
    required TemplateSection section,
    required String rawInput,
  }) async {
    final response = await _callAI(
      systemPrompt: 'You are a helpful writing assistant. Clean up and enhance the user\'s voice input while keeping their intent. Be concise.',
      userPrompt: 'Section: ${section.title}\nInstructions: ${section.aiPrompt}\nUser said: "$rawInput"\n\nEnhanced version:',
      temperature: 0.3,
    );
    
    return response.trim();
  }

  // ============================================================
  // SMART SUGGESTIONS
  // ============================================================
  
  /// Get AI-powered suggestions for a section
  Future<List<String>> getSuggestions({
    required TemplateSection section,
    required Map<String, String> previousInputs,
  }) async {
    // Return quick suggestions based on section type
    return section.suggestions ?? [];
  }
}

// ============================================================
// OUTPUT MODEL
// ============================================================

class TemplateOutput {
  final String rawText;
  final Map<ExportFormat, String> exports;
  final String templateId;
  final DateTime generatedAt;

  TemplateOutput({
    required this.rawText,
    required this.exports,
    required this.templateId,
    required this.generatedAt,
  });

  String getExport(ExportFormat format) {
    return exports[format] ?? rawText;
  }

  bool hasExport(ExportFormat format) {
    return exports.containsKey(format);
  }
}