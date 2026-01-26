import 'package:flutter/material.dart';
import '../models/tag.dart';
import '../services/tag_service.dart';
import '../widgets/tag_chip.dart';

class CreateTagDialog extends StatefulWidget {
  final Tag? existingTag; // For editing

  const CreateTagDialog({
    super.key,
    this.existingTag,
  });

  @override
  State<CreateTagDialog> createState() => _CreateTagDialogState();
}

class _CreateTagDialogState extends State<CreateTagDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TagService _tagService = TagService();
  int _selectedColor = 0xFFEF4444; // Default red
  String? _error;

  final List<int> tagColors = [
    0xFFEF4444, // Red
    0xFFF59E0B, // Orange
    0xFFFBBF24, // Yellow
    0xFF10B981, // Green
    0xFF14B8A6, // Teal
    0xFF06B6D4, // Cyan
    0xFF3B82F6, // Blue
    0xFF8B5CF6, // Purple
    0xFFEC4899, // Pink
    0xFFF97316, // Deep Orange
    0xFF6366F1, // Indigo
    0xFF64748B, // Gray
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingTag != null) {
      _nameController.text = widget.existingTag!.name;
      _selectedColor = widget.existingTag!.color;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveTag() async {
    final name = _nameController.text.trim();
    
    if (name.isEmpty) {
      setState(() {
        _error = 'Tag name cannot be empty';
      });
      return;
    }

    // Check for duplicates (unless editing current tag)
    if (widget.existingTag == null || widget.existingTag!.name != name) {
      final exists = await _tagService.tagExists(name);
      if (exists) {
        setState(() {
          _error = 'Tag "$name" already exists';
        });
        return;
      }
    }

    try {
      if (widget.existingTag != null) {
        // Update existing tag
        await _tagService.updateTag(widget.existingTag!.id, name, _selectedColor);
      } else {
        // Create new tag
        await _tagService.createTag(name, _selectedColor);
      }
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to save tag: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = const Color(0xFF1A1A1A);
    final surfaceColor = const Color(0xFF2A2A2A);
    final textColor = Colors.white;
    final secondaryTextColor = const Color(0xFF94A3B8);

    // Create a preview tag for display
    final previewTag = Tag(
      id: 'preview',
      name: _nameController.text.isEmpty ? 'Tag Name' : _nameController.text,
      color: _selectedColor,
      createdAt: DateTime.now(),
    );

    return Dialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.label, color: Color(_selectedColor), size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.existingTag != null ? 'Edit Tag' : 'Create New Tag',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: secondaryTextColor),
                ),
              ],
            ),
            
            const SizedBox(height: 24),

            // Preview
            Center(
              child: TagChip(
                tag: previewTag,
                isSelected: true,
                size: 'large',
              ),
            ),

            const SizedBox(height: 24),

            // Tag name input
            Text(
              'Tag Name',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              autofocus: true,
              style: TextStyle(color: textColor, fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Enter tag name...',
                hintStyle: TextStyle(color: secondaryTextColor),
                filled: true,
                fillColor: surfaceColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _error = null;
                });
              },
            ),

            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFEF4444),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Color picker
            Text(
              'Choose Color',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: tagColors.map((colorValue) {
                final isSelected = _selectedColor == colorValue;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = colorValue;
                    });
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Color(colorValue),
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Color(colorValue).withOpacity(0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveTag,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  widget.existingTag != null ? 'Update Tag' : 'Create Tag',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
