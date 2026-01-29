import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import '../services/rich_text_service.dart';
import '../services/text_transformation_service.dart';

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
  bool _showSaved = false;
  bool _hasUnsavedChanges = false;
  final _richTextService = RichTextService();
  late AnimationController _saveIndicatorController;
  late Animation<double> _saveIndicatorAnimation;
  int _wordCount = 0;
  int _characterCount = 0;
  
  // AI Actions Menu State
  bool _showAIActionsMenu = false;
  Offset _aiActionsMenuPosition = Offset.zero;
  String _selectedText = '';
  TextSelection _currentSelection = const TextSelection.collapsed(offset: 0);
  late AnimationController _aiActionsController;
  late Animation<double> _aiActionsAnimation;
  bool _isTransforming = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
    _controller.addListener(_onTextChanged);
    
    // Initialize animations
    _saveIndicatorController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _saveIndicatorAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _saveIndicatorController,
      curve: Curves.easeInOut,
    ));
    
    // AI Actions Menu Animation
    _aiActionsController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _aiActionsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _aiActionsController,
      curve: Curves.elasticOut,
    ));
  }

  void _initializeController() {
    final doc = _richTextService.createDocument(
      formattedContent: widget.initialFormattedContent,
      plainTextFallback: widget.initialPlainText ?? '',
    );

    _controller = quill.QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    _saveIndicatorController.dispose();
    _aiActionsController.dispose();
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

    // Check for text selection changes
    _handleSelectionChange();

    // Debounce auto-save
    if (_saveTimer?.isActive ?? false) _saveTimer!.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 500), () {
      _saveContent();
    });
  }

  void _handleSelectionChange() {
    final selection = _controller.selection;
    
    if (selection.isValid && !selection.isCollapsed && selection.textInside(_controller.document.toPlainText()).trim().isNotEmpty) {
      // User has selected text
      final selectedText = selection.textInside(_controller.document.toPlainText());
      
      if (selectedText != _selectedText) {
        setState(() {
          _selectedText = selectedText;
          _currentSelection = selection;
        });
        
        // Show AI Actions Menu with a slight delay for better UX
        Future.delayed(const Duration(milliseconds: 300), () {
          if (_selectedText.isNotEmpty && mounted) {
            _showAIActionsMenuAtSelection();
          }
        });
      }
    } else {
      // No selection or empty selection
      if (_showAIActionsMenu) {
        _hideAIActionsMenu();
      }
    }
  }

  void _showAIActionsMenuAtSelection() {
    if (widget.readOnly) return;
    
    setState(() {
      _showAIActionsMenu = true;
      // Position the menu above the selection (we'll calculate this properly later)
      _aiActionsMenuPosition = const Offset(100, 100);
    });
    
    _aiActionsController.forward();
  }

  void _hideAIActionsMenu() {
    _aiActionsController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showAIActionsMenu = false;
          _selectedText = '';
        });
      }
    });
  }

  Future<void> _saveContent() async {
    try {
      final deltaJson = jsonEncode(_controller.document.toDelta().toJson());
      final plainText = _controller.document.toPlainText().trim();

      await widget.onSave(plainText, deltaJson);

      // Animate save indicator
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
                // Formatting Toolbar
                if (!widget.readOnly)
                  Container(
                    color: surfaceColor,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: quill.QuillSimpleToolbar(
                      controller: _controller,
                      configurations: const quill.QuillSimpleToolbarConfigurations(
                        multiRowsDisplay: false,
                        showBoldButton: true,
                        showItalicButton: true,
                        showUnderLineButton: true,
                        showStrikeThrough: true,
                        showColorButton: true,
                        showBackgroundColorButton: true,
                        showListNumbers: true,
                        showListBullets: true,
                        showListCheck: true,
                        showCodeBlock: false,
                        showQuote: true,
                        showIndent: true,
                        showLink: false,
                        showUndo: true,
                        showRedo: true,
                        showDirection: false,
                        showSearchButton: false,
                        showSubscript: false,
                        showSuperscript: false,
                        showSmallButton: false,
                        showInlineCode: true,
                        showClearFormat: true,
                        showHeaderStyle: true,
                        showAlignmentButtons: true,
                      ),
                    ),
                  ),

                // Editor
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: quill.QuillEditor.basic(
                      controller: _controller,
                      focusNode: _focusNode,
                      configurations: quill.QuillEditorConfigurations(
                        padding: EdgeInsets.zero,
                        autoFocus: !widget.readOnly,
                        expands: true,
                        placeholder: widget.readOnly ? 'No content yet...' : 'Start typing your masterpiece...',
                        readOnly: widget.readOnly,
                      ),
                    ),
                  ),
                ),

                // Status Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '$_wordCount words • $_characterCount characters',
                        style: TextStyle(
                          color: textColor.withValues(alpha: 0.6),
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
                              decoration: const BoxDecoration(
                                color: Color(0xFFF59E0B),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Unsaved changes',
                              style: TextStyle(
                                color: Color(0xFFF59E0B),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      if (_showSaved)
                        const Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Color(0xFF10B981),
                              size: 14,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Saved',
                              style: TextStyle(
                                color: Color(0xFF10B981),
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
                              color: const Color(0xFF10B981).withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
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
            
            // 🔥 AI ACTIONS MENU - THE VIRAL FEATURE
            if (_showAIActionsMenu)
              Positioned(
                left: _aiActionsMenuPosition.dx,
                top: _aiActionsMenuPosition.dy,
                child: AnimatedBuilder(
                  animation: _aiActionsAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 0.8 + (0.2 * _aiActionsAnimation.value),
                      child: Transform.translate(
                        offset: Offset(0, 10 * (1 - _aiActionsAnimation.value)),
                        child: Opacity(
                          opacity: _aiActionsAnimation.value,
                          child: _buildAIActionsMenu(),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIActionsMenu() {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1F2937),
            Color(0xFF111827),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
            blurRadius: 40,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF3B82F6).withValues(alpha: 0.1),
                  const Color(0xFF1E40AF).withValues(alpha: 0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'AI Actions',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _hideAIActionsMenu,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Actions
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                _buildAIActionButton(
                  icon: Icons.auto_fix_high,
                  label: 'Rewrite',
                  description: 'Improve clarity & flow',
                  gradient: const [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                  onTap: () => _performAIAction('rewrite'),
                ),
                const SizedBox(height: 6),
                _buildAIActionButton(
                  icon: Icons.expand_more,
                  label: 'Expand',
                  description: 'Add more detail',
                  gradient: const [Color(0xFF10B981), Color(0xFF059669)],
                  onTap: () => _performAIAction('expand'),
                ),
                const SizedBox(height: 6),
                _buildAIActionButton(
                  icon: Icons.compress,
                  label: 'Shorten',
                  description: 'Make it concise',
                  gradient: const [Color(0xFFF59E0B), Color(0xFFD97706)],
                  onTap: () => _performAIAction('shorten'),
                ),
                const SizedBox(height: 6),
                _buildAIActionButton(
                  icon: Icons.business_center,
                  label: 'Professional',
                  description: 'Formal tone',
                  gradient: const [Color(0xFF6366F1), Color(0xFF4F46E5)],
                  onTap: () => _performAIAction('professional'),
                ),
                const SizedBox(height: 6),
                _buildAIActionButton(
                  icon: Icons.mood,
                  label: 'Casual',
                  description: 'Friendly tone',
                  gradient: const [Color(0xFFEC4899), Color(0xFFDB2777)],
                  onTap: () => _performAIAction('casual'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIActionButton({
    required IconData icon,
    required String label,
    required String description,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isTransforming ? null : onTap,
          borderRadius: BorderRadius.circular(8),
          splashColor: gradient.first.withValues(alpha: 0.2),
          highlightColor: gradient.first.withValues(alpha: 0.1),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isTransforming 
                  ? [Colors.grey.withValues(alpha: 0.1), Colors.grey.withValues(alpha: 0.05)]
                  : gradient.map((c) => c.withValues(alpha: 0.1)).toList(),
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _isTransforming 
                  ? Colors.grey.withValues(alpha: 0.2)
                  : gradient.first.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: _isTransforming 
                      ? LinearGradient(colors: [Colors.grey, Colors.grey.shade600])
                      : LinearGradient(colors: gradient),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: _isTransforming
                    ? const Padding(
                        padding: EdgeInsets.all(8),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Icon(
                        icon,
                        color: Colors.white,
                        size: 16,
                      ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          color: _isTransforming 
                            ? Colors.white.withValues(alpha: 0.5)
                            : Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        description,
                        style: TextStyle(
                          color: _isTransforming 
                            ? Colors.white.withValues(alpha: 0.3)
                            : Colors.white.withValues(alpha: 0.7),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: _isTransforming ? 0.25 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    _isTransforming ? Icons.hourglass_empty : Icons.arrow_forward_ios,
                    color: _isTransforming 
                      ? Colors.white.withValues(alpha: 0.3)
                      : Colors.white.withValues(alpha: 0.5),
                    size: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _performAIAction(String action) async {
    if (_selectedText.isEmpty || _isTransforming) return;
    
    setState(() {
      _isTransforming = true;
    });
    
    _hideAIActionsMenu();
    
    try {
      // Show loading indicator
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
              const SizedBox(width: 12),
              Text('AI is ${_getActionVerb(action)}...'),
            ],
          ),
          backgroundColor: const Color(0xFF3B82F6),
          duration: const Duration(seconds: 30),
        ),
      );

      // Get surrounding context for better AI results
      final fullText = _controller.document.toPlainText();
      final contextStart = (_currentSelection.start - 100).clamp(0, fullText.length);
      final contextEnd = (_currentSelection.end + 100).clamp(0, fullText.length);
      final context = fullText.substring(contextStart, contextEnd);

      // Call AI transformation service
      final transformedText = await _textTransformationService.transformText(
        text: _selectedText,
        action: action,
        context: context,
      );

      // Replace text with smooth animation
      await _replaceSelectedTextWithAnimation(transformedText);

      // Hide loading indicator
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text('Text ${_getActionVerb(action)} successfully!'),
            ],
          ),
          backgroundColor: const Color(0xFF10B981),
          duration: const Duration(seconds: 2),
        ),
      );

    } catch (e) {
      // Hide loading indicator
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Expanded(child: Text('Failed to ${_getActionVerb(action)}: ${e.toString()}')),
            ],
          ),
          backgroundColor: const Color(0xFFEF4444),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isTransforming = false;
      });
    }
  }

  String _getActionVerb(String action) {
    switch (action) {
      case 'rewrite': return 'rewriting';
      case 'expand': return 'expanding';
      case 'shorten': return 'shortening';
      case 'professional': return 'professionalizing';
      case 'casual': return 'casualizing';
      default: return 'transforming';
    }
  }

  Future<void> _replaceSelectedTextWithAnimation(String newText) async {
    if (!_currentSelection.isValid) return;

    // Store the current selection
    final selection = _currentSelection;
    
    // Replace the text in the document
    _controller.replaceText(
      selection.start,
      selection.end - selection.start,
      newText,
      TextSelection.collapsed(offset: selection.start + newText.length),
    );

    // Update selection to highlight the new text
    _controller.updateSelection(
      TextSelection(
        baseOffset: selection.start,
        extentOffset: selection.start + newText.length,
      ),
      quill.ChangeSource.local,
    );

    // Clear the AI menu state
    setState(() {
      _selectedText = newText;
      _currentSelection = TextSelection(
        baseOffset: selection.start,
        extentOffset: selection.start + newText.length,
      );
    });

    // Auto-save the changes
    _saveContent();
  }
}