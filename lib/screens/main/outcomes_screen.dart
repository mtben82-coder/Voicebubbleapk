import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../models/outcome_type.dart';
import '../../models/recording_item.dart';
import '../../widgets/outcome_card.dart';
import '../../widgets/preset_filter_chips.dart';
import 'outcome_detail_screen.dart';

class OutcomesScreen extends StatefulWidget {
  const OutcomesScreen({super.key});

  @override
  State<OutcomesScreen> createState() => _OutcomesScreenState();
}

class _OutcomesScreenState extends State<OutcomesScreen> {
  String? _selectedPresetId;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = const Color(0xFF000000);
    final surfaceColor = const Color(0xFF1A1A1A);
    final textColor = Colors.white;
    final secondaryTextColor = const Color(0xFF94A3B8);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.dashboard,
                        color: textColor,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Outcomes',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your AI-generated content, organized',
                    style: TextStyle(
                      fontSize: 14,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Preset Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: PresetFilterChips(
                selectedPresetId: _selectedPresetId,
                onPresetSelected: (presetId) {
                  setState(() {
                    _selectedPresetId = presetId;
                  });
                },
              ),
            ),

            const SizedBox(height: 24),

            // Outcome Groups
            Expanded(
              child: Consumer<AppStateProvider>(
                builder: (context, appState, _) {
                  final recordings = appState.outcomesItems;

                  if (recordings.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.dashboard_outlined,
                            size: 64,
                            color: secondaryTextColor.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No recordings yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: secondaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap Record to create your first one',
                            style: TextStyle(
                              fontSize: 14,
                              color: secondaryTextColor.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Filter recordings based on preset only
                  var filteredRecordings = recordings;
                  
                  // Apply preset filter
                  if (_selectedPresetId != null) {
                    filteredRecordings = filteredRecordings.where((r) {
                      return r.presetId == _selectedPresetId;
                    }).toList();
                  }

                  // Group recordings by outcome
                  final outcomeGroups = <OutcomeType, List<RecordingItem>>{};
                  for (final outcome in OutcomeType.values) {
                    outcomeGroups[outcome] = [];
                  }

                  for (final recording in filteredRecordings) {
                    for (final outcomeStr in recording.outcomes) {
                      final outcome = OutcomeTypeExtension.fromString(outcomeStr);
                      outcomeGroups[outcome]!.add(recording);
                    }
                  }

                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      // Messages
                      _buildOutcomeSection(
                        context,
                        OutcomeType.message,
                        outcomeGroups[OutcomeType.message]!,
                        textColor,
                        secondaryTextColor,
                      ),
                      const SizedBox(height: 16),

                      // Content
                      _buildOutcomeSection(
                        context,
                        OutcomeType.content,
                        outcomeGroups[OutcomeType.content]!,
                        textColor,
                        secondaryTextColor,
                      ),
                      const SizedBox(height: 16),

                      // Tasks
                      _buildOutcomeSection(
                        context,
                        OutcomeType.task,
                        outcomeGroups[OutcomeType.task]!,
                        textColor,
                        secondaryTextColor,
                      ),
                      const SizedBox(height: 16),

                      // Ideas
                      _buildOutcomeSection(
                        context,
                        OutcomeType.idea,
                        outcomeGroups[OutcomeType.idea]!,
                        textColor,
                        secondaryTextColor,
                      ),
                      const SizedBox(height: 16),

                      // Notes
                      _buildOutcomeSection(
                        context,
                        OutcomeType.note,
                        outcomeGroups[OutcomeType.note]!,
                        textColor,
                        secondaryTextColor,
                      ),
                      const SizedBox(height: 32),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutcomeSection(
    BuildContext context,
    OutcomeType outcome,
    List<RecordingItem> items,
    Color textColor,
    Color secondaryTextColor,
  ) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return OutcomeCard(
      outcomeType: outcome,
      itemCount: items.length,
      items: items.take(3).toList(), // Show preview of 3 items
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OutcomeDetailScreen(
              outcomeType: outcome,
              items: items,
            ),
          ),
        );
      },
    );
  }
}
