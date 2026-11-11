import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../l10n/app_localizations.dart';
import 'locale_controller.dart';
import 'models.dart';
import 'scan_quota.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  static const _hourKey = 'reminder_hour';
  static const _minuteKey = 'reminder_minute';
  static const _channelId = 'plant_reminders';
  static const _maxScheduled = 60;
  static const _followUpHour = 20;
  static const _scanQuotaNotifId = 0x7F00C001;

  AppLocalizations get _l10n {
    final code = LocaleController.instance.isTurkish ? 'tr' : 'en';
    return lookupAppLocalizations(Locale(code));
  }

  Future<void> init() async {
    if (_ready) return;

    tz_data.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      settings: const InitializationSettings(android: android, iOS: ios),
    );

    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              _channelId,
              'Plant reminders',
              description: 'Watering reminders for your plants',
              importance: Importance.high,
            ),
          );
    }

    _ready = true;
  }

  Future<bool> requestPermission() async {
    if (Platform.isIOS) {
      final result = await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return result ?? false;
    }
    if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final granted = await android?.requestNotificationsPermission();
      return granted ?? false;
    }
    return true;
  }

  Future<int> getReminderHour() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_hourKey) ?? 9;
  }

  Future<int> getReminderMinute() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_minuteKey) ?? 0;
  }

  Future<void> setReminderTime({required int hour, required int minute}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_hourKey, hour);
    await prefs.setInt(_minuteKey, minute);
  }

  /// Shows the daily scan-limit notice at most once for the lifetime of the app.
  Future<void> showScanQuotaLimitOnce() async {
    if (!_ready) await init();
    if (await ScanQuota.instance.hasShownLifetimeLimitNotification()) return;

    await ScanQuota.instance.markLifetimeLimitNotificationShown();

    final l10n = _l10n;
    await _plugin.show(
      id: _scanQuotaNotifId,
      title: l10n.scanQuotaLimitTitle,
      body: l10n.scanQuotaLimitBody(ScanQuota.dailyLimit),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'Plant reminders',
          channelDescription: 'Watering reminders for your plants',
          importance: Importance.high,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(
            l10n.scanQuotaLimitBody(ScanQuota.dailyLimit),
          ),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  int _primaryId(String plantId) => plantId.hashCode & 0x7fffffff;

  int _followUpId(String plantId) =>
      (plantId.hashCode ^ 0x00ABCDEF) & 0x7fffffff;

  Future<void> rescheduleAll(List<UserPlant> plants) async {
    if (!_ready) await init();
    await _plugin.cancelAll();

    final hour = await getReminderHour();
    final minute = await getReminderMinute();
    final l10n = _l10n;

    final upcoming = [...plants]
      ..sort((a, b) => a.nextWateringAt.compareTo(b.nextWateringAt));

    var scheduled = 0;
    for (final plant in upcoming) {
      if (scheduled >= _maxScheduled) break;

      final primary = _schedulePrimary(
        plant: plant,
        hour: hour,
        minute: minute,
      );
      if (primary != null) {
        await _scheduleOne(
          id: _primaryId(plant.id),
          when: primary,
          title: l10n.wateringReminderTitle,
          body: l10n.wateringReminderBody(plant.nickname),
          payload: plant.id,
        );
        scheduled++;
      }

      if (scheduled >= _maxScheduled) break;

      final followUp = _scheduleFollowUp(
        plant: plant,
        primary: primary,
        hour: hour,
        minute: minute,
      );
      if (followUp != null) {
        await _scheduleOne(
          id: _followUpId(plant.id),
          when: followUp,
          title: l10n.followUpReminderTitle,
          body: l10n.followUpReminderBody(plant.nickname),
          payload: 'followup:${plant.id}',
        );
        scheduled++;
      }
    }

    if (kDebugMode) {
      debugPrint('Scheduled $scheduled watering reminders');
    }
  }

  Future<void> _scheduleOne({
    required int id,
    required tz.TZDateTime when,
    required String title,
    required String body,
    required String payload,
  }) {
    return _plugin.zonedSchedule(
      id: id,
      scheduledDate: when,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'Plant reminders',
          channelDescription: 'Watering reminders for your plants',
          importance: Importance.high,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(body),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: payload,
    );
  }

  tz.TZDateTime? _schedulePrimary({
    required UserPlant plant,
    required int hour,
    required int minute,
  }) {
    final now = tz.TZDateTime.now(tz.local);
    final nextDay = plant.nextWateringAt;
    var candidate = tz.TZDateTime(
      tz.local,
      nextDay.year,
      nextDay.month,
      nextDay.day,
      hour,
      minute,
    );

    if (candidate.isAfter(now)) return candidate;

    // Watering day already started / overdue and preferred time passed.
    if (plant.needsWaterToday || plant.isOverdue) {
      // Primary already missed today — only the gentle follow-up will fire.
      return null;
    }

    final tomorrow = now.add(const Duration(days: 1));
    candidate = tz.TZDateTime(
      tz.local,
      tomorrow.year,
      tomorrow.month,
      tomorrow.day,
      hour,
      minute,
    );
    return candidate.isAfter(now) ? candidate : null;
  }

  /// One gentle same-day follow-up when watering is due and not done.
  tz.TZDateTime? _scheduleFollowUp({
    required UserPlant plant,
    required tz.TZDateTime? primary,
    required int hour,
    required int minute,
  }) {
    final now = tz.TZDateTime.now(tz.local);

    // Case A: primary is still later today → follow up +4h (same day only).
    if (primary != null &&
        primary.year == now.year &&
        primary.month == now.month &&
        primary.day == now.day) {
      final plusFour = primary.add(const Duration(hours: 4));
      if (plusFour.day == primary.day && plusFour.isAfter(now)) {
        return plusFour;
      }
      final evening = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        _followUpHour,
      );
      if (evening.isAfter(primary) && evening.isAfter(now)) return evening;
      return null;
    }

    // Case B: already due/overdue (missed primary or past due).
    if (!(plant.needsWaterToday || plant.isOverdue)) return null;

    final evening = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      _followUpHour,
    );
    if (evening.isAfter(now)) return evening;

    // After 20:00, one last soft nudge in 45 minutes (still today).
    final lateNudge = now.add(const Duration(minutes: 45));
    if (lateNudge.day == now.day) return lateNudge;
    return null;
  }
}
