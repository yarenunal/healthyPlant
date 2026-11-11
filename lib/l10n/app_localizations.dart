import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Healthy Plant'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navMyPlants.
  ///
  /// In en, this message translates to:
  /// **'My Plants'**
  String get navMyPlants;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Care for your\nplants easily'**
  String get onboardingTitle;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Identify plants, track watering,\nand get reminders when they need care.'**
  String get onboardingSubtitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait…'**
  String get pleaseWait;

  /// No description provided for @continueWithoutReminders.
  ///
  /// In en, this message translates to:
  /// **'Continue without reminders'**
  String get continueWithoutReminders;

  /// No description provided for @onboardingPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'No account needed. Your data stays on this device.'**
  String get onboardingPrivacyNote;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Your plants'**
  String get homeTitle;

  /// No description provided for @homeAllFine.
  ///
  /// In en, this message translates to:
  /// **'All plants look fine today'**
  String get homeAllFine;

  /// No description provided for @homeNeedsWater.
  ///
  /// In en, this message translates to:
  /// **'{count} plant needs watering'**
  String homeNeedsWater(int count);

  /// No description provided for @homeNeedsWaterPlural.
  ///
  /// In en, this message translates to:
  /// **'{count} plants need watering'**
  String homeNeedsWaterPlural(int count);

  /// No description provided for @enableRemindersPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enable watering reminders?'**
  String get enableRemindersPrompt;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @remindersEnabledSnack.
  ///
  /// In en, this message translates to:
  /// **'Reminders enabled · around {time}'**
  String remindersEnabledSnack(String time);

  /// No description provided for @remindersPermissionSnack.
  ///
  /// In en, this message translates to:
  /// **'Notification permission needed in Settings'**
  String get remindersPermissionSnack;

  /// No description provided for @scanPlantCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan a plant'**
  String get scanPlantCardTitle;

  /// No description provided for @scanPlantCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Take a photo, see care tips,\nand add it to My Plants'**
  String get scanPlantCardSubtitle;

  /// No description provided for @quickCareGuide.
  ///
  /// In en, this message translates to:
  /// **'Quick care guide'**
  String get quickCareGuide;

  /// No description provided for @everyNDays.
  ///
  /// In en, this message translates to:
  /// **'Every {days} days'**
  String everyNDays(int days);

  /// No description provided for @myPlantsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Plants'**
  String get myPlantsTitle;

  /// No description provided for @myPlantsEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Add your first plant to get started'**
  String get myPlantsEmptyHint;

  /// No description provided for @plantsSaved.
  ///
  /// In en, this message translates to:
  /// **'{count} plant saved'**
  String plantsSaved(int count);

  /// No description provided for @plantsSavedPlural.
  ///
  /// In en, this message translates to:
  /// **'{count} plants saved'**
  String plantsSavedPlural(int count);

  /// No description provided for @noPlantsYet.
  ///
  /// In en, this message translates to:
  /// **'No plants yet.\nTap the camera to add one.'**
  String get noPlantsYet;

  /// No description provided for @needsWater.
  ///
  /// In en, this message translates to:
  /// **'Needs water'**
  String get needsWater;

  /// No description provided for @waterToday.
  ///
  /// In en, this message translates to:
  /// **'Water today'**
  String get waterToday;

  /// No description provided for @nextWaterInDays.
  ///
  /// In en, this message translates to:
  /// **'Next water in {days}d'**
  String nextWaterInDays(int days);

  /// No description provided for @waterNow.
  ///
  /// In en, this message translates to:
  /// **'Water now'**
  String get waterNow;

  /// No description provided for @iWateredIt.
  ///
  /// In en, this message translates to:
  /// **'I watered it'**
  String get iWateredIt;

  /// No description provided for @wateredLabel.
  ///
  /// In en, this message translates to:
  /// **'Watered'**
  String get wateredLabel;

  /// No description provided for @scanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan plant'**
  String get scanTitle;

  /// No description provided for @scanFrameHint.
  ///
  /// In en, this message translates to:
  /// **'Center the plant\nin the frame'**
  String get scanFrameHint;

  /// No description provided for @identifying.
  ///
  /// In en, this message translates to:
  /// **'Identifying…'**
  String get identifying;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @possibleMatch.
  ///
  /// In en, this message translates to:
  /// **'Possible match'**
  String get possibleMatch;

  /// No description provided for @wrongPlantSearch.
  ///
  /// In en, this message translates to:
  /// **'Wrong plant? Search to correct'**
  String get wrongPlantSearch;

  /// No description provided for @plantNickname.
  ///
  /// In en, this message translates to:
  /// **'Plant nickname'**
  String get plantNickname;

  /// No description provided for @addToMyPlants.
  ///
  /// In en, this message translates to:
  /// **'Add to My Plants'**
  String get addToMyPlants;

  /// No description provided for @retake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get retake;

  /// No description provided for @plantAddedSnack.
  ///
  /// In en, this message translates to:
  /// **'{name} added to My Plants'**
  String plantAddedSnack(String name);

  /// No description provided for @wateringReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Watering reminder'**
  String get wateringReminderTitle;

  /// No description provided for @wateringReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Time to water {name}'**
  String wateringReminderBody(String name);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'Phone language'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageTurkish.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get languageTurkish;

  /// No description provided for @careWaterLight.
  ///
  /// In en, this message translates to:
  /// **'💧 Every {days} days · ☀️ {light}'**
  String careWaterLight(int days, String light);

  /// No description provided for @reminderTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder time'**
  String get reminderTimeTitle;

  /// No description provided for @reminderTimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Watering reminders around {time}'**
  String reminderTimeSubtitle(String time);

  /// No description provided for @reminderTimeSaved.
  ///
  /// In en, this message translates to:
  /// **'Reminder time set to {time}'**
  String reminderTimeSaved(String time);

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @changeTime.
  ///
  /// In en, this message translates to:
  /// **'Change time'**
  String get changeTime;

  /// No description provided for @overdueSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'{count} plant is overdue'**
  String overdueSummaryTitle(int count);

  /// No description provided for @overdueSummaryTitlePlural.
  ///
  /// In en, this message translates to:
  /// **'{count} plants are overdue'**
  String overdueSummaryTitlePlural(int count);

  /// No description provided for @overdueSummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'They still need watering. Open My Plants to catch up.'**
  String get overdueSummarySubtitle;

  /// No description provided for @viewOverdue.
  ///
  /// In en, this message translates to:
  /// **'View plants'**
  String get viewOverdue;

  /// No description provided for @overdueBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Some plants need water'**
  String get overdueBannerTitle;

  /// No description provided for @overdueBannerBody.
  ///
  /// In en, this message translates to:
  /// **'{names} still need watering.'**
  String overdueBannerBody(String names);

  /// No description provided for @overdueBannerLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get overdueBannerLater;

  /// No description provided for @overdueBannerOpen.
  ///
  /// In en, this message translates to:
  /// **'Open My Plants'**
  String get overdueBannerOpen;

  /// No description provided for @followUpReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Gentle reminder'**
  String get followUpReminderTitle;

  /// No description provided for @followUpReminderBody.
  ///
  /// In en, this message translates to:
  /// **'{name} still hasn\'t been watered today'**
  String followUpReminderBody(String name);

  /// No description provided for @scanQuotaLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily scan limit'**
  String get scanQuotaLimitTitle;

  /// No description provided for @scanQuotaLimitBody.
  ///
  /// In en, this message translates to:
  /// **'You can scan up to {count} plants per day. Try again tomorrow.'**
  String scanQuotaLimitBody(int count);

  /// No description provided for @scanQuotaReachedSnack.
  ///
  /// In en, this message translates to:
  /// **'Daily scan limit reached ({count}/day). Try again tomorrow.'**
  String scanQuotaReachedSnack(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
