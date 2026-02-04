import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/recording_item.dart';
import '../../providers/app_state_provider.dart';
import '../../services/share_handler_service.dart';
import '../../services/ai_service.dart';
import '../../services/feature_gate.dart';
import '../main/recording_detail_screen.dart';
import '../main/preset_selection_screen.dart';
import '../paywall/paywall_screen.dart';

/// Screen for processing imported/shared content
class ImportContentScreen extends StatefulWidget {
  final SharedContent content;

  const ImportContentScreen({super.key, required this.content});

  @override
  State<ImportContentScreen> createState() => _ImportContentScreenState();
}

class _ImportContentScreenState extends State<ImportContentScreen> {
  bool _isProcessing = false;
  bool _isTranscribing = false;
  String? _extractedText;
  String? _error;

  // Colors
  static const _backgroundColor = Color(0xFF000000);
  static const _surfaceColor = Color(0xFF1A1A1A);
  static const _textColor = Colors.white;
  static const _secondaryTextColor = Color(0xFF94A3B8);
  static const _primaryColor = Color(0xFF3B82F6);

  @override
  void initState() {
    super.initState();
    _processContent();
  }

  Future<void> _processContent() async {
    setState(() {
      _isProcessing = true;
      _error = null;
    });

    try {
      switch (widget.content.type) {
        case SharedContentType.text:
          // Direct text - just use it
          if (widget.content.text != null) {
            _extractedText = widget.content.text;
          } else if (widget.content.filePath != null) {
            // Text file - read contents
            final file = File(widget.content.filePath!);
            if (await file.exists()) {
              _extractedText = await file.readAsString();
            } else {
              _error = 'File not found';
            }
          }
          break;

        case SharedContentType.audio:
          await _transcribeAudio();
          break;

        case SharedContentType.pdf:
          _extractedText = _buildPlaceholderText(
            'PDF Import',
            'PDF text extraction coming soon!\n\n'
            'For now, you can:\n'
            '- Copy text from the PDF manually\n'
            '- Use the text as a reference\n'
            '- Share plain text instead',
          );
          break;

        case SharedContentType.document:
          _extractedText = _buildPlaceholderText(
            'Document Import',
            'Word document import coming soon!\n\n'
            'For now, you can:\n'
            '- Copy text from the document manually\n'
            '- Save as plain text and share again',
          );
          break;

        case SharedContentType.image:
          _extractedText = _buildPlaceholderText(
            'Image Import',
            'Image OCR (text extraction) coming soon!\n\n'
            'For now, you can:\n'
            '- Type the text you see in the image\n'
            '- Use voice recording to describe it',
          );
          break;

        case SharedContentType.video:
          _extractedText = _buildPlaceholderText(
            'Video Import',
            'Video transcription coming soon!\n\n'
            'For now, you can:\n'
            '- Extract the audio and share it separately\n'
            '- Use voice recording to describe the content',
          );
          break;

        default:
          _error = 'Unsupported file type: ${widget.content.mimeType ?? "unknown"}';
      }
    } catch (e) {
      debugPrint('Error processing content: $e');
      _error = e.toString();
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  String _buildPlaceholderText(String title, String message) {
    return '[$title]\n\n'
           'File: ${widget.content.fileName ?? "Unknown"}\n\n'
           '$message';
  }

  Future<void> _transcribeAudio() async {
    if (widget.content.filePath == null) {
      _error = 'No audio file path';
      return;
    }

    // Check if user is Pro first
    final isPro = await FeatureGate.isPro();
    if (!isPro) {
      _error = 'Audio transcription is a Pro feature. Upgrade to transcribe audio files.';
      return;
    }

    // Check if user can use STT
    final canUse = await FeatureGate.canUseSTT(context);
    if (!canUse) {
      _error = 'No transcription time remaining. Upgrade to Pro for more time.';
      return;
    }

    setState(() => _isTranscribing = true);

    try {
      final file = File(widget.content.filePath!);

      if (!await file.exists()) {
        _error = 'Audio file not found';
        return;
      }

      final fileSize = await file.length();
      debugPrint('Audio file size: ${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB');

      // Transcribe
      final aiService = AIService();
      _extractedText = await aiService.transcribeAudio(file);

      if (_extractedText == null || _extractedText!.isEmpty) {
        _error = 'No speech detected in audio file';
        return;
      }

      // Track usage (estimate: ~1 min per MB for compressed audio)
      final estimatedSeconds = (fileSize / 1000000 * 60).round().clamp(10, 600);
      await FeatureGate.trackSTTUsage(estimatedSeconds);

      debugPrint('Transcription complete: ${_extractedText!.length} chars');
    } catch (e) {
      _error = 'Transcription failed: $e';
    } finally {
      if (mounted) {
        setState(() => _isTranscribing = false);
      }
    }
  }

  Future<void> _saveAsNote() async {
    if (_extractedText == null || _extractedText!.isEmpty) return;

    HapticFeedback.mediumImpact();

    final appState = context.read<AppStateProvider>();

    // Generate title from filename or content
    String title = widget.content.fileName ?? 'Imported Content';
    if (title.contains('.')) {
      title = title.substring(0, title.lastIndexOf('.')); // Remove extension
    }
    // Clean up title
    title = title.replaceAll('_', ' ').replaceAll('-', ' ');
    if (title.length > 50) {
      title = '${title.substring(0, 47)}...';
    }

    final newItem = RecordingItem(
      id: const Uuid().v4(),
      rawTranscript: _extractedText!,
      finalText: _extractedText!,
      presetUsed: 'Imported ${widget.content.displayName}',
      outcomes: [],
      projectId: null,
      createdAt: DateTime.now(),
      editHistory: [_extractedText!],
      presetId: 'imported_${widget.content.type.name}',
      tags: ['imported'],
      contentType: widget.content.type == SharedContentType.audio ? 'voice' : 'text',
      customTitle: title,
    );

    await appState.saveRecording(newItem);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => RecordingDetailScreen(recordingId: newItem.id),
        ),
      );
    }
  }

  Future<void> _processWithAI() async {
    if (_extractedText == null || _extractedText!.isEmpty) return;

    HapticFeedback.mediumImpact();

    final appState = context.read<AppStateProvider>();
    appState.setTranscription(_extractedText!);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const PresetSelectionScreen(fromRecording: true),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: _textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: widget.content.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(widget.content.icon, color: widget.content.color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Import ${widget.content.displayName}',
                style: const TextStyle(
                  color: _textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Loading state
    if (_isProcessing || _isTranscribing) {
      return _buildLoadingState();
    }

    // Error state
    if (_error != null) {
      return _buildErrorState();
    }

    // Success state - show preview
    return _buildSuccessState();
  }

  Widget _buildLoadingState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: _surfaceColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 64,
              height: 64,
              child: CircularProgressIndicator(
                color: widget.content.color,
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _isTranscribing ? 'Transcribing audio...' : 'Processing...',
              style: const TextStyle(
                color: _textColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            if (widget.content.fileName != null)
              Text(
                widget.content.fileName!,
                style: TextStyle(color: _secondaryTextColor.withOpacity(0.7), fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            if (_isTranscribing) ...[
              const SizedBox(height: 16),
              Text(
                'This may take a moment...',
                style: TextStyle(color: _secondaryTextColor.withOpacity(0.5), fontSize: 13),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    final isProFeatureError = _error!.contains('Pro feature');

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: (isProFeatureError ? const Color(0xFFFFD700) : const Color(0xFFEF4444)).withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                isProFeatureError ? Icons.workspace_premium : Icons.error_outline,
                color: isProFeatureError ? const Color(0xFFFFD700) : const Color(0xFFEF4444),
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isProFeatureError ? 'Pro Feature' : 'Import Failed',
              style: const TextStyle(
                color: _textColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _error!,
              style: const TextStyle(color: _secondaryTextColor, fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    side: BorderSide(color: _secondaryTextColor.withOpacity(0.3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Cancel', style: TextStyle(color: _secondaryTextColor)),
                ),
                const SizedBox(width: 16),
                if (isProFeatureError)
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaywallScreen(
                            onSubscribe: () => Navigator.pop(context),
                            onRestore: () => Navigator.pop(context),
                            onClose: () => Navigator.pop(context),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.workspace_premium, color: Colors.black, size: 18),
                    label: const Text('Upgrade to Pro', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD700),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )
                else
                  ElevatedButton(
                    onPressed: _processContent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Try Again', style: TextStyle(color: Colors.white)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessState() {
    final wordCount = _extractedText?.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length ?? 0;

    return Column(
      children: [
        // File info banner
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.content.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: widget.content.color.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(widget.content.icon, color: widget.content.color, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.content.fileName ?? 'Shared ${widget.content.displayName}',
                      style: const TextStyle(
                        color: _textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$wordCount words - Ready to save',
                      style: const TextStyle(color: _secondaryTextColor, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF10B981),
                  size: 24,
                ),
              ),
            ],
          ),
        ),

        // Content preview
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: _surfaceColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: SelectableText(
                  _extractedText ?? 'No content',
                  style: const TextStyle(
                    color: _textColor,
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Action buttons
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _surfaceColor,
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Primary: Process with AI (only if content can be processed)
                if (widget.content.canProcessWithAI || widget.content.type == SharedContentType.text)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _extractedText != null ? _processWithAI : null,
                      icon: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                      label: const Text(
                        'Process with AI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        disabledBackgroundColor: _primaryColor.withOpacity(0.3),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                if (widget.content.canProcessWithAI || widget.content.type == SharedContentType.text)
                  const SizedBox(height: 12),

                // Secondary: Save as Note
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _extractedText != null ? _saveAsNote : null,
                    icon: Icon(Icons.save_alt, color: _secondaryTextColor, size: 20),
                    label: Text(
                      'Save as Note',
                      style: TextStyle(color: _secondaryTextColor, fontSize: 16),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: _secondaryTextColor.withOpacity(0.3)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
