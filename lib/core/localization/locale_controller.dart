import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'app_locales.dart';
import 'locale_storage.dart';

/// Holds and persists the active application locale.
///
/// - `locale == null` → English (current UI language)
/// - `locale != null` → force the saved/selected locale
///
/// Future Settings screens can call [changeLocale] / [useSystemLocale].
@lazySingleton
class LocaleController extends ChangeNotifier {
  LocaleController(this._storage);

  final LocaleStorage _storage;

  Locale? _locale;
  bool _isLoaded = false;

  /// Explicit override. `null` means use [AppLocales.defaultLocale] (English).
  Locale? get locale => _locale;

  /// Locale actually applied to [MaterialApp]. Never null.
  Locale get resolvedLocale => _locale ?? AppLocales.defaultLocale;

  bool get isLoaded => _isLoaded;

  bool get isRtl => AppLocales.isRtl(resolvedLocale);

  /// Loads any previously saved locale. Call once during app startup.
  Future<void> load() async {
    _locale = await _storage.readLocale();
    _isLoaded = true;
    notifyListeners();
  }

  /// Switches the app language without requiring a restart.
  Future<void> changeLocale(Locale locale) async {
    final resolved = AppLocales.fromLanguageCode(locale.languageCode);
    if (resolved == null) {
      return;
    }
    if (_locale?.languageCode == resolved.languageCode) {
      return;
    }

    _locale = resolved;
    await _storage.saveLocale(resolved);
    notifyListeners();
  }

  /// Clears the saved preference and returns to English.
  Future<void> useSystemLocale() async {
    if (_locale == null) {
      return;
    }
    _locale = null;
    await _storage.clearLocale();
    notifyListeners();
  }
}
