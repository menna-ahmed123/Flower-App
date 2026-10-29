import 'package:easy_localization/easy_localization.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flutter/widgets.dart';

String localizedPlaceName(
  BuildContext context, {
  String? nameAr,
  String? nameEn,
  required String fallback,
}) {
  final preferArabic = context.locale.languageCode == 'ar';

  String? usable(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }

  final arabic = usable(nameAr);
  final english = usable(nameEn);
  if (preferArabic) return arabic ?? english ?? fallback;
  return english ?? arabic ?? fallback;
}

String localizedAddressLabel(String label) {
  switch (label.trim().toLowerCase()) {
    case 'home':
      return AppString.homeLabel;
    case 'office':
      return AppString.office;
    default:
      return label;
  }
}
