// ============================================================
//        ELITE EXPORT SERVICE
// ============================================================
//
// Handles exporting generated content to various formats
// and sharing to other apps.
//
// ============================================================

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'template_models.dart';

class ExportService {
  
  // ============================================================
  // COPY TO CLIPBOARD
  // ============================================================
  
  Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.mediumImpact();
  }

  // ============================================================
  // SHARE AS TEXT
  // ============================================================
  
  Future<void> shareText(String text, {String? subject}) async {
    await Share.share(text, subject: subject);
  }

  // ============================================================
  // EXPORT AS FILE
  // ============================================================
  
  Future<String> exportAsFile({
    required String content,
    required String fileName,
    required ExportFormat format,
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    final extension = _getExtension(format);
    final file = File('${directory.path}/$fileName.$extension');
    
    await file.writeAsString(content);
    
    return file.path;
  }

  String _getExtension(ExportFormat format) {
    switch (format) {
      case ExportFormat.text: return 'txt';
      case ExportFormat.markdown: return 'md';
      case ExportFormat.csv: return 'csv';
      case ExportFormat.html: return 'html';
      case ExportFormat.json: return 'json';
      case ExportFormat.ics: return 'ics';
    }
  }

  // ============================================================
  // SHARE AS FILE
  // ============================================================
  
  Future<void> shareAsFile({
    required String content,
    required String fileName,
    required ExportFormat format,
  }) async {
    final filePath = await exportAsFile(
      content: content,
      fileName: fileName,
      format: format,
    );
    
    await Share.shareXFiles(
      [XFile(filePath)],
      subject: fileName,
    );
  }

  // ============================================================
  // APP-SPECIFIC EXPORTS
  // ============================================================
  
  /// Export for Google Sheets (CSV format)
  Future<void> exportToSheets(String csvContent, String fileName) async {
    await shareAsFile(
      content: csvContent,
      fileName: fileName,
      format: ExportFormat.csv,
    );
  }

  /// Export for Notion (Markdown format)
  Future<void> exportToNotion(String markdownContent, String fileName) async {
    await shareAsFile(
      content: markdownContent,
      fileName: fileName,
      format: ExportFormat.markdown,
    );
  }

  /// Export for Calendar apps (ICS format)
  Future<void> exportToCalendar(String icsContent, String fileName) async {
    await shareAsFile(
      content: icsContent,
      fileName: fileName,
      format: ExportFormat.ics,
    );
  }

  /// Export for Anki/Quizlet (CSV flashcard format)
  Future<void> exportFlashcards(String csvContent, String deckName) async {
    await shareAsFile(
      content: csvContent,
      fileName: '${deckName}_flashcards',
      format: ExportFormat.csv,
    );
  }

  // ============================================================
  // FORMAT CONVERTERS
  // ============================================================
  
  /// Convert plain text to basic HTML
  String textToHTML(String text, String title) {
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
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>$title</title>
  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      max-width: 800px;
      margin: 40px auto;
      padding: 20px;
      line-height: 1.8;
      color: #1a1a1a;
      background: #fafafa;
    }
    h1 {
      color: #8B5CF6;
      border-bottom: 3px solid #8B5CF6;
      padding-bottom: 15px;
      margin-bottom: 30px;
    }
    .content {
      background: white;
      padding: 30px;
      border-radius: 12px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }
    .footer {
      margin-top: 40px;
      text-align: center;
      color: #666;
      font-size: 12px;
    }
  </style>
</head>
<body>
  <h1>$title</h1>
  <div class="content">$escapedText</div>
  <div class="footer">Generated with VoiceBubble</div>
</body>
</html>
''';
  }

  /// Convert plain text to Markdown
  String textToMarkdown(String text, String title) {
    return '''
# $title

$text

---

*Generated with VoiceBubble*
''';
  }

  /// Convert list of items to CSV
  String listToCSV(List<Map<String, dynamic>> items, List<String> columns) {
    final buffer = StringBuffer();
    
    // Header
    buffer.writeln(columns.map((c) => '"$c"').join(','));
    
    // Rows
    for (final item in items) {
      final row = columns.map((col) {
        final value = item[col]?.toString() ?? '';
        return '"${value.replaceAll('"', '""')}"';
      }).join(',');
      buffer.writeln(row);
    }
    
    return buffer.toString();
  }

  // ============================================================
  // RESUME SPECIFIC EXPORT
  // ============================================================
  
  String formatResumeForExport(Map<String, String> sections) {
    final buffer = StringBuffer();
    
    // Contact
    if (sections['contact']?.isNotEmpty ?? false) {
      buffer.writeln(sections['contact']!.toUpperCase());
      buffer.writeln();
    }
    
    // Summary
    if (sections['summary']?.isNotEmpty ?? false) {
      buffer.writeln('PROFESSIONAL SUMMARY');
      buffer.writeln('─'.padRight(50, '─'));
      buffer.writeln(sections['summary']);
      buffer.writeln();
    }
    
    // Experience
    if (sections['experience']?.isNotEmpty ?? false) {
      buffer.writeln('EXPERIENCE');
      buffer.writeln('─'.padRight(50, '─'));
      buffer.writeln(sections['experience']);
      buffer.writeln();
    }
    
    // Skills
    if (sections['skills']?.isNotEmpty ?? false) {
      buffer.writeln('SKILLS');
      buffer.writeln('─'.padRight(50, '─'));
      buffer.writeln(sections['skills']);
      buffer.writeln();
    }
    
    // Education
    if (sections['education']?.isNotEmpty ?? false) {
      buffer.writeln('EDUCATION');
      buffer.writeln('─'.padRight(50, '─'));
      buffer.writeln(sections['education']);
      buffer.writeln();
    }
    
    return buffer.toString();
  }

  // ============================================================
  // LINKEDIN SPECIFIC EXPORT
  // ============================================================
  
  String formatLinkedInPost(String content) {
    // LinkedIn prefers posts with line breaks for readability
    var formatted = content.trim();
    
    // Ensure proper spacing
    formatted = formatted.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    
    // Add hashtags at the end if not present
    if (!formatted.contains('#')) {
      formatted += '\n\n#voicebubble #productivity';
    }
    
    return formatted;
  }

  // ============================================================
  // CALENDAR EVENT EXPORT
  // ============================================================
  
  String createICSEvent({
    required String title,
    required DateTime start,
    DateTime? end,
    String? description,
    String? location,
  }) {
    end ??= start.add(const Duration(hours: 1));
    
    return '''
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//VoiceBubble//EN
CALSCALE:GREGORIAN
METHOD:PUBLISH
BEGIN:VEVENT
DTSTART:${_formatICSDateTime(start)}
DTEND:${_formatICSDateTime(end)}
SUMMARY:$title
${description != null ? 'DESCRIPTION:$description' : ''}
${location != null ? 'LOCATION:$location' : ''}
STATUS:CONFIRMED
SEQUENCE:0
END:VEVENT
END:VCALENDAR
''';
  }

  String _formatICSDateTime(DateTime dt) {
    final utc = dt.toUtc();
    return '${utc.year}'
        '${utc.month.toString().padLeft(2, '0')}'
        '${utc.day.toString().padLeft(2, '0')}'
        'T'
        '${utc.hour.toString().padLeft(2, '0')}'
        '${utc.minute.toString().padLeft(2, '0')}'
        '${utc.second.toString().padLeft(2, '0')}'
        'Z';
  }
}

// ============================================================
// EXPORT OPTIONS HELPER
// ============================================================

class ExportOption {
  final String label;
  final IconData icon;
  final ExportFormat format;
  final String? targetApp;

  const ExportOption({
    required this.label,
    required this.icon,
    required this.format,
    this.targetApp,
  });
}

/// Get available export options for a template
List<ExportOption> getExportOptions(AppTemplate template) {
  final options = <ExportOption>[];
  
  // Always add copy
  options.add(const ExportOption(
    label: 'Copy',
    icon: Icons.copy,
    format: ExportFormat.text,
  ));
  
  // Add format-specific options
  for (final format in template.availableExports) {
    switch (format) {
      case ExportFormat.csv:
        options.add(ExportOption(
          label: template.targetApp?.contains('Sheets') ?? false 
              ? 'Export to Sheets' 
              : 'Export CSV',
          icon: Icons.table_chart,
          format: ExportFormat.csv,
          targetApp: 'Google Sheets',
        ));
        break;
      case ExportFormat.markdown:
        options.add(const ExportOption(
          label: 'Export to Notion',
          icon: Icons.article,
          format: ExportFormat.markdown,
          targetApp: 'Notion',
        ));
        break;
      case ExportFormat.ics:
        options.add(const ExportOption(
          label: 'Add to Calendar',
          icon: Icons.calendar_today,
          format: ExportFormat.ics,
          targetApp: 'Calendar',
        ));
        break;
      case ExportFormat.html:
        options.add(const ExportOption(
          label: 'Export HTML',
          icon: Icons.code,
          format: ExportFormat.html,
        ));
        break;
      default:
        break;
    }
  }
  
  // Always add share
  options.add(const ExportOption(
    label: 'Share',
    icon: Icons.share,
    format: ExportFormat.text,
  ));
  
  return options;
}