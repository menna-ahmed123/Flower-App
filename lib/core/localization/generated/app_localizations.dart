import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// Generic save action label
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// Generic cancel action label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// Generic confirm action label
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// Generic close action label
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// Generic back/navigation action label
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// Generic next/navigation action label
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// Generic previous/navigation action label
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get commonPrevious;

  /// Generic retry action label
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// Generic loading state label
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get commonLoading;

  /// Generic error state label
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get commonError;

  /// Generic success state label
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get commonSuccess;

  /// English language display name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get localeEnglish;

  /// Arabic language display name
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get localeArabic;
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
