// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Healthy Plant';

  @override
  String get navHome => 'Home';

  @override
  String get navMyPlants => 'My Plants';

  @override
  String get onboardingTitle => 'Care for your\nplants easily';

  @override
  String get onboardingSubtitle =>
      'Identify plants, track watering,\nand get reminders when they need care.';

  @override
  String get getStarted => 'Get started';

  @override
  String get pleaseWait => 'Please wait…';

  @override
  String get continueWithoutReminders => 'Continue without reminders';

  @override
  String get onboardingPrivacyNote =>
      'No account needed. Your data stays on this device.';

  @override
  String get homeTitle => 'Your plants';

  @override
  String get homeAllFine => 'All plants look fine today';

  @override
  String homeNeedsWater(int count) {
    return '$count plant needs watering';
  }

  @override
  String homeNeedsWaterPlural(int count) {
    return '$count plants need watering';
  }

  @override
  String get enableRemindersPrompt => 'Enable watering reminders?';

  @override
  String get enable => 'Enable';

  @override
  String remindersEnabledSnack(String time) {
    return 'Reminders enabled · around $time';
  }

  @override
  String get remindersPermissionSnack =>
      'Notification permission needed in Settings';

  @override
  String get scanPlantCardTitle => 'Scan a plant';

  @override
  String get scanPlantCardSubtitle =>
      'Take a photo, see care tips,\nand add it to My Plants';

  @override
  String get quickCareGuide => 'Quick care guide';

  @override
  String everyNDays(int days) {
    return 'Every $days days';
  }

  @override
  String get myPlantsTitle => 'My Plants';

  @override
  String get myPlantsEmptyHint => 'Add your first plant to get started';

  @override
  String plantsSaved(int count) {
    return '$count plant saved';
  }

  @override
  String plantsSavedPlural(int count) {
    return '$count plants saved';
  }

  @override
  String get noPlantsYet => 'No plants yet.\nTap the camera to add one.';

  @override
  String get needsWater => 'Needs water';

  @override
  String get waterToday => 'Water today';

  @override
  String nextWaterInDays(int days) {
    return 'Next water in ${days}d';
  }

  @override
  String get waterNow => 'Water now';

  @override
  String get iWateredIt => 'I watered it';

  @override
  String get wateredLabel => 'Watered';

  @override
  String get scanTitle => 'Scan plant';

  @override
  String get scanFrameHint => 'Center the plant\nin the frame';

  @override
  String get identifying => 'Identifying…';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get possibleMatch => 'Possible match';

  @override
  String get wrongPlantSearch => 'Wrong plant? Search to correct';

  @override
  String get plantNickname => 'Plant nickname';

  @override
  String get addToMyPlants => 'Add to My Plants';

  @override
  String get retake => 'Retake';

  @override
  String plantAddedSnack(String name) {
    return '$name added to My Plants';
  }

  @override
  String get wateringReminderTitle => 'Watering reminder';

  @override
  String wateringReminderBody(String name) {
    return 'Time to water $name';
  }

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'Phone language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String careWaterLight(int days, String light) {
    return '💧 Every $days days · ☀️ $light';
  }

  @override
  String get reminderTimeTitle => 'Reminder time';

  @override
  String reminderTimeSubtitle(String time) {
    return 'Watering reminders around $time';
  }

  @override
  String reminderTimeSaved(String time) {
    return 'Reminder time set to $time';
  }

  @override
  String get settings => 'Settings';

  @override
  String get changeTime => 'Change time';

  @override
  String overdueSummaryTitle(int count) {
    return '$count plant is overdue';
  }

  @override
  String overdueSummaryTitlePlural(int count) {
    return '$count plants are overdue';
  }

  @override
  String get overdueSummarySubtitle =>
      'They still need watering. Open My Plants to catch up.';

  @override
  String get viewOverdue => 'View plants';

  @override
  String get overdueBannerTitle => 'Some plants need water';

  @override
  String overdueBannerBody(String names) {
    return '$names still need watering.';
  }

  @override
  String get overdueBannerLater => 'Later';

  @override
  String get overdueBannerOpen => 'Open My Plants';

  @override
  String get followUpReminderTitle => 'Gentle reminder';

  @override
  String followUpReminderBody(String name) {
    return '$name still hasn\'t been watered today';
  }

  @override
  String get scanQuotaLimitTitle => 'Daily scan limit';

  @override
  String scanQuotaLimitBody(int count) {
    return 'You can scan up to $count plants per day. Try again tomorrow.';
  }

  @override
  String scanQuotaReachedSnack(int count) {
    return 'Daily scan limit reached ($count/day). Try again tomorrow.';
  }
}
