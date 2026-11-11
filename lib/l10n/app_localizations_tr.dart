// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Healthy Plant';

  @override
  String get navHome => 'Ana Sayfa';

  @override
  String get navMyPlants => 'Bitkilerim';

  @override
  String get onboardingTitle => 'Bitkilerine\nkolayca bak';

  @override
  String get onboardingSubtitle =>
      'Bitki tanı, sulamayı takip et\nve zamanı gelince hatırlatma al.';

  @override
  String get getStarted => 'Başla';

  @override
  String get pleaseWait => 'Lütfen bekle…';

  @override
  String get continueWithoutReminders => 'Hatırlatmasız devam et';

  @override
  String get onboardingPrivacyNote =>
      'Hesap gerekmez. Verilerin bu cihazda kalır.';

  @override
  String get homeTitle => 'Bitkilerin';

  @override
  String get homeAllFine => 'Bugün her şey yolunda';

  @override
  String homeNeedsWater(int count) {
    return '$count bitkinin sulanması gerekiyor';
  }

  @override
  String homeNeedsWaterPlural(int count) {
    return '$count bitkinin sulanması gerekiyor';
  }

  @override
  String get enableRemindersPrompt => 'Sulama hatırlatmalarını aç?';

  @override
  String get enable => 'Aç';

  @override
  String remindersEnabledSnack(String time) {
    return 'Hatırlatmalar açık · saat $time civarı';
  }

  @override
  String get remindersPermissionSnack => 'Ayarlar’dan bildirim izni gerekli';

  @override
  String get scanPlantCardTitle => 'Bitki tara';

  @override
  String get scanPlantCardSubtitle =>
      'Fotoğraf çek, bakım bilgisine bak\nve Bitkilerim’e ekle';

  @override
  String get quickCareGuide => 'Hızlı bakım rehberi';

  @override
  String everyNDays(int days) {
    return 'Her $days günde bir';
  }

  @override
  String get myPlantsTitle => 'Bitkilerim';

  @override
  String get myPlantsEmptyHint => 'Başlamak için ilk bitkini ekle';

  @override
  String plantsSaved(int count) {
    return '$count bitki kayıtlı';
  }

  @override
  String plantsSavedPlural(int count) {
    return '$count bitki kayıtlı';
  }

  @override
  String get noPlantsYet => 'Henüz bitki yok.\nEklemek için kameraya dokun.';

  @override
  String get needsWater => 'Su istiyor';

  @override
  String get waterToday => 'Bugün sula';

  @override
  String nextWaterInDays(int days) {
    return '$days gün sonra sulama';
  }

  @override
  String get waterNow => 'Şimdi sula';

  @override
  String get iWateredIt => 'Suladım';

  @override
  String get wateredLabel => 'Sulandı';

  @override
  String get scanTitle => 'Bitki tara';

  @override
  String get scanFrameHint => 'Bitkiyi\nçerçevenin ortasına al';

  @override
  String get identifying => 'Tanımlanıyor…';

  @override
  String get camera => 'Kamera';

  @override
  String get gallery => 'Galeri';

  @override
  String get possibleMatch => 'Olası eşleşme';

  @override
  String get wrongPlantSearch => 'Yanlış mı? Arayıp düzelt';

  @override
  String get plantNickname => 'Bitki takma adı';

  @override
  String get addToMyPlants => 'Bitkilerim’e ekle';

  @override
  String get retake => 'Yeniden çek';

  @override
  String plantAddedSnack(String name) {
    return '$name Bitkilerim’e eklendi';
  }

  @override
  String get wateringReminderTitle => 'Sulama hatırlatması';

  @override
  String wateringReminderBody(String name) {
    return '$name için sulama zamanı';
  }

  @override
  String get language => 'Dil';

  @override
  String get languageSystem => 'Telefon dili';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String careWaterLight(int days, String light) {
    return '💧 Her $days günde · ☀️ $light';
  }

  @override
  String get reminderTimeTitle => 'Hatırlatma saati';

  @override
  String reminderTimeSubtitle(String time) {
    return 'Sulama hatırlatmaları saat $time civarı';
  }

  @override
  String reminderTimeSaved(String time) {
    return 'Hatırlatma saati $time olarak ayarlandı';
  }

  @override
  String get settings => 'Ayarlar';

  @override
  String get changeTime => 'Saati değiştir';

  @override
  String overdueSummaryTitle(int count) {
    return '$count bitki gecikti';
  }

  @override
  String overdueSummaryTitlePlural(int count) {
    return '$count bitki gecikti';
  }

  @override
  String get overdueSummarySubtitle =>
      'Hâlâ sulanmayı bekliyor. Bitkilerim’den yetişebilirsin.';

  @override
  String get viewOverdue => 'Bitkilere bak';

  @override
  String get overdueBannerTitle => 'Bazı bitkiler su bekliyor';

  @override
  String overdueBannerBody(String names) {
    return '$names hâlâ sulanmayı bekliyor.';
  }

  @override
  String get overdueBannerLater => 'Sonra';

  @override
  String get overdueBannerOpen => 'Bitkilerim’e git';

  @override
  String get followUpReminderTitle => 'Nazik hatırlatma';

  @override
  String followUpReminderBody(String name) {
    return '$name bugün hâlâ sulanmadı';
  }

  @override
  String get scanQuotaLimitTitle => 'Günlük tarama limiti';

  @override
  String scanQuotaLimitBody(int count) {
    return 'Günde en fazla $count bitki tarayabilirsin. Yarın tekrar dene.';
  }

  @override
  String scanQuotaReachedSnack(int count) {
    return 'Günlük tarama limitine ulaşıldı ($count/gün). Yarın tekrar dene.';
  }
}
