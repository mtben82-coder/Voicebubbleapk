import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import '../services/refinement_service.dart';

// ============================================================
//        RICH TEXT EDITOR WIDGET — WITH AI SELECTION MENU
// ============================================================

class SaveIntent extends Intent {}
class BoldIntent extends Intent {}
class ItalicIntent extends Intent {}
class UnderlineIntent extends Intent {}
class UndoIntent extends Intent {}
class RedoIntent extends Intent {}

class RichTextEditor extends StatefulWidget {
  final String? initialFormattedContent;
  final String? initialPlainText;
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
  Timer? _selectionTimer;
  bool _showSaved = false;
  bool _hasUnsavedChanges = false;
  late AnimationController _saveIndicatorController;
  late Animation<double> _saveIndicatorAnimation;
  int _wordCount = 0;
  int _characterCount = 0;
  
  // Selection tracking
  bool _hasSelection = false;
  String _selectedText = '';
  int _selectionStart = 0;
  int _selectionEnd = 0;

  @override
  void initState() {
    super.initState();
    _initializeController();
    _controller.addListener(_onControllerChanged);
    
    _saveIndicatorController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _saveIndicatorAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _saveIndicatorController, curve: Curves.easeInOut),
    );
  }

  void _initializeController() {
    quill.Document doc;
    
    if (widget.initialFormattedContent != null && widget.initialFormattedContent!.isNotEmpty) {
      try {
        final deltaJson = jsonDecode(widget.initialFormattedContent!);
        doc = quill.Document.fromJson(deltaJson);
      } catch (e) {
        doc = quill.Document()..insert(0, widget.initialPlainText ?? '');
      }
    } else if (widget.initialPlainText != null && widget.initialPlainText!.isNotEmpty) {
      doc = quill.Document()..insert(0, widget.initialPlainText!);
    } else {
      doc = quill.Document();
    }

    _controller = quill.QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    _selectionTimer?.cancel();
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    _focusNode.dispose();
    _saveIndicatorController.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (widget.readOnly) return;
    
    // Update word/character count
    final plainText = _controller.document.toPlainText();
    final words = plainText.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    
    setState(() {
      _hasUnsavedChanges = true;
      _showSaved = false;
      _wordCount = words;
      _characterCount = plainText.length;
    });

    // Check selection with debounce
    _selectionTimer?.cancel();
    _selectionTimer = Timer(const Duration(milliseconds: 200), _checkSelection);

    // Auto-save with debounce
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 500), _saveContent);
  }

  void _checkSelection() {
    if (!mounted) return;
    
    final selection = _controller.selection;
    final plainText = _controller.document.toPlainText();
    
    if (selection.baseOffset != selection.extentOffset) {
      final start = selection.start;
      final end = selection.end;
      
      if (end <= plainText.length) {
        final text = plainText.substring(start, end);
        if (text.trim().length > 1) {
          setState(() {
            _hasSelection = true;
            _selectedText = text;
            _selectionStart = start;
            _selectionEnd = end;
          });
          return;
        }
      }
    }
    
    if (_hasSelection) {
      setState(() {
        _hasSelection = false;
        _selectedText = '';
      });
    }
  }

  Future<void> _saveContent() async {
    if (!mounted) return;
    
    try {
      final deltaJson = jsonEncode(_controller.document.toDelta().toJson());
      final plainText = _controller.document.toPlainText().trim();

      await widget.onSave(plainText, deltaJson);

      if (mounted) {
        setState(() {
          _hasUnsavedChanges = false;
          _showSaved = true;
        });
        
        _saveIndicatorController.forward().then((_) {
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              _saveIndicatorController.reverse().then((_) {
                if (mounted) setState(() => _showSaved = false);
              });
            }
          });
        });
      }
    } catch (e) {
      debugPrint('Save error: $e');
    }
  }

  void _showAIMenu() {
    if (_selectedText.isEmpty) return;
    HapticFeedback.mediumImpact();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AIMenuSheet(
        selectedText: _selectedText,
        onResult: (newText) {
          Navigator.pop(ctx);
          _replaceSelection(newText);
        },
      ),
    );
  }

  void _replaceSelection(String newText) {
    _controller.replaceText(
      _selectionStart,
      _selectionEnd - _selectionStart,
      newText,
      null,
    );
    
    setState(() {
      _hasSelection = false;
      _selectedText = '';
    });
    
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    const surfaceColor = Color(0xFF1A1A1A);

    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS): SaveIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyB): BoldIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyI): ItalicIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyU): UnderlineIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyZ): UndoIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyY): RedoIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          SaveIntent: CallbackAction<SaveIntent>(onInvoke: (_) => _saveContent()),
          BoldIntent: CallbackAction<BoldIntent>(onInvoke: (_) => _controller.formatSelection(quill.Attribute.bold)),
          ItalicIntent: CallbackAction<ItalicIntent>(onInvoke: (_) => _controller.formatSelection(quill.Attribute.italic)),
          UnderlineIntent: CallbackAction<UnderlineIntent>(onInvoke: (_) => _controller.formatSelection(quill.Attribute.underline)),
          UndoIntent: CallbackAction<UndoIntent>(onInvoke: (_) => _controller.undo()),
          RedoIntent: CallbackAction<RedoIntent>(onInvoke: (_) => _controller.redo()),
        },
        child: Stack(
          children: [
            Column(
              children: [
                // Toolbar
                if (!widget.readOnly)
                  Container(
                    color: surfaceColor,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: quill.QuillSimpleToolbar(
                      configurations: quill.QuillSimpleToolbarConfigurations(
                        controller: _controller,
                        multiRowsDisplay: false,
                        showBoldButton: true,
                        showItalicButton: true,
                        showUnderLineButton: true,
                        showStrikeThrough: false,
                        showColorButton: false,
                        showBackgroundColorButton: false,
                        showListNumbers: true,
                        showListBullets: true,
                        showListCheck: true,
                        showCodeBlock: false,
                        showQuote: false,
                        showIndent: false,
                        showLink: false,
                        showUndo: true,
                        showRedo: true,
                        showDirection: false,
                        showSearchButton: false,
                        showSubscript: false,
                        showSuperscript: false,
                        showSmallButton: false,
                        showInlineCode: false,
                        showClearFormat: false,
                        showHeaderStyle: true,
                        showAlignmentButtons: false,
                      ),
                    ),
                  ),

                // Editor
                Expanded(
                  child: Container(
                    color: Colors.black,
                    padding: const EdgeInsets.all(16),
                    child: quill.QuillEditor.basic(
                      focusNode: _focusNode,
                      configurations: quill.QuillEditorConfigurations(
                        controller: _controller,
                        padding: EdgeInsets.zero,
                        autoFocus: !widget.readOnly,
                        expands: true,
                        placeholder: 'Start typing...',
                        readOnly: widget.readOnly,
                        customStyles: quill.DefaultStyles(
                          paragraph: quill.DefaultTextBlockStyle(
                            const TextStyle(color: Colors.white, fontSize: 16, height: 1.6),
                            const quill.VerticalSpacing(0, 0),
                            const quill.VerticalSpacing(0, 0),
                            null,
                          ),
                          placeHolder: quill.DefaultTextBlockStyle(
                            TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 16),
                            const quill.VerticalSpacing(0, 0),
                            const quill.VerticalSpacing(0, 0),
                            null,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Status bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '$_wordCount words • $_characterCount characters',
                        style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                      ),
                      const Spacer(),
                      if (_hasUnsavedChanges)
                        const Row(
                          children: [
                            Icon(Icons.circle, color: Color(0xFFF59E0B), size: 6),
                            SizedBox(width: 6),
                            Text('Unsaved', style: TextStyle(color: Color(0xFFF59E0B), fontSize: 12)),
                          ],
                        ),
                      if (_showSaved)
                        const Row(
                          children: [
                            Icon(Icons.check_circle, color: Color(0xFF10B981), size: 14),
                            SizedBox(width: 6),
                            Text('Saved', style: TextStyle(color: Color(0xFF10B981), fontSize: 12)),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
            
            // AI BUTTON - shows when text selected
            if (_hasSelection)
              Positioned(
                right: 16,
                bottom: 60,
                child: FloatingActionButton.small(
                  onPressed: _showAIMenu,
                  backgroundColor: const Color(0xFF8B5CF6),
                  child: const Icon(Icons.auto_awesome, size: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// AI MENU BOTTOM SHEET
// ============================================================

class _AIMenuSheet extends StatefulWidget {
  final String selectedText;
  final Function(String) onResult;

  const _AIMenuSheet({required this.selectedText, required this.onResult});

  @override
  State<_AIMenuSheet> createState() => _AIMenuSheetState();
}

class _AIMenuSheetState extends State<_AIMenuSheet> {
  bool _loading = false;
  String? _active;
  final _service = RefinementService();

  Future<void> _run(String id) async {
    if (_loading) return;
    setState(() { _loading = true; _active = id; });

    try {
      String result;
      switch (id) {
        case 'magic': result = await _service.refineText(widget.selectedText, RefinementType.professional); break;
        case 'shorten': result = await _service.shorten(widget.selectedText); break;
        case 'expand': result = await _service.expand(widget.selectedText); break;
        case 'pro': result = await _service.makeProfessional(widget.selectedText); break;
        case 'casual': result = await _service.makeCasual(widget.selectedText); break;
        case 'grammar': result = await _service.fixGrammar(widget.selectedText); break;
        default: result = widget.selectedText;
      }
      widget.onResult(result);
    } catch (e) {
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: Color(0xFF8B5CF6), size: 20),
              SizedBox(width: 8),
              Text('AI Actions', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),
          // Magic button - full width
          _btn('magic', '✨ Magic', Icons.auto_awesome, const Color(0xFF8B5CF6)),
          const SizedBox(height: 8),
          // Buttons
          Row(children: [
            _btn('shorten', 'Shorten', Icons.compress, const Color(0xFFF59E0B)),
            const SizedBox(width: 8),
            _btn('expand', 'Expand', Icons.expand, const Color(0xFF3B82F6)),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            _btn('pro', 'Professional', Icons.work, const Color(0xFF0891B2)),
            const SizedBox(width: 8),
            _btn('casual', 'Casual', Icons.mood, const Color(0xFF10B981)),
          ]),
          const SizedBox(height: 8),
          _btn('grammar', 'Fix Grammar', Icons.check, const Color(0xFFEC4899)),
        ],
      ),
    );
  }

  Widget _btn(String id, String label, IconData icon, Color color) {
    final isActive = _active == id && _loading;
    return Expanded(
      child: GestureDetector(
        onTap: () => _run(id),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? color.withOpacity(0.2) : const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isActive)
                SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: color))
              else
                Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}
