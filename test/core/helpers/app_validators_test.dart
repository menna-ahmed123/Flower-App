import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/helpers/app_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  requiredFieldGroup();
  usernameGroup();
  emailGroup();
  legacyPasswordGroup();
  registrationPasswordGroup();
  resetPasswordGroup();
  confirmPasswordGroup();
  phoneGroup();
}

void requiredFieldGroup() {
  group('AppValidators.requiredField', () {
    test('rejects empty values', () {
      expect(AppValidators.requiredField(null, field: 'Name'), AppString.fieldIsRequired('Name'));
      expect(AppValidators.requiredField('', field: 'Name'), AppString.fieldIsRequired('Name'));
    });
    test('accepts non-empty values', () {
      expect(AppValidators.requiredField('Sara', field: 'Name'), isNull);
    });
  });
}

void usernameGroup() {
  group('AppValidators.usernameValidator', () {
    test('rejects invalid usernames', () {
      expect(AppValidators.usernameValidator('ab'), AppString.fieldMinLength('Name', 4));
      expect(AppValidators.usernameValidator('user name'), AppString.fieldNoSpaces('Name'));
    });
    test('accepts valid usernames', () {
      expect(AppValidators.usernameValidator('user_1'), isNull);
    });
  });
}

void emailGroup() {
  group('AppValidators.emailValidator', () {
    test('rejects invalid emails', () {
      expect(AppValidators.emailValidator(''), AppString.pleaseEnterYourEmail);
      expect(AppValidators.emailValidator('bad'), AppString.pleaseEnterValidEmail);
    });
    test('accepts valid emails', () {
      expect(AppValidators.emailValidator('user@example.com'), isNull);
    });
  });
}

void legacyPasswordGroup() {
  group('AppValidators.passwordValidator', () {
    test('rejects invalid legacy passwords', () {
      expect(AppValidators.passwordValidator('pass1'), AppString.passwordRequirement);
    });
    test('accepts valid legacy passwords', () {
      expect(AppValidators.passwordValidator('Password'), isNull);
    });
  });
}

void registrationPasswordGroup() {
  group('AppValidators.registrationPasswordValidator', () {
    test('rejects invalid registration passwords', () {
      expect(AppValidators.registrationPasswordValidator('password'), AppString.registrationPasswordRequirement);
    });
    test('accepts valid registration passwords', () {
      expect(AppValidators.registrationPasswordValidator('Pass1234'), isNull);
    });
  });
}

void resetPasswordGroup() {
  group('AppValidators.resetPasswordValidator', () {
    test('rejects invalid reset passwords', () {
      expect(AppValidators.resetPasswordValidator('pass12'), AppString.resetPasswordRequirement);
    });
    test('accepts valid reset passwords', () {
      expect(AppValidators.resetPasswordValidator('Pass12'), isNull);
    });
  });
}

void confirmPasswordGroup() {
  group('AppValidators.confirmPasswordValidator', () {
    test('rejects mismatched passwords', () {
      expect(AppValidators.confirmPasswordValidator('Pass1234', 'Pass9999'), AppString.passwordsDoNotMatch);
    });
    test('accepts matching passwords', () {
      expect(AppValidators.confirmPasswordValidator('Pass1234', 'Pass1234'), isNull);
    });
  });
}

void phoneGroup() {
  group('AppValidators.phoneValidator', () {
    test('rejects invalid phone numbers', () {
      expect(AppValidators.phoneValidator(''), AppString.phoneNumberIsRequired);
      expect(AppValidators.phoneValidator('0123456789'), AppString.validEgyptianPhone);
    });
    test('accepts valid phone numbers', () {
      expect(AppValidators.phoneValidator('01012345678'), isNull);
    });
  });
}
