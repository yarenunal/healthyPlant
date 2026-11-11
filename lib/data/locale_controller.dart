import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends ChangeNotifier {
  LocaleController._();
  static final LocaleController instance = LocaleController._();

  static const _key = 'app_locale';

  /// null = follow system
  Locale? _locale;

  Locale? get locale => _locale;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    if (code == null || code == 'system') {
      _locale = null;
    } else {
      _locale = Locale(code);
    }
    notifyListeners();
  }

  Future<void> setLocale(Locale? locale) async {
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.setString(_key, 'system');
      _locale = null;
    } else {
      await prefs.setString(_key, locale.languageCode);
      _locale = locale;
    }
    notifyListeners();
  }

  bool get isTurkish {
    if (_locale != null) return _locale!.languageCode == 'tr';
    final device = WidgetsBinding.instance.platformDispatcher.locale;
    return device.languageCode == 'tr';
  }
}
