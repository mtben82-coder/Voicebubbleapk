import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/recording_item.dart';
import '../services/export_service.dart';

class ExportDialog extends StatelessWidget {
  final RecordingItem note;

  const ExportDialog({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = const Color(0xFF000000);
    final surfaceColor = const Color(0xFF1A1A1A);
    final textColor = Colors.white;
    final primaryColor = const Color(0xFF3B82F6);

    return Dialog(
      backgroundColor: surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Export Note',
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Choose format to export',
              style: TextStyle(
                color: textColor.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Export options
            _ExportOption(
              icon: Icons.picture_as_pdf,
              title: 'PDF Document',
              description: 'Professional formatted document',
              color: const Color(0xFFEF4444),
              onTap: () => _exportAs(context, 'pdf'),
            ),
            
            const SizedBox(height: 12),
            
            _ExportOption(
              icon: Icons.code,
              title: 'Markdown (.md)',
              description: 'Plain text with formatting',
              color: primaryColor,
              onTap: () => _exportAs(context, 'markdown'),
            ),
            
            const SizedBox(height: 12),
            
            _ExportOption(
              icon: Icons.language,
              title: 'HTML (.html)',
              description: 'Web page format',
              color: const Color(0xFFF97316),
              onTap: () => _exportAs(context, 'html'),
            ),
            
            const SizedBox(height: 12),
            
            _ExportOption(
              icon: Icons.text_fields,
              title: 'Plain Text (.txt)',
              description: 'Simple text file',
              color: const Color(0xFF10B981),
              onTap: () => _exportAs(context, 'text'),
            ),
            
            const SizedBox(height: 24),
            
            // Cancel button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: textColor.withOpacity(0.7),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportAs(BuildContext context, String format) async {
    Navigator.pop(context); // Close dialog
    
    final exportService = ExportService();
    
    try {
      // Debug: Check note content
      debugPrint('🔍 Exporting note: finalText="${note.finalText}", formattedContent="${note.formattedContent}"');
      
      // Show loading
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                Text('Exporting as ${format.toUpperCase()}...'),
              ],
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: const Color(0xFF3B82F6),
          ),
        );
      }
      
      // Export based on format
      late final file;
      switch (format) {
        case 'pdf':
          file = await exportService.exportAsPdf(note);
          break;
        case 'markdown':
          file = await exportService.exportAsMarkdown(note);
          break;
        case 'html':
          file = await exportService.exportAsHtml(note);
          break;
        case 'text':
          file = await exportService.exportAsText(note);
          break;
      }
      
      // Share the file
      await exportService.shareFile(file);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Export complete!'),
            backgroundColor: Color(0xFF10B981),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: const Color(0xFFEF4444),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}

class _ExportOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _ExportOption({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF000000),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.3),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
