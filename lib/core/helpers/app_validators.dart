import 'package:flower_app/core/constants/app_string.dart';

class AppValidators {
  AppValidators._();

  static String? usernameValidator(String? value, {String field = 'Name'}) {
    if (value == null || value.trim().isEmpty) {
      return AppString.fieldIsRequired(field);
    }

    if (value.length < 4) {
      return AppString.fieldMinLength(field, 4);
    }

    if (value.contains(' ')) {
      return AppString.fieldNoSpaces(field);
    }

    final regex = RegExp(r'^[a-zA-Z0-9_]+$');

    if (!regex.hasMatch(value)) {
      return AppString.onlyLettersNumbersUnderscore;
    }

    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppString.pleaseEnterYourEmail;
    }

    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

    if (!regex.hasMatch(value.trim())) {
      return AppString.pleaseEnterValidEmail;
    }

    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppString.passwordIsRequired;
    }

    final RegExp passwordRegExp = RegExp(r'^(?=.*[A-Z]).{8,}$');

    if (!passwordRegExp.hasMatch(value)) {
      return AppString.passwordRequirement;
    }

    return null;
  }

  static String? registrationPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppString.passwordIsRequired;
    }

    if (value != password) {
      return AppString.passwordsDoNotMatch;
    }

    return null;
  }

  static String? phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppString.phoneNumberIsRequired;
    }

    final regex = RegExp(r'^01[0125][0-9]{8}$');

    if (!regex.hasMatch(value)) {
      return AppString.validEgyptianPhone;
    }

    return null;
  }

  static String? resetPasswordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppString.passwordIsRequired;
    }

    final regex = RegExp(r'^(?=.*[A-Z])(?=.*\d).{6,}$');

    if (!regex.hasMatch(value)) {
      return AppString.resetPasswordRequirement;
    }

    return null;
  }

  static String? otpValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppString.otpRequired;
    }

    if (value.length != 6) {
      return AppString.invalidOtp;
    }

    return null;
  }
}
