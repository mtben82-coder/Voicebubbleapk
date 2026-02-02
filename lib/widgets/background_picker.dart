// ============================================================
//        BACKGROUND PICKER WIDGET
// ============================================================

import 'package:flutter/material.dart';
import '../constants/background_assets.dart';

// ════════════════════════════════════════════════════════════════════════════
// BACKGROUND PICKER DIALOG (for use in dialogs/showDialog)
// ════════════════════════════════════════════════════════════════════════════

class BackgroundPickerDialog extends StatelessWidget {
  final String currentBackground;
  final Function(String) onSelect;

  const BackgroundPickerDialog({
    super.key,
    required this.currentBackground,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 500, maxWidth: 400),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Choose Background',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Options grid
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // None option
                    _buildOption(
                      context,
                      id: 'none',
                      name: 'None',
                      color: const Color(0xFF1E1E1E),
                      icon: Icons.block,
                    ),
                    const SizedBox(height: 16),

                    // Papers section
                    const Text(
                      'Paper Types',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: BackgroundAssets.allPapers.map((paper) {
                        return _buildOption(
                          context,
                          id: paper.id,
                          name: paper.name,
                          color: paper.fallbackColor ?? const Color(0xFFF5F5F5),
                          icon: Icons.description,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Images section
                    const Text(
                      'Background Images',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: BackgroundAssets.allBackgrounds.map((bg) {
                        return _buildOption(
                          context,
                          id: bg.id,
                          name: bg.name,
                          color: bg.fallbackColor ?? const Color(0xFF2196F3),
                          icon: Icons.image,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required String id,
    required String name,
    required Color color,
    required IconData icon,
  }) {
    final isSelected = currentBackground == id;
    return GestureDetector(
      onTap: () => onSelect(id),
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: Colors.white70, size: 20),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: const TextStyle(color: Colors.white, fontSize: 10),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFF3B82F6), size: 14),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// BACKGROUND PICKER BOTTOM SHEET (for use in showModalBottomSheet)
// ════════════════════════════════════════════════════════════════════════════

class BackgroundPicker extends StatelessWidget {
  final String? currentBackgroundId;
  final Function(String?) onBackgroundSelected;

  const BackgroundPicker({
    super.key,
    this.currentBackgroundId,
    required this.onBackgroundSelected,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = const Color(0xFF000000);
    final surfaceColor = const Color(0xFF1A1A1A);
    final textColor = Colors.white;
    final secondaryTextColor = const Color(0xFF94A3B8);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Choose Background',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.close, color: secondaryTextColor),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // None option
                _buildBackgroundOption(
                  context,
                  id: null,
                  name: 'None',
                  subtitle: 'Default dark background',
                  icon: Icons.block,
                  color: const Color(0xFF1E1E1E),
                  surfaceColor: surfaceColor,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),
                const SizedBox(height: 24),

                // Paper section
                Text(
                  'Paper Types',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),
                ...BackgroundAssets.allPapers.map((paper) {
                  return _buildBackgroundOption(
                    context,
                    id: paper.id,
                    name: paper.name,
                    subtitle: 'PDF paper texture',
                    icon: Icons.description,
                    color: paper.fallbackColor ?? const Color(0xFFE0E0E0),
                    surfaceColor: surfaceColor,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                  );
                }),
                const SizedBox(height: 24),

                // Backgrounds section
                Text(
                  'Background Images',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),
                ...BackgroundAssets.allBackgrounds.map((bg) {
                  return _buildBackgroundOption(
                    context,
                    id: bg.id,
                    name: bg.name,
                    subtitle: 'Image background',
                    icon: Icons.image,
                    color: bg.fallbackColor ?? const Color(0xFF2196F3),
                    surfaceColor: surfaceColor,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundOption(
    BuildContext context, {
    required String? id,
    required String name,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color surfaceColor,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    final isSelected = currentBackgroundId == id;

    return GestureDetector(
      onTap: () {
        onBackgroundSelected(id);
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF3B82F6) : Colors.white.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Preview circle
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Icon(icon, color: Colors.white.withOpacity(0.7), size: 24),
            ),
            const SizedBox(width: 16),
            // Name and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            // Selected indicator
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFF3B82F6), size: 24),
          ],
        ),
      ),
    );
  }
}
