import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'text_selection_ai_menu.dart';

class EditableResultBox extends StatefulWidget {
  final String initialText;
  final Function(String) onTextChanged;
  final bool isLoading;

  const EditableResultBox({
    super.key,
    required this.initialText,
    required this.onTextChanged,
    this.isLoading = false,
  });

  @override
  State<EditableResultBox> createState() => _EditableResultBoxState();
}

class _EditableResultBoxState extends State<EditableResultBox> {
  late TextEditingController _controller;
  Timer? _debounce;
  Timer? _selectionTimer;
  
  bool _hasSelection = false;
  String _selectedText = '';
  int _selectionStart = 0;
  int _selectionEnd = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    _controller.addListener(_onSelectionChanged);
  }

  @override
  void didUpdateWidget(EditableResultBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialText != oldWidget.initialText && 
        widget.initialText != _controller.text) {
      _controller.text = widget.initialText;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _selectionTimer?.cancel();
    _controller.removeListener(_onSelectionChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onSelectionChanged() {
    _selectionTimer?.cancel();
    _selectionTimer = Timer(const Duration(milliseconds: 300), () {
      final selection = _controller.selection;
      
      if (selection.baseOffset != selection.extentOffset) {
        final start = selection.start;
        final end = selection.end;
        final text = _controller.text.substring(start, end);
        
        if (text.trim().isNotEmpty && text.length > 1) {
          setState(() {
            _hasSelection = true;
            _selectedText = text;
            _selectionStart = start;
            _selectionEnd = end;
          });
        }
      } else {
        if (_hasSelection) {
          setState(() {
            _hasSelection = false;
            _selectedText = '';
          });
        }
      }
    });
  }

  void _onTextChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onTextChanged(value);
    });
  }

  void _showAIMenu() {
    if (_selectedText.isEmpty) return;
    HapticFeedback.mediumImpact();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        child: TextSelectionAIMenu(
          selectedText: _selectedText,
          onReplace: (newText) {
            Navigator.pop(context);
            _replaceSelection(newText);
          },
          onDismiss: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _replaceSelection(String newText) {
    final before = _controller.text.substring(0, _selectionStart);
    final after = _controller.text.substring(_selectionEnd);
    final newFull = before + newText + after;
    
    _controller.text = newFull;
    _controller.selection = TextSelection.collapsed(
      offset: _selectionStart + newText.length,
    );
    
    widget.onTextChanged(newFull);
    setState(() {
      _hasSelection = false;
      _selectedText = '';
    });
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3B82F6);
    const textColor = Colors.white;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryColor.withOpacity(0.1),
                const Color(0xFF2563EB).withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: primaryColor.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: widget.isLoading
              ? const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(primaryColor),
                    ),
                  ),
                )
              : Theme(
                  data: Theme.of(context).copyWith(
                    textSelectionTheme: TextSelectionThemeData(
                      selectionColor: primaryColor.withOpacity(0.3),
                      cursorColor: primaryColor,
                      selectionHandleColor: primaryColor,
                    ),
                  ),
                  child: TextField(
                    controller: _controller,
                    onChanged: _onTextChanged,
                    maxLines: null,
                    cursorColor: primaryColor,
                    style: const TextStyle(
                      color: textColor,
                      fontSize: 16,
                      height: 1.6,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Your text will appear here...',
                      hintStyle: TextStyle(color: textColor.withOpacity(0.3)),
                    ),
                  ),
                ),
        ),
        
        // Small floating AI button
        if (_hasSelection && _selectedText.isNotEmpty)
          Positioned(
            right: 8,
            bottom: 8,
            child: GestureDetector(
              onTap: _showAIMenu,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.white, size: 12),
                    SizedBox(width: 4),
                    Text(
                      'AI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
