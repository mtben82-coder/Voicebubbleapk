// ============================================================
//        RICH TEXT EDITOR WIDGET
// ============================================================
//
// Professional rich text editor matching Samsung Notes quality.
// Full formatting toolbar, auto-save, dark theme.
//
// ============================================================

// KEYBOARD SHORTCUTS INTENTS
class SaveIntent extends Intent {}
class BoldIntent extends Intent {}
class ItalicIntent extends Intent {}
class UnderlineIntent extends Intent {}
class UndoIntent extends Intent {}
class RedoIntent extends Intent {}
class InsertDateTimeIntent extends Intent {}
class InsertDividerIntent extends Intent {}
class DuplicateLineIntent extends Intent {}

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import '../services/rich_text_service.dart';

// Intent classes for keyboard shortcuts
class SaveIntent extends Intent {
  const SaveIntent();
}

class BoldIntent extends Intent {
  const BoldIntent();
}

class ItalicIntent extends Intent {
  const ItalicIntent();
}

class UnderlineIntent extends Intent {
  const UnderlineIntent();
}

class RichTextEditor extends StatefulWidget {
  final String? initialFormattedContent; // Quill Delta JSON
  final String? initialPlainText; // Fallback
  final Function(String plainText, String deltaJson) onSave;
  final bool readOnly;

  const RichTextEditor({
    super.key,
    this.initialFormattedContent,
    this.initialPlainText,
    required this.onSave,
    this.readOnly = false,
  });

  @override
  State<RichTextEditor> createState() => _RichTextEditorState();
}

class _RichTextEditorState extends State<RichTextEditor> with TickerProviderStateMixin {
  late quill.QuillController _controller;
  final FocusNode _focusNode = FocusNode();
  Timer? _saveTimer;
  bool _showSaved = false;
  bool _hasUnsavedChanges = false;
  final _richTextService = RichTextService();
  late AnimationController _saveIndicatorController;
  late Animation<double> _saveIndicatorAnimation;
  int _wordCount = 0;
  int _characterCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeController();
    _controller.addListener(_onTextChanged);
  }

  void _initializeController() {
    final doc = _richTextService.createDocument(
      formattedContent: widget.initialFormattedContent,
      plainTextFallback: widget.initialPlainText,
    );
    _controller = quill.QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
      readOnly: widget.readOnly,
    );
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    _saveIndicatorController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (widget.readOnly) return;

    final plainText = _controller.document.toPlainText();
    final words = plainText.trim().split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
    final characters = plainText.length;

    setState(() {
      _hasUnsavedChanges = true;
      _showSaved = false;
      _wordCount = words;
      _characterCount = characters;
    });

    // Smart text replacements
    _handleSmartReplacements();

    // Debounce auto-save
    if (_saveTimer?.isActive ?? false) _saveTimer!.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 500), () {
      _saveContent();
    });
  }

  void _handleSmartReplacements() {
    final selection = _controller.selection;
    if (!selection.isValid) return;

    final text = _controller.document.toPlainText();
    final cursorPos = selection.baseOffset;
    
    // Find the word before cursor
    if (cursorPos > 0) {
      final beforeCursor = text.substring(0, cursorPos);
      final words = beforeCursor.split(RegExp(r'\s+'));
      final lastWord = words.isNotEmpty ? words.last : '';

      // Smart replacements
      final replacements = {
        '->': '→',
        '<-': '←',
        '=>': '⇒',
        '<=': '⇐',
        '...': '…',
        '(c)': '©',
        '(r)': '®',
        '(tm)': '™',
        '1/2': '½',
        '1/4': '¼',
        '3/4': '¾',
        '+-': '±',
        '!=': '≠',
        '<=': '≤',
        '>=': '≥',
      };

      if (replacements.containsKey(lastWord)) {
        final replacement = replacements[lastWord]!;
        final startPos = cursorPos - lastWord.length;
        
        _controller.document.delete(startPos, lastWord.length);
        _controller.document.insert(startPos, replacement);
        _controller.updateSelection(
          TextSelection.collapsed(offset: startPos + replacement.length),
          quill.ChangeSource.local,
        );
      }
    }
  }

  Future<void> _saveContent() async {
    try {
      final deltaJson = jsonEncode(_controller.document.toDelta().toJson());
      final plainText = _controller.document.toPlainText().trim();

      await widget.onSave(plainText, deltaJson);

      // Show animated "Saved" indicator
      if (mounted) {
        setState(() {
          _hasUnsavedChanges = false;
          _showSaved = true;
        });
        
        _saveIndicatorController.forward();
        
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            _saveIndicatorController.reverse();
            setState(() => _showSaved = false);
          }
        });
      }
    } catch (e) {
      debugPrint('Error saving content: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e'),
            backgroundColor: const Color(0xFFEF4444),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = const Color(0xFF000000);
    final surfaceColor = const Color(0xFF1A1A1A);
    final textColor = Colors.white;
    final primaryColor = const Color(0xFF3B82F6);

    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        // Basic shortcuts
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS): const SaveIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyB): const BoldIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyI): const ItalicIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyU): const UnderlineIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyZ): const UndoIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyY): const RedoIntent(),
        // Advanced shortcuts
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.semicolon): const InsertDateTimeIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.minus): const InsertDividerIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyD): const DuplicateLineIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          SaveIntent: CallbackAction<SaveIntent>(onInvoke: (_) => _saveContent()),
          BoldIntent: CallbackAction<BoldIntent>(onInvoke: (_) => _controller.formatSelection(quill.Attribute.bold)),
          ItalicIntent: CallbackAction<ItalicIntent>(onInvoke: (_) => _controller.formatSelection(quill.Attribute.italic)),
          UnderlineIntent: CallbackAction<UnderlineIntent>(onInvoke: (_) => _controller.formatSelection(quill.Attribute.underline)),
          UndoIntent: CallbackAction<UndoIntent>(onInvoke: (_) => _controller.undo()),
          RedoIntent: CallbackAction<RedoIntent>(onInvoke: (_) => _controller.redo()),
          InsertDateTimeIntent: CallbackAction<InsertDateTimeIntent>(onInvoke: (_) => _insertCurrentDateTime()),
          InsertDividerIntent: CallbackAction<InsertDividerIntent>(onInvoke: (_) => _insertDivider()),
          DuplicateLineIntent: CallbackAction<DuplicateLineIntent>(onInvoke: (_) => _duplicateCurrentLine()),
        },
        child: Stack(
          children: [
            Column(
              children: [
        // Formatting Toolbar
        Container(
          color: surfaceColor,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: quill.QuillToolbar.simple(
            controller: _controller,
            configurations: quill.QuillSimpleToolbarConfigurations(
              color: surfaceColor,
              multiRowsDisplay: false,
              showAlignmentButtons: true,
              showBackgroundColorButton: true,
              showBoldButton: true,
              showCenterAlignment: true,
              showClearFormat: true,
              showCodeBlock: false,
              showColorButton: true,
              showDirection: false,
              showDividers: true,
              showFontFamily: false,
              showFontSize: true,
              showHeaderStyle: true,
              showIndent: true,
              showInlineCode: true,
              showItalicButton: true,
              showJustifyAlignment: false,
              showLeftAlignment: true,
              showLink: false,
              showListBullets: true,
              showListCheck: true,
              showListNumbers: true,
              showQuote: false,
              showRedo: true,
              showRightAlignment: true,
              showSearchButton: false,
              showSmallButton: false,
              showStrikeThrough: true,
              showSubscript: false,
              showSuperscript: false,
              showUnderLineButton: true,
              showUndo: true,
              toolbarIconAlignment: WrapAlignment.start,
              toolbarSectionSpacing: 4,
              buttonOptions: quill.QuillSimpleToolbarButtonOptions(
                base: quill.QuillToolbarBaseButtonOptions(
                  iconTheme: quill.QuillIconTheme(
                    iconUnselectedColor: textColor.withOpacity(0.7),
                    iconSelectedColor: primaryColor,
                    iconUnselectedFillColor: Colors.transparent,
                    iconSelectedFillColor: primaryColor.withOpacity(0.2),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Auto-save indicator
        if (_showSaved)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            color: const Color(0xFF10B981).withOpacity(0.2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 14,
                  color: Color(0xFF10B981),
                ),
                const SizedBox(width: 6),
                Text(
                  'Saved',
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFF10B981),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

        // Editor
        Expanded(
          child: Container(
            color: backgroundColor,
            padding: const EdgeInsets.all(16),
            child: quill.QuillEditor.basic(
              controller: _controller,
              focusNode: _focusNode,
              configurations: quill.QuillEditorConfigurations(
                padding: EdgeInsets.zero,
                autoFocus: !widget.readOnly,
                expands: true,
                placeholder: widget.readOnly ? 'No content yet...' : 'Start typing your masterpiece...',
                customStyles: quill.DefaultStyles(
                  placeHolder: quill.DefaultTextBlockStyle(
                    TextStyle(
                      fontSize: 16,
                      color: textColor.withOpacity(0.3),
                      height: 1.6,
                    ),
                    const quill.HorizontalSpacing(0, 0),
                    const quill.VerticalSpacing(0, 0),
                    const quill.VerticalSpacing(0, 0),
                    null,
                  ),
                  paragraph: quill.DefaultTextBlockStyle(
                    TextStyle(
                      fontSize: 16,
                      color: textColor,
                      height: 1.6,
                    ),
                    const quill.HorizontalSpacing(0, 0),
                    const quill.VerticalSpacing(6, 0),
                    const quill.VerticalSpacing(0, 0),
                    null,
                  ),
                  h1: quill.DefaultTextBlockStyle(
                    TextStyle(
                      fontSize: 28,
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                    const quill.HorizontalSpacing(0, 0),
                    const quill.VerticalSpacing(16, 8),
                    const quill.VerticalSpacing(0, 0),
                    null,
                  ),
                  h2: quill.DefaultTextBlockStyle(
                    TextStyle(
                      fontSize: 22,
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                    const quill.HorizontalSpacing(0, 0),
                    const quill.VerticalSpacing(12, 6),
                    const quill.VerticalSpacing(0, 0),
                    null,
                  ),
                  h3: quill.DefaultTextBlockStyle(
                    TextStyle(
                      fontSize: 18,
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                    const quill.HorizontalSpacing(0, 0),
                    const quill.VerticalSpacing(10, 4),
                    const quill.VerticalSpacing(0, 0),
                    null,
                  ),
                  lists: quill.DefaultListBlockStyle(
                    TextStyle(
                      fontSize: 16,
                      color: textColor,
                      height: 1.6,
                    ),
                    const quill.HorizontalSpacing(0, 0),
                    const quill.VerticalSpacing(4, 0),
                    const quill.VerticalSpacing(0, 0),
                    null,
                    null,
                  ),
                ),
              ),
            ),
          ),
        ),
        
        // Word Count & Status Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: surfaceColor,
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Text(
                '$_wordCount words • $_characterCount characters',
                style: TextStyle(
                  color: textColor.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              if (_hasUnsavedChanges)
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Unsaved changes',
                      style: TextStyle(
                        color: const Color(0xFFF59E0B),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              if (_showSaved)
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xFF10B981),
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Saved',
                      style: TextStyle(
                        color: const Color(0xFF10B981),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
              ],
            ),
            
            // Animated Save Indicator (top-right)
            if (_showSaved)
              Positioned(
                top: 16,
                right: 16,
                child: AnimatedBuilder(
                  animation: _saveIndicatorAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _saveIndicatorAnimation.value,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF10B981).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Saved',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            
            // Unsaved Changes Indicator (top-right)
            if (_hasUnsavedChanges && !_showSaved)
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Unsaved',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
            // Floating Quick Actions (bottom-right)
            Positioned(
              bottom: 80,
              right: 16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildQuickActionButton(
                    icon: Icons.access_time,
                    tooltip: 'Insert Date & Time (Ctrl+;)',
                    onTap: _insertCurrentDateTime,
                  ),
                  const SizedBox(height: 8),
                  _buildQuickActionButton(
                    icon: Icons.horizontal_rule,
                    tooltip: 'Insert Divider (Ctrl+-)',
                    onTap: _insertDivider,
                  ),
                  const SizedBox(height: 8),
                  _buildQuickActionButton(
                    icon: Icons.content_copy,
                    tooltip: 'Duplicate Line (Ctrl+D)',
                    onTap: _duplicateCurrentLine,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  Widget _buildFontSizeButton(String label, double size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: InkWell(
        onTap: () {
          final selection = _controller.selection;
          if (selection.isValid) {
            _controller.formatSelection(quill.Attribute.size, size);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  // Advanced text manipulation methods
  void _insertCurrentDateTime() {
    final now = DateTime.now();
    final formattedDate = '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}';
    final index = _controller.selection.baseOffset;
    _controller.document.insert(index, formattedDate);
    _controller.updateSelection(
      TextSelection.collapsed(offset: index + formattedDate.length),
      quill.ChangeSource.local,
    );
  }

  void _insertDivider() {
    final index = _controller.selection.baseOffset;
    _controller.document.insert(index, '\n---\n');
    _controller.updateSelection(
      TextSelection.collapsed(offset: index + 5),
      quill.ChangeSource.local,
    );
  }

  void _duplicateCurrentLine() {
    final selection = _controller.selection;
    final text = _controller.document.toPlainText();
    final lines = text.split('\n');
    
    // Find which line the cursor is on
    int currentPos = 0;
    int lineIndex = 0;
    
    for (int i = 0; i < lines.length; i++) {
      if (currentPos + lines[i].length >= selection.baseOffset) {
        lineIndex = i;
        break;
      }
      currentPos += lines[i].length + 1; // +1 for newline
    }
    
    if (lineIndex < lines.length) {
      final lineToDuplicate = lines[lineIndex];
      final insertPos = currentPos + lineToDuplicate.length;
      _controller.document.insert(insertPos, '\n$lineToDuplicate');
    }
  }
}
