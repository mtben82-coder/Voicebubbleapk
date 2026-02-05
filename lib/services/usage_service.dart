import 'package:hive_flutter/hive_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Tracks STT and AI usage for free/pro limits
/// FREE: 5 minutes (300 seconds) + 1 minute bonus for review
/// PRO: 90 minutes (5400 seconds)
class UsageService {
  static const String _boxName = 'usage_data';
  static const int freeSecondsLimit = 300;      // 5 minutes
  static const int proSecondsLimit = 5400;      // 90 minutes
  static const int reviewBonusSeconds = 60;     // 1 minute bonus for review

  // Singleton
  static final UsageService _instance = UsageService._internal();
  factory UsageService() => _instance;
  UsageService._internal();

  /// Get total seconds used this month
  Future<int> getSecondsUsed() async {
    final box = await Hive.openBox(_boxName);
    final monthKey = _getCurrentMonthKey();
    return box.get('stt_seconds_$monthKey', defaultValue: 0);
  }

  /// Add seconds to usage (call after recording/export)
  Future<void> addUsage(int seconds) async {
    final box = await Hive.openBox(_boxName);
    final monthKey = _getCurrentMonthKey();
    final current = box.get('stt_seconds_$monthKey', defaultValue: 0);
    final newTotal = current + seconds;
    await box.put('stt_seconds_$monthKey', newTotal);
    // Sync to Firestore so it persists across reinstalls
    await _syncUsageToFirestore(newTotal);
  }

  /// Check if user can use STT/AI
  Future<bool> canUseSTT({required bool isPro}) async {
    final used = await getSecondsUsed();
    final limit = await getTotalLimit(isPro: isPro);
    return used < limit;
  }

  /// Get remaining seconds
  Future<int> getRemainingSeconds({required bool isPro}) async {
    final used = await getSecondsUsed();
    final limit = await getTotalLimit(isPro: isPro);
    return (limit - used).clamp(0, limit);
  }

  /// Get total limit including review bonus
  Future<int> getTotalLimit({required bool isPro}) async {
    if (isPro) return proSecondsLimit;

    final hasReviewBonus = await hasClaimedReviewBonus();
    return freeSecondsLimit + (hasReviewBonus ? reviewBonusSeconds : 0);
  }

  /// Check if user has claimed review bonus
  Future<bool> hasClaimedReviewBonus() async {
    final box = await Hive.openBox(_boxName);
    return box.get('review_bonus_claimed', defaultValue: false);
  }

  /// Claim review bonus (only works once, only for free users)
  Future<bool> claimReviewBonus() async {
    final box = await Hive.openBox(_boxName);
    final alreadyClaimed = box.get('review_bonus_claimed', defaultValue: false);

    if (alreadyClaimed) return false;

    await box.put('review_bonus_claimed', true);
    await box.put('review_bonus_claimed_at', DateTime.now().toIso8601String());
    // Sync to Firestore so it can't be reclaimed after reinstall
    await _syncReviewBonusToFirestore(true);
    return true;
  }

  /// Check if user has exhausted free limit (to show review prompt)
  Future<bool> shouldShowReviewPrompt({required bool isPro}) async {
    if (isPro) return false;

    final hasBonus = await hasClaimedReviewBonus();
    if (hasBonus) return false; // Already claimed

    final used = await getSecondsUsed();
    return used >= freeSecondsLimit; // Show when 5 min exhausted
  }

  /// Format seconds to MM:SS display
  String formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  /// Format for display like "4:30 / 5:00"
  Future<String> getUsageDisplayString({required bool isPro}) async {
    final used = await getSecondsUsed();
    final limit = await getTotalLimit(isPro: isPro);
    return '${formatTime(used)} / ${formatTime(limit)}';
  }

  /// Get percentage used (0.0 to 1.0)
  Future<double> getUsagePercentage({required bool isPro}) async {
    final used = await getSecondsUsed();
    final limit = await getTotalLimit(isPro: isPro);
    return (used / limit).clamp(0.0, 1.0);
  }

