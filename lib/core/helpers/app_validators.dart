import 'package:flower_app/core/constants/app_string.dart';

class AppValidators {
  AppValidators._();

  static final RegExp _legacyPasswordPattern = RegExp(r'^(?=.*[A-Z]).{8,}$');
  static final RegExp _registrationPasswordPattern =
      RegExp(r'^(?=.*[A-Z])(?=.*\d).{6,}$');

  static String? requiredField(String? value, {required String field}) {
    if (value == null || value.trim().isEmpty) {
      return AppString.fieldIsRequired(field);
    }
    return null;
  }

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
    if (!_legacyPasswordPattern.hasMatch(value)) {
      return AppString.passwordRequirement;
    }
    return null;
  }

  static String? registrationPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppString.passwordIsRequired;
    }
    if (!_registrationPasswordPattern.hasMatch(value)) {
      return AppString.registrationPasswordRequirement;
    }
    return null;
  }

  static String? confirmPasswordValidator(String? value, String password) {
    if (value == null || value.isEmpty) {
      return AppString.confirmPasswordIsRequired;
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

    if (!_registrationPasswordPattern.hasMatch(value)) {
      return AppString.resetPasswordRequirement;
    }

    return null;
  }
}
