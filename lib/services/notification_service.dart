import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';

/// Result class for reminder operations
class ReminderResult {
  final bool success;
  final String? error;
  final int? notificationId;

  ReminderResult.success(this.notificationId) : success = true, error = null;
  ReminderResult.failure(this.error) : success = false, notificationId = null;
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  bool _permissionRequested = false;

  /// Initialize notification service - call once at app startup
  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone database with device's actual timezone
    tz.initializeTimeZones();
    try {
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      debugPrint('🕐 Timezone set to: $timeZoneName');
    } catch (e) {
      // Fallback to UTC if timezone detection fails
      debugPrint('⚠️ Timezone detection failed, using UTC: $e');
      tz.setLocalLocation(tz.UTC);
    }

    // Android initialization settings
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundNotificationTapped,
    );

    // Create notification channel
    await _createNotificationChannel();

    _initialized = true;
    debugPrint('✅ NotificationService initialized');
  }

  /// Create notification channel for Android 8+
  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'voicebubble_reminders',
      'Reminders',
      description: 'Reminders for your outcomes and tasks',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Request notification permission - call before first reminder or at onboarding
  Future<bool> requestPermission() async {
    if (_permissionRequested) {
      return await Permission.notification.isGranted;
    }

    final status = await Permission.notification.request();
    _permissionRequested = true;

    if (!status.isGranted) {
      debugPrint('❌ Notification permission denied');
      return false;
    }

    // Check exact alarm permission (Android 12+)
    final exactAlarmStatus = await Permission.scheduleExactAlarm.status;
    if (!exactAlarmStatus.isGranted) {
      debugPrint('⚠️ Exact alarm permission not granted, requesting...');
      await Permission.scheduleExactAlarm.request();
    }

    return true;
  }

  /// Check if we can schedule exact alarms
  Future<bool> canScheduleExactAlarms() async {
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidPlugin == null) return false;
    
    return await androidPlugin.canScheduleExactNotifications() ?? false;
  }

  /// Schedule a reminder for an outcome
  Future<ReminderResult> scheduleReminder({
    required String itemId,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    // Ensure initialized
    if (!_initialized) {
      await initialize();
    }

    // Validate scheduled time is in the future
    if (scheduledTime.isBefore(DateTime.now())) {
      return ReminderResult.failure('Cannot schedule reminder in the past');
    }

    // Check permission
    final hasPermission = await Permission.notification.isGranted;
    if (!hasPermission) {
      final granted = await requestPermission();
      if (!granted) {
        return ReminderResult.failure('Notification permission denied');
      }
    }

    // Generate unique notification ID from itemId
    final int notificationId = _generateNotificationId(itemId);

    // Cancel any existing reminder for this item first
    await _notifications.cancel(notificationId);

    // Android notification details
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'voicebubble_reminders',
      'Reminders',
      channelDescription: 'Reminders for your outcomes and tasks',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'VoiceBubble Reminder',
      icon: '@mipmap/ic_launcher',
      enableVibration: true,
      playSound: true,
      styleInformation: BigTextStyleInformation(''), // Allows expanded text
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    // Convert DateTime to TZDateTime
    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(scheduledTime, tz.local);

    // Truncate body to reasonable length for notification
    final truncatedBody = body.length > 200 ? '${body.substring(0, 197)}...' : body;

    try {
      // Check if we can schedule exact alarms
      final canScheduleExact = await canScheduleExactAlarms();
      
      await _notifications.zonedSchedule(
        notificationId,
        title,
        truncatedBody,
        scheduledDate,
        notificationDetails,
        androidScheduleMode: canScheduleExact 
            ? AndroidScheduleMode.exactAllowWhileIdle 
            : AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: itemId, // CRITICAL: Pass itemId for tap handling
      );

      debugPrint('🔔 Scheduled reminder for $scheduledTime (ID: $notificationId, exact: $canScheduleExact)');
      return ReminderResult.success(notificationId);
    } catch (e) {
      debugPrint('❌ Failed to schedule reminder: $e');
      return ReminderResult.failure('Failed to schedule reminder: $e');
    }
  }

  /// Cancel a reminder by item ID
  Future<void> cancelReminderByItemId(String itemId) async {
    final int notificationId = _generateNotificationId(itemId);
    await cancelReminderByNotificationId(notificationId);
  }

  /// Cancel a reminder by notification ID
  Future<void> cancelReminderByNotificationId(int notificationId) async {
    await _notifications.cancel(notificationId);
    debugPrint('🔕 Cancelled reminder (ID: $notificationId)');
  }

  /// Cancel all reminders
  Future<void> cancelAllReminders() async {
    await _notifications.cancelAll();
    debugPrint('🔕 Cancelled all reminders');
  }

  /// Get all pending notifications (for debugging)
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  /// Check if a specific reminder is scheduled
  Future<bool> isReminderScheduled(String itemId) async {
    final int notificationId = _generateNotificationId(itemId);
    final pending = await getPendingNotifications();
    return pending.any((n) => n.id == notificationId);
  }

  /// Generate consistent notification ID from item ID
  int _generateNotificationId(String itemId) {
    // Use hashCode but ensure it's positive and within int32 range
    return itemId.hashCode.abs() % 2147483647;
  }

  /// Handle notification tap when app is in foreground/background
  static void _onNotificationTapped(NotificationResponse response) {
    debugPrint('📱 Notification tapped: ${response.payload}');
    _handleNotificationPayload(response.payload);
  }

  /// Handle notification tap when app was terminated
  @pragma('vm:entry-point')
  static void _onBackgroundNotificationTapped(NotificationResponse response) {
    debugPrint('📱 Background notification tapped: ${response.payload}');
    _handleNotificationPayload(response.payload);
  }

  static void _handleNotificationPayload(String? payload) {
    if (payload == null || payload.isEmpty) return;
    
    // Store the payload to be handled when app is ready
    _pendingNotificationPayload = payload;
  }

  // Static variable to store pending payload
  static String? _pendingNotificationPayload;

  /// Get and clear any pending notification payload (call on app start)
  static String? consumePendingPayload() {
    final payload = _pendingNotificationPayload;
    _pendingNotificationPayload = null;
    return payload;
  }
}
