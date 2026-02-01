import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../providers/app_state_provider.dart';
import '../../models/recording_item.dart';
import '../../widgets/rich_text_editor.dart';
import '../../widgets/tag_chip.dart';
import '../../widgets/tag_selection_dialog.dart';

class DocumentCreationScreen extends StatefulWidget {
  final String? projectId;
  final String? itemId; // For editing existing documents
  final String? initialText;

  const DocumentCreationScreen({
    super.key,
    this.projectId,
    this.itemId,
    this.initialText,
  });

  @override
  State<DocumentCreationScreen> createState() => _DocumentCreationScreenState();
}

class _DocumentCreationScreenState extends State<DocumentCreationScreen> {
  late TextEditingController _titleController;
  final FocusNode _titleFocusNode = FocusNode();
  
  List<String> _selectedTags = [];
  bool _isLoading = false;
  bool _hasUnsavedChanges = false;
  String _currentPlainText = '';
  String _currentDeltaJson = '';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _titleController.addListener(_onTitleChanged);
    
    // Load existing item if editing
    if (widget.itemId != null) {
      _loadExistingItem();
    }
  }

  void _onTitleChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  Future<void> _loadExistingItem() async {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final item = appState.recordingItems.where((i) => i.id == widget.itemId).firstOrNull;
    
    if (item != null) {
      setState(() {
        _titleController.text = item.customTitle ?? '';
        _selectedTags = List.from(item.tags);
        _currentPlainText = item.finalText;
        _currentDeltaJson = item.formattedContent ?? '';
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Discard changes?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'You have unsaved changes. Do you want to discard them?',
          style: TextStyle(color: Color(0xFF94A3B8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard', style: TextStyle(color: Color(0xFFEF4444))),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  Future<void> _saveDocument(String plainText, String deltaJson) async {
    if (plainText.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add some content'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final appState = Provider.of<AppStateProvider>(context, listen: false);
      
      if (widget.itemId != null) {
        // Update existing item
        final existingItem = appState.recordingItems.where((i) => i.id == widget.itemId).firstOrNull;
        if (existingItem != null) {
          final updatedItem = existingItem.copyWith(
            finalText: plainText.trim(),
            formattedContent: deltaJson,
            customTitle: _titleController.text.trim().isEmpty ? null : _titleController.text.trim(),
            tags: _selectedTags,
          );
          await appState.updateRecording(updatedItem);
        }
      } else {
        // Create new item
        final newItem = RecordingItem(
          id: const Uuid().v4(),
          rawTranscript: plainText.trim(), // Store plain text as transcript
          finalText: plainText.trim(),
          formattedContent: deltaJson, // Store rich text formatting
          presetUsed: 'Document',
          outcomes: [],
          projectId: widget.projectId,
          createdAt: DateTime.now(),
          editHistory: [plainText.trim()],
          presetId: 'document',
          tags: _selectedTags,
          customTitle: _titleController.text.trim().isEmpty ? null : _titleController.text.trim(),
          contentType: 'text',
        );

        await appState.saveRecording(newItem);
      }

      setState(() {
        _hasUnsavedChanges = false;
        _currentPlainText = plainText;
        _currentDeltaJson = deltaJson;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.itemId != null ? 'Document updated' : 'Document created'),
            backgroundColor: const Color(0xFF10B981),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _showTagSelectionDialog() async {
    final result = await showDialog<List<String>>(
      context: context,
      builder: (context) => TagSelectionDialog(
        selectedTagIds: _selectedTags,
      ),
    );

    if (result != null) {
      setState(() {
        _selectedTags = result;
        _hasUnsavedChanges = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF000000);
    const surfaceColor = Color(0xFF1A1A1A);
    const textColor = Colors.white;
    const secondaryTextColor = Color(0xFF94A3B8);
    const primaryColor = Color(0xFF3B82F6);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: Text(
            widget.itemId != null ? 'Edit Document' : 'New Document',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          actions: [
            // Tag button
            IconButton(
              onPressed: _showTagSelectionDialog,
              icon: Icon(
                Icons.label_outline,
                color: _selectedTags.isNotEmpty ? primaryColor : secondaryTextColor,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Title field
              Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _titleController,
                  focusNode: _titleFocusNode,
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Document title (optional)',
                    hintStyle: TextStyle(color: secondaryTextColor),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),

              // Tags display
              if (_selectedTags.isNotEmpty)
                Consumer<AppStateProvider>(
                  builder: (context, appState, _) {
                    final tags = appState.tags;
                    final selectedTagObjects = _selectedTags
                        .map((tagId) => tags.where((t) => t.id == tagId).firstOrNull)
                        .where((t) => t != null)
                        .toList();

                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: selectedTagObjects.map((tag) {
                          return TagChip(
                            tag: tag!,
                            isSelected: true,
                            onTap: () {
                              setState(() {
                                _selectedTags.remove(tag.id);
                                _hasUnsavedChanges = true;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),

              // Rich Text Editor
              Expanded(
                child: RichTextEditor(
                  initialFormattedContent: _currentDeltaJson.isNotEmpty ? _currentDeltaJson : null,
                  initialPlainText: widget.initialText ?? _currentPlainText,
                  onSave: (plainText, deltaJson) async {
                    await _saveDocument(plainText, deltaJson);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}