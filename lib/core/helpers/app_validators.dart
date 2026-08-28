import 'package:flower_app/core/constants/app_string.dart';

class AppValidators {
  AppValidators._();

  static final RegExp _passwordPattern = RegExp(r'^(?=.*[A-Z]).{8,}$');

  static final RegExp _registrationPasswordPattern = RegExp(
    r'^(?=.*[A-Z])(?=.*\d).{6,}$',
  );

  static final RegExp _usernamePattern = RegExp(r'^[a-zA-Z0-9_]+$');

  static final RegExp _emailPattern = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

  static final RegExp _phonePattern = RegExp(r'^01[0125][0-9]{8}$');

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

    if (!_usernamePattern.hasMatch(value)) {
      return AppString.onlyLettersNumbersUnderscore;
    }

    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppString.pleaseEnterYourEmail;
    }

    if (!_emailPattern.hasMatch(value.trim())) {
      return AppString.pleaseEnterValidEmail;
    }

    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppString.passwordIsRequired;
    }

    if (!_passwordPattern.hasMatch(value)) {
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

    if (!_phonePattern.hasMatch(value.trim())) {
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

  static String? otpValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppString.otpRequired;
    }

    if (value.length != 6) {
      return AppString.invalidOtp;
    }

    return null;
  }
  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the address';
    }
    if (value.trim().length < 5) {
      return 'Address must be at least 5 characters';
    }
    return null;
  }
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the phone number';
    }
    // Egyptian phone number pattern (01x xxxxxxxx) or general 11-digit phone number
    final phoneRegex = RegExp(r'^01[0125][0-9]{8}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
  static String? validateRecipientName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the recipient name';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }
  static String? validateCity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a city';
    }
    return null;
  }
  static String? validateArea(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select an area';
    }
    return null;
  }
}
