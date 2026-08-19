import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_locales.dart';

/// Persists the user's selected application locale.
abstract interface class LocaleStorage {
  Future<Locale?> readLocale();

  Future<void> saveLocale(Locale locale);

  Future<void> clearLocale();
}

@LazySingleton(as: LocaleStorage)
class PreferencesLocaleStorage implements LocaleStorage {
  PreferencesLocaleStorage(this._prefs);

  final SharedPreferences _prefs;

  static const String localeKey = 'app_locale';

  @override
  Future<Locale?> readLocale() async {
    return AppLocales.fromLanguageCode(_prefs.getString(localeKey));
  }

  @override
  Future<void> saveLocale(Locale locale) {
    return _prefs.setString(localeKey, locale.languageCode);
  }

  @override
  Future<void> clearLocale() {
    return _prefs.remove(localeKey);
  }
}
