import 'package:flutter/material.dart';

/// Single source of truth for application locales.
abstract final class AppLocales {
  static const Locale en = Locale('en');
  static const Locale ar = Locale('ar');

  /// Default locale when no saved preference and device locale is unsupported.
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
  /// 1. Saved user preference (if supported)
  /// 2. Device locale (if supported)
  /// 3. [defaultLocale]
  static Locale resolve({
    required Locale? savedLocale,
    required Locale? deviceLocale,
  }) {
    final preferred = fromLanguageCode(savedLocale?.languageCode);
    if (preferred != null) {
      return preferred;
    }

    final device = fromLanguageCode(deviceLocale?.languageCode);
    if (device != null) {
      return device;
    }

    return defaultLocale;
  }

  /// Used by [MaterialApp.localeResolutionCallback] when no explicit locale
  /// is set (follow device → fallback to default).
  static Locale localeResolutionCallback(
    Locale? deviceLocale,
    Iterable<Locale> supportedLocales,
  ) {
    return resolve(savedLocale: null, deviceLocale: deviceLocale);
  }
}