  /// Reset usage (for testing or admin)
  Future<void> resetUsage() async {
    final box = await Hive.openBox(_boxName);
    final monthKey = _getCurrentMonthKey();
    await box.put('stt_seconds_$monthKey', 0);
  }

  /// Reset review bonus (for testing)
  Future<void> resetReviewBonus() async {
    final box = await Hive.openBox(_boxName);
    await box.put('review_bonus_claimed', false);
    await box.delete('review_bonus_claimed_at');
  }

  String _getCurrentMonthKey() {
    final now = DateTime.now();
    return '${now.year}_${now.month}';
  }

  /// Get the current user's UID, or null if not logged in
  String? _getUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  /// Get the Firestore document reference for this user's usage
  DocumentReference? _getUserUsageDoc() {
    final uid = _getUserId();
    if (uid == null) return null;
    return FirebaseFirestore.instance.collection('users').doc(uid);
  }

  /// Sync local usage TO Firestore (call after addUsage)
  Future<void> _syncUsageToFirestore(int totalSeconds) async {
    final doc = _getUserUsageDoc();
    if (doc == null) return; // Not logged in, local only

    final monthKey = _getCurrentMonthKey();
    try {
      await doc.set({
        'usage': {
          'stt_seconds_$monthKey': totalSeconds,
          'lastUpdated': FieldValue.serverTimestamp(),
        },
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('⚠️ Failed to sync usage to Firestore: $e');
      // Non-fatal — local cache still works
    }
  }

  /// Sync review bonus TO Firestore
  Future<void> _syncReviewBonusToFirestore(bool claimed) async {
    final doc = _getUserUsageDoc();
    if (doc == null) return;

    try {
      await doc.set({
        'usage': {
          'review_bonus_claimed': claimed,
          'review_bonus_claimed_at': claimed ? FieldValue.serverTimestamp() : null,
        },
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('⚠️ Failed to sync review bonus to Firestore: $e');
    }
  }

  /// Load usage FROM Firestore into local Hive (call on app start)
  /// This prevents abuse: if Firestore says 300 seconds used, local can't say 0
  Future<void> syncFromFirestore() async {
    final doc = _getUserUsageDoc();
    if (doc == null) return;

    try {
      final snapshot = await doc.get();
      if (!snapshot.exists) return;

      final data = snapshot.data() as Map<String, dynamic>?;
      if (data == null || data['usage'] == null) return;

      final usage = data['usage'] as Map<String, dynamic>;
      final box = await Hive.openBox(_boxName);
      final monthKey = _getCurrentMonthKey();

      // Sync seconds used — take the HIGHER value (prevent downgrade abuse)
      final firestoreSeconds = usage['stt_seconds_$monthKey'] as int? ?? 0;
      final localSeconds = box.get('stt_seconds_$monthKey', defaultValue: 0) as int;
      final trueSeconds = firestoreSeconds > localSeconds ? firestoreSeconds : localSeconds;
      await box.put('stt_seconds_$monthKey', trueSeconds);

      // If Firestore is behind, push local up
      if (localSeconds > firestoreSeconds) {
        await _syncUsageToFirestore(localSeconds);
      }

      // Sync review bonus — if EVER claimed on server, it stays claimed
      final firestoreBonusClaimed = usage['review_bonus_claimed'] as bool? ?? false;
      if (firestoreBonusClaimed) {
        await box.put('review_bonus_claimed', true);
      } else {
        // If local says claimed but server doesn't, push to server
        final localBonusClaimed = box.get('review_bonus_claimed', defaultValue: false) as bool;
        if (localBonusClaimed) {
          await _syncReviewBonusToFirestore(true);
        }
      }

      debugPrint('✅ Usage synced from Firestore: ${trueSeconds}s used, bonus=$firestoreBonusClaimed');
    } catch (e) {
      debugPrint('⚠️ Failed to sync usage from Firestore: $e');
      // Non-fatal — use local cache
    }
  }
}
