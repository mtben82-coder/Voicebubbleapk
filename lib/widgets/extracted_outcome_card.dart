import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../models/extracted_outcome.dart';
import '../widgets/outcome_chip.dart';

class ExtractedOutcomeCard extends StatefulWidget {
  final ExtractedOutcome outcome;
  final VoidCallback onContinue;
  final VoidCallback onAddToProject;
  final Function(String) onTextChanged;
  
  const ExtractedOutcomeCard({
    super.key,
    required this.outcome,
    required this.onContinue,
    required this.onAddToProject,
    required this.onTextChanged,
  });

  @override
  State<ExtractedOutcomeCard> createState() => _ExtractedOutcomeCardState();
}

class _ExtractedOutcomeCardState extends State<ExtractedOutcomeCard> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.outcome.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = const Color(0xFF1A1A1A);
    final textColor = Colors.white;
    final secondaryTextColor = const Color(0xFF94A3B8);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Outcome type chip
          OutcomeChip(
            outcomeType: widget.outcome.type,
            isSelected: true,
            onTap: () {},
          ),
          
          const SizedBox(height: 12),
          
          // Editable text
          TextField(
            controller: _controller,
            style: TextStyle(
              fontSize: 16,
              color: textColor,
              height: 1.5,
            ),
            maxLines: null,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Edit outcome...',
              hintStyle: TextStyle(color: secondaryTextColor.withOpacity(0.5)),
            ),
            onChanged: widget.onTextChanged,
          ),
          
          const SizedBox(height: 16),
          
          // Action buttons
          Row(
            children: [
              // Share button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Share.share(_controller.text);
                  },
                  icon: const Icon(Icons.share, size: 16),
                  label: const Text('Share'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF3B82F6),
                    side: BorderSide(color: const Color(0xFF3B82F6).withOpacity(0.3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Continue button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: widget.onContinue,
                  icon: const Icon(Icons.play_arrow, size: 16),
                  label: const Text('Continue'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF10B981),
                    side: BorderSide(color: const Color(0xFF10B981).withOpacity(0.3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Add to Project button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: widget.onAddToProject,
                  icon: const Icon(Icons.folder_outlined, size: 16),
                  label: const Text('Project'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF9333EA),
                    side: BorderSide(color: const Color(0xFF9333EA).withOpacity(0.3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
