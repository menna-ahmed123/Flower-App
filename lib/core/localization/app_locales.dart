import 'package:flutter/material.dart';

/// Single source of truth for application locales.
abstract final class AppLocales {
  static const Locale en = Locale('en');
  static const Locale ar = Locale('ar');

  /// Default locale while the product UI is English-only.
  static const Locale defaultLocale = en;

  static const List<Locale> supportedLocales = <Locale>[en, ar];

  static bool isSupported(Locale locale) {
    return supportedLocales.any(
      (supported) => supported.languageCode == locale.languageCode,
    );
  }

  static bool isRtl(Locale locale) => locale.languageCode == ar.languageCode;

  /// Returns a supported [Locale] for [languageCode], or `null` if unsupported.
  static Locale? fromLanguageCode(String? languageCode) {
    if (languageCode == null || languageCode.isEmpty) {
      return null;
    }
    return switch (languageCode) {
      'en' => en,
      'ar' => ar,
      _ => null,
    };
  }

  /// Resolution order:
  /// 1. Explicit/saved locale (if supported)
  /// 2. [defaultLocale] (English)
  ///
  /// Device locale is not used. The visible UI is currently English-only;
  /// following an Arabic device locale would flip the whole app to RTL.
  static Locale resolve({required Locale? savedLocale}) {
    return fromLanguageCode(savedLocale?.languageCode) ?? defaultLocale;
  }

  /// Honors [MaterialApp.locale] when it is a supported language, otherwise
  /// falls back to English. Does not follow the device language.
  static Locale localeResolutionCallback(
    Locale? requestedLocale,
    Iterable<Locale> supportedLocales,
  ) {
    return resolve(savedLocale: requestedLocale);
  }
}
