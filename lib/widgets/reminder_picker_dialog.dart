import 'package:flutter/material.dart';

class ReminderPickerDialog extends StatefulWidget {
  final DateTime? initialDateTime;
  final Function(DateTime?) onReminderSet;

  const ReminderPickerDialog({
    super.key,
    this.initialDateTime,
    required this.onReminderSet,
  });

  /// Show the dialog and return the selected DateTime (or null if cancelled/removed)
  static Future<DateTime?> show(BuildContext context, {DateTime? initialDateTime}) async {
    DateTime? result = initialDateTime;
    
    await showDialog(
      context: context,
      builder: (context) => ReminderPickerDialog(
        initialDateTime: initialDateTime,
        onReminderSet: (dateTime) {
          result = dateTime;
        },
      ),
    );
    
    return result;
  }

  @override
  State<ReminderPickerDialog> createState() => _ReminderPickerDialogState();
}

class _ReminderPickerDialogState extends State<ReminderPickerDialog> {
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initialDateTime;
  }

  @override
  Widget build(BuildContext context) {
    const surfaceColor = Color(0xFF1A1A1A);
    const textColor = Colors.white;
    const primaryColor = Color(0xFF3B82F6);
    const dimTextColor = Color(0xFF9CA3AF);

    return Dialog(
      backgroundColor: surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  widget.initialDateTime != null 
                      ? Icons.notifications_active 
                      : Icons.notifications_outlined,
                  color: primaryColor,
                ),
                const SizedBox(width: 12),
                Text(
                  widget.initialDateTime != null ? 'Edit Reminder' : 'Set Reminder',
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Quick select buttons
            const Text(
              'Quick Select',
              style: TextStyle(color: dimTextColor, fontSize: 12),
            ),
            const SizedBox(height: 8),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildQuickButton('In 1 hour', const Duration(hours: 1)),
                _buildQuickButton('In 3 hours', const Duration(hours: 3)),
                _buildQuickButton('Tomorrow 9am', null, _getTomorrow9am()),
                _buildQuickButton('In 1 week', const Duration(days: 7)),
              ],
            ),

            const SizedBox(height: 20),

            // Current selection display
            if (_selectedDateTime != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: primaryColor.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.schedule, color: primaryColor, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _formatDateTime(_selectedDateTime!),
                        style: const TextStyle(color: textColor, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Custom date/time button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _pickCustomDateTime,
                icon: const Icon(Icons.calendar_today, color: primaryColor, size: 18),
                label: Text(
                  _selectedDateTime == null 
                      ? 'Pick Custom Date & Time' 
                      : 'Change Date & Time',
                  style: const TextStyle(color: textColor),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: primaryColor.withOpacity(0.5)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Actions
            Row(
              children: [
                // Remove button (only if editing existing)
                if (widget.initialDateTime != null)
                  TextButton(
                    onPressed: () {
                      widget.onReminderSet(null);
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.red[400]),
                    child: const Text('Remove'),
                  ),
                
                const Spacer(),
                
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(foregroundColor: dimTextColor),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _selectedDateTime == null
                      ? null
                      : () {
                          widget.onReminderSet(_selectedDateTime);
                          Navigator.pop(context);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: primaryColor.withOpacity(0.3),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Set Reminder'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickButton(String label, Duration? duration, [DateTime? specificTime]) {
    final targetTime = specificTime ?? DateTime.now().add(duration!);
    final isSelected = _selectedDateTime != null &&
        _selectedDateTime!.difference(targetTime).inMinutes.abs() < 2;

    return OutlinedButton(
      onPressed: () {
        setState(() {
          _selectedDateTime = specificTime ?? DateTime.now().add(duration!);
        });
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xFF3B82F6).withOpacity(0.2) : null,
        side: BorderSide(
          color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF3B82F6).withOpacity(0.3),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
          fontSize: 13,
        ),
      ),
    );
  }

  DateTime _getTomorrow9am() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + 1, 9, 0);
  }

  Future<void> _pickCustomDateTime() async {
    final now = DateTime.now();
    
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? now.add(const Duration(hours: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF3B82F6),
            surface: Color(0xFF1A1A1A),
          ),
        ),
        child: child!,
      ),
    );

    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? now.add(const Duration(hours: 1))),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF3B82F6),
            surface: Color(0xFF1A1A1A),
          ),
        ),
        child: child!,
      ),
    );

    if (time == null || !mounted) return;

    final selectedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    // Validate it's in the future
    if (selectedDateTime.isBefore(DateTime.now())) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a time in the future'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    setState(() {
      _selectedDateTime = selectedDateTime;
    });
  }

  String _formatDateTime(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(dt.year, dt.month, dt.day);

    String dateStr;
    if (dateOnly == today) {
      dateStr = 'Today';
    } else if (dateOnly == tomorrow) {
      dateStr = 'Tomorrow';
    } else {
      dateStr = '${dt.day}/${dt.month}/${dt.year}';
    }

    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');

    return '$dateStr at $hour:$minute';
  }
}
