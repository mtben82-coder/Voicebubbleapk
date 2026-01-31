import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../providers/app_state_provider.dart';
import '../../models/recording_item.dart';
import '../../widgets/tag_chip.dart';
import '../../widgets/tag_selection_dialog.dart';

class TodoItem {
  String id;
  String text;
  bool isCompleted;

  TodoItem({
    required this.id,
    required this.text,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isCompleted': isCompleted,
    };
  }

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['id'],
      text: json['text'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

class TodoCreationScreen extends StatefulWidget {
  final String? projectId;
  final String? itemId; // For editing existing todos

  const TodoCreationScreen({
    super.key,
    this.projectId,
    this.itemId,
  });

  @override
  State<TodoCreationScreen> createState() => _TodoCreationScreenState();
}

class _TodoCreationScreenState extends State<TodoCreationScreen> {
  late TextEditingController _titleController;
  final List<TodoItem> _todoItems = [];
  final List<TextEditingController> _todoControllers = [];
  final List<FocusNode> _todoFocusNodes = [];
  
  List<String> _selectedTags = [];
  bool _isLoading = false;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _titleController.addListener(_onTextChanged);
    
    // Start with one empty todo item
    _addTodoItem('');
    
    // Load existing item if editing
    if (widget.itemId != null) {
      _loadExistingItem();
    } else {
      // Auto-focus first todo item for new lists
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_todoFocusNodes.isNotEmpty) {
          _todoFocusNodes.first.requestFocus();
        }
      });
    }
  }

  void _onTextChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  void _addTodoItem(String text, {bool isCompleted = false}) {
    final todoItem = TodoItem(
      id: const Uuid().v4(),
      text: text,
      isCompleted: isCompleted,
    );
    
    final controller = TextEditingController(text: text);
    final focusNode = FocusNode();
    
    controller.addListener(_onTextChanged);
    
    setState(() {
      _todoItems.add(todoItem);
      _todoControllers.add(controller);
      _todoFocusNodes.add(focusNode);
    });
  }

  void _removeTodoItem(int index) {
    if (_todoItems.length <= 1) return; // Keep at least one item
    
    setState(() {
      _todoControllers[index].dispose();
      _todoFocusNodes[index].dispose();
      
      _todoItems.removeAt(index);
      _todoControllers.removeAt(index);
      _todoFocusNodes.removeAt(index);
      _hasUnsavedChanges = true;
    });
  }

  void _toggleTodoItem(int index) {
    setState(() {
      _todoItems[index].isCompleted = !_todoItems[index].isCompleted;
      _hasUnsavedChanges = true;
    });
  }

  Future<void> _loadExistingItem() async {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final item = appState.recordingItems.where((i) => i.id == widget.itemId).firstOrNull;
    
    if (item != null) {
      setState(() {
        _titleController.text = item.customTitle ?? '';
        _selectedTags = List.from(item.tags);
      });
      
      // Clear existing items
      for (var controller in _todoControllers) {
        controller.dispose();
      }
      for (var focusNode in _todoFocusNodes) {
        focusNode.dispose();
      }
      _todoItems.clear();
      _todoControllers.clear();
      _todoFocusNodes.clear();
      
      // Parse todo items from finalText (stored as JSON)
      try {
        if (item.finalText.isNotEmpty) {
          final List<dynamic> todoData = [];
          // Try to parse as JSON, fallback to simple text
          try {
            final parsed = item.finalText.split('\n');
            for (String line in parsed) {
              if (line.trim().isNotEmpty) {
                final isCompleted = line.startsWith('☑ ') || line.startsWith('[x] ');
                final text = line.replaceAll(RegExp(r'^(\[[ x]\]|[☐☑]) '), '');
                _addTodoItem(text, isCompleted: isCompleted);
              }
            }
          } catch (e) {
            // Fallback: treat as simple text
            _addTodoItem(item.finalText);
          }
        }
      } catch (e) {
        _addTodoItem('');
      }
      
      if (_todoItems.isEmpty) {
        _addTodoItem('');
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (var controller in _todoControllers) {
      controller.dispose();
    }
    for (var focusNode in _todoFocusNodes) {
      focusNode.dispose();
    }
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

  String _generateTodoText() {
    return _todoItems.map((item) {
      final checkbox = item.isCompleted ? '☑' : '☐';
      return '$checkbox ${item.text}';
    }).join('\n');
  }

  Future<void> _saveTodoList() async {
    // Remove empty todo items
    final nonEmptyTodos = <int>[];
    for (int i = 0; i < _todoItems.length; i++) {
      final text = _todoControllers[i].text.trim();
      if (text.isNotEmpty) {
        _todoItems[i].text = text;
        nonEmptyTodos.add(i);
      }
    }

    if (nonEmptyTodos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one todo item'),
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
      
      // Update text in remaining items
      for (int i in nonEmptyTodos) {
        _todoItems[i].text = _todoControllers[i].text.trim();
      }
      
      final todoText = _generateTodoText();
      
      if (widget.itemId != null) {
        // Update existing item
        final existingItem = appState.recordingItems.where((i) => i.id == widget.itemId).firstOrNull;
        if (existingItem != null) {
          final updatedItem = existingItem.copyWith(
            finalText: todoText,
            customTitle: _titleController.text.trim().isEmpty ? null : _titleController.text.trim(),
            tags: _selectedTags,
          );
          await appState.updateRecording(updatedItem);
        }
      } else {
        // Create new item
        final newItem = RecordingItem(
          id: const Uuid().v4(),
          rawTranscript: '', // Empty for todo lists
          finalText: todoText,
          presetUsed: 'Todo List',
          outcomes: [],
          projectId: widget.projectId,
          createdAt: DateTime.now(),
          editHistory: [],
          presetId: 'todo_list',
          tags: _selectedTags,
          customTitle: _titleController.text.trim().isEmpty ? null : _titleController.text.trim(),
          contentType: 'todo',
        );

        await appState.saveRecording(newItem);
      }

      setState(() {
        _hasUnsavedChanges = false;
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.itemId != null ? 'Todo list updated' : 'Todo list created'),
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
            widget.itemId != null ? 'Edit Todo List' : 'New Todo List',
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
            // Save button
            TextButton(
              onPressed: _isLoading ? null : _saveTodoList,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                    )
                  : const Text(
                      'Save',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
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
                        padding: const EdgeInsets.only(bottom: 16),
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

                // Title field
                Container(
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _titleController,
                    style: const TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Todo list title (optional)',
                      hintStyle: TextStyle(color: secondaryTextColor),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                
                const SizedBox(height: 16),

                // Todo items list
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: _todoItems.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    // Checkbox
                                    GestureDetector(
                                      onTap: () => _toggleTodoItem(index),
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: _todoItems[index].isCompleted 
                                              ? primaryColor 
                                              : Colors.transparent,
                                          border: Border.all(
                                            color: _todoItems[index].isCompleted 
                                                ? primaryColor 
                                                : secondaryTextColor,
                                            width: 2,
                                          ),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: _todoItems[index].isCompleted
                                            ? const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 16,
                                              )
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    
                                    // Text field
                                    Expanded(
                                      child: TextField(
                                        controller: _todoControllers[index],
                                        focusNode: _todoFocusNodes[index],
                                        style: TextStyle(
                                          color: _todoItems[index].isCompleted 
                                              ? secondaryTextColor 
                                              : textColor,
                                          fontSize: 16,
                                          decoration: _todoItems[index].isCompleted 
                                              ? TextDecoration.lineThrough 
                                              : null,
                                        ),
                                        decoration: const InputDecoration(
                                          hintText: 'Add todo item...',
                                          hintStyle: TextStyle(color: secondaryTextColor),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                        textCapitalization: TextCapitalization.sentences,
                                        onSubmitted: (value) {
                                          if (value.trim().isNotEmpty && index == _todoItems.length - 1) {
                                            _addTodoItem('');
                                            Future.delayed(const Duration(milliseconds: 100), () {
                                              _todoFocusNodes.last.requestFocus();
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    
                                    // Delete button
                                    if (_todoItems.length > 1)
                                      IconButton(
                                        onPressed: () => _removeTodoItem(index),
                                        icon: Icon(
                                          Icons.close,
                                          color: secondaryTextColor.withOpacity(0.6),
                                          size: 18,
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        
                        // Add new todo button
                        GestureDetector(
                          onTap: () {
                            _addTodoItem('');
                            Future.delayed(const Duration(milliseconds: 100), () {
                              _todoFocusNodes.last.requestFocus();
                            });
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  border: Border.all(color: secondaryTextColor, width: 2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: secondaryTextColor,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Add item',
                                style: TextStyle(
                                  color: secondaryTextColor,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Status row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_todoItems.where((item) => item.isCompleted).length} of ${_todoItems.length} completed',
                      style: const TextStyle(
                        color: secondaryTextColor,
                        fontSize: 12,
                      ),
                    ),
                    if (_hasUnsavedChanges)
                      const Text(
                        'Unsaved changes',
                        style: TextStyle(
                          color: Color(0xFFF59E0B),
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}