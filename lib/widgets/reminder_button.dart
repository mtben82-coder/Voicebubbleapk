import 'package:flutter/material.dart';

class ReminderButton extends StatelessWidget {
  final DateTime? reminderDateTime;
  final VoidCallback onPressed;
  final bool compact;

  const ReminderButton({
    super.key,
    this.reminderDateTime,
    required this.onPressed,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasReminder = reminderDateTime != null;
    final isPast = hasReminder && reminderDateTime!.isBefore(DateTime.now());
    
    const primaryColor = Color(0xFF3B82F6);
    final activeColor = isPast ? Colors.orange : primaryColor;
    final dimColor = const Color(0xFF6B7280);

    if (compact) {
      return IconButton(
        onPressed: onPressed,
        icon: Icon(
          hasReminder ? Icons.notifications_active : Icons.notifications_outlined,
          color: hasReminder ? activeColor : dimColor,
          size: 20,
        ),
        tooltip: hasReminder ? _formatDateTime(reminderDateTime!) : 'Set reminder',
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      );
    }

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: hasReminder ? activeColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: hasReminder ? activeColor.withOpacity(0.3) : dimColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasReminder ? Icons.notifications_active : Icons.notifications_outlined,
              color: hasReminder ? activeColor : dimColor,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              hasReminder ? _formatShortDateTime(reminderDateTime!) : 'Remind me',
              style: TextStyle(
                color: hasReminder ? activeColor : dimColor,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
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

    return '$dateStr at ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _formatShortDateTime(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(dt.year, dt.month, dt.day);

    if (dateOnly == today) {
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } else if (dateOnly == tomorrow) {
      return 'Tomorrow';
    } else {
      return '${dt.day}/${dt.month}';
    }
  }
}
