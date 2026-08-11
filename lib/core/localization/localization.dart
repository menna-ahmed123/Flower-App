import 'package:flutter/widgets.dart';

import 'generated/app_localizations.dart';

export 'app_formatters.dart';
export 'app_locales.dart';
export 'generated/app_localizations.dart';
export 'locale_controller.dart';
export 'locale_storage.dart';

/// Convenient access to generated [AppLocalizations].
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
