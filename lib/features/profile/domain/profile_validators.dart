import 'package:flower_app/core/constants/app_string.dart';

class ProfileValidators {
  ProfileValidators._();

  // TODO: confirm with backend: Egyptian phone numbers are 11 digits starting with 01.
  static String? egyptianPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppString.phoneNumberIsRequired;
    }
    if (!RegExp(r'^01[0-9]{9}$').hasMatch(value.trim())) {
      return AppString.validEgyptianPhone;
    }
    return null;
  }
}