import 'package:shared_preferences/shared_preferences.dart';

/// Local daily scan/identify quota.
///
/// Counts identification attempts (not plant adds). Deleting plants does not
/// restore quota. Resets at local midnight.
class ScanQuota {
  ScanQuota._();
  static final ScanQuota instance = ScanQuota._();

  static const dailyLimit = 5;
  static const _countKey = 'scan_quota_count';
  static const _dateKey = 'scan_quota_date';
  static const lifetimeNotifKey = 'scan_quota_lifetime_notif_shown';

  String _todayKey([DateTime? now]) {
    final d = now ?? DateTime.now();
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  Future<void> _rollIfNeeded(SharedPreferences prefs) async {
    final today = _todayKey();
    final stored = prefs.getString(_dateKey);
    if (stored == today) return;
    await prefs.setString(_dateKey, today);
    await prefs.setInt(_countKey, 0);
  }

  Future<int> usedToday() async {
    final prefs = await SharedPreferences.getInstance();
    await _rollIfNeeded(prefs);
    return prefs.getInt(_countKey) ?? 0;
  }

  Future<int> remainingToday() async {
    final used = await usedToday();
    final left = dailyLimit - used;
    return left < 0 ? 0 : left;
  }

  Future<bool> canScan() async => (await remainingToday()) > 0;

  /// Consumes one scan slot. Returns false if already at the daily limit.
  Future<bool> tryConsume() async {
    final prefs = await SharedPreferences.getInstance();
    await _rollIfNeeded(prefs);
    final used = prefs.getInt(_countKey) ?? 0;
    if (used >= dailyLimit) return false;
    await prefs.setInt(_countKey, used + 1);
    return true;
  }

  Future<bool> hasShownLifetimeLimitNotification() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(lifetimeNotifKey) ?? false;
  }

  Future<void> markLifetimeLimitNotificationShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(lifetimeNotifKey, true);
  }
}
