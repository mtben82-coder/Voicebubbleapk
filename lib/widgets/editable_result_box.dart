import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/refinement_service.dart';

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
    _controller.addListener(_checkSelection);
  }

  @override
  void didUpdateWidget(EditableResultBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialText != oldWidget.initialText && 
        widget.initialText != _controller.text) {
      _controller.text = widget.initialText;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _selectionTimer?.cancel();
    _controller.removeListener(_checkSelection);
    _controller.dispose();
    super.dispose();
  }

  void _checkSelection() {
    _selectionTimer?.cancel();
    _selectionTimer = Timer(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      
      final selection = _controller.selection;
      final hasText = selection.baseOffset != selection.extentOffset;
      
      if (hasText) {
        final text = _controller.text.substring(selection.start, selection.end);
        if (text.trim().length > 1) {
          setState(() {
            _hasSelection = true;
            _selectedText = text;
            _selectionStart = selection.start;
            _selectionEnd = selection.end;
          });
          return;
        }
      }
      
      if (_hasSelection) {
        setState(() => _hasSelection = false);
      }
    });
  }

  void _onTextChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onTextChanged(value);
    });
  }

  void _showAIDialog() {
    if (_selectedText.isEmpty) return;
    HapticFeedback.mediumImpact();
    
    showDialog(
      context: context,
      builder: (ctx) => _AIActionDialog(
        selectedText: _selectedText,
        onResult: (newText) {
          Navigator.pop(ctx);
          _replaceSelection(newText);
        },
      ),
    );
  }

  void _replaceSelection(String newText) {
    final before = _controller.text.substring(0, _selectionStart);
    final after = _controller.text.substring(_selectionEnd);
    final full = before + newText + after;
    
    _controller.text = full;
    widget.onTextChanged(full);
    
    setState(() {
      _hasSelection = false;
      _selectedText = '';
    });
    
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3B82F6);

    return Stack(
      children: [
        // Text field container
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: primaryColor.withOpacity(0.3), width: 2),
          ),
          child: widget.isLoading
              ? const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : TextField(
                  controller: _controller,
                  onChanged: _onTextChanged,
                  maxLines: null,
                  style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.6),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Your text will appear here...',
                    hintStyle: TextStyle(color: Colors.white30),
                  ),
                ),
        ),
        
        // Small copy icon at bottom-right
        if (!widget.isLoading)
          Positioned(
            right: 12,
            bottom: 12,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  await Clipboard.setData(ClipboardData(text: _controller.text));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Copied to clipboard'),
                        backgroundColor: Color(0xFF10B981),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.content_copy,
                    size: 18,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
          ),
        
        // Floating button when text selected
        if (_hasSelection)
          Positioned(
            right: 12,
            bottom: 52, // Moved up to avoid overlap with copy icon
            child: FloatingActionButton.small(
              onPressed: _showAIDialog,
              backgroundColor: const Color(0xFF8B5CF6),
              child: const Icon(Icons.auto_awesome, size: 18),
            ),
          ),
      ],
    );
  }
}

// Simple dialog with AI actions
class _AIActionDialog extends StatefulWidget {
  final String selectedText;
  final Function(String) onResult;

  const _AIActionDialog({
    required this.selectedText,
    required this.onResult,
  });

  @override
  State<_AIActionDialog> createState() => _AIActionDialogState();
}

class _AIActionDialogState extends State<_AIActionDialog> {
  bool _loading = false;
  String? _active;
  final _service = RefinementService();

  Future<void> _run(String id) async {
    if (_loading) return;
    setState(() { _loading = true; _active = id; });

    try {
      String result;
      switch (id) {
        case 'shorten':
          result = await _service.shorten(widget.selectedText);
          break;
        case 'expand':
          result = await _service.expand(widget.selectedText);
          break;
        case 'pro':
          result = await _service.makeProfessional(widget.selectedText);
          break;
        case 'casual':
          result = await _service.makeCasual(widget.selectedText);
          break;
        case 'grammar':
          result = await _service.fixGrammar(widget.selectedText);
          break;
        default:
          result = widget.selectedText;
      }
      widget.onResult(result);
    } catch (e) {
      if (mounted) Navigator.pop(context);
    }
  }

  Widget _btn(String id, String label, IconData icon, Color color) {
    final isActive = _active == id && _loading;
    return TextButton.icon(
      onPressed: () => _run(id),
      icon: isActive
          ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: color))
          : Icon(icon, size: 16, color: color),
      label: Text(label, style: TextStyle(color: color, fontSize: 13)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      title: const Row(
        children: [
          Icon(Icons.auto_awesome, color: Color(0xFF8B5CF6), size: 20),
          SizedBox(width: 8),
          Text('AI Actions', style: TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _btn('shorten', 'Shorten', Icons.compress, const Color(0xFFF59E0B)),
          _btn('expand', 'Expand', Icons.expand, const Color(0xFF3B82F6)),
          _btn('pro', 'Professional', Icons.work, const Color(0xFF0891B2)),
          _btn('casual', 'Casual', Icons.mood, const Color(0xFF10B981)),
          _btn('grammar', 'Fix Grammar', Icons.check, const Color(0xFFEC4899)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
        ),
      ],
    );
  }
}
