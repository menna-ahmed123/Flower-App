import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/helpers/app_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  validInputGroup();
  emptyInputGroup();
  passwordMismatchGroup();
  passwordPolicyGroup();
  phoneWhitespaceGroup();
  emailWhitespaceGroup();
}

void validInputGroup() {
  group('Register AppValidators valid input', () {
    test('accepts valid signup input', () {
      expect(
        AppValidators.requiredField('Sara', field: AppString.firstName),
        isNull,
      );
      expect(
        AppValidators.requiredField('Ali', field: AppString.lastName),
        isNull,
      );
      expect(AppValidators.emailValidator('sara@example.com'), isNull);
      expect(AppValidators.registrationPasswordValidator('Pass1234'), isNull);
      expect(
        AppValidators.confirmPasswordValidator('Pass1234', 'Pass1234'),
        isNull,
      );
      expect(AppValidators.phoneValidator('01012345678'), isNull);
    });
  });
}

void emptyInputGroup() {
  group('Register AppValidators empty input', () {
    test('rejects empty signup input', () {
      expect(
        AppValidators.requiredField('', field: AppString.firstName),
        AppString.fieldIsRequired(AppString.firstName),
      );
      expect(AppValidators.emailValidator(''), AppString.pleaseEnterYourEmail);
    });
  });
}

void passwordMismatchGroup() {
  group('Register AppValidators password mismatch', () {
    test('rejects password mismatch', () {
      expect(
        AppValidators.confirmPasswordValidator('Pass9999', 'Pass1234'),
        AppString.passwordsDoNotMatch,
      );
    });
  });
}

void passwordPolicyGroup() {
  group('Register AppValidators password policy', () {
    test('uses registration password policy', () {
      expect(
        AppValidators.registrationPasswordValidator('Password'),
        AppString.registrationPasswordRequirement,
      );
    });
  });
}

void phoneWhitespaceGroup() {
  group('Register AppValidators phone whitespace', () {
    test('accepts Egyptian phone numbers with surrounding whitespace', () {
      expect(AppValidators.phoneValidator(' 01012345678 '), isNull);
    });
  });
}

void emailWhitespaceGroup() {
  group('Register AppValidators email whitespace', () {
    test('treats whitespace-only email as empty', () {
      expect(
        AppValidators.emailValidator('   '),
        AppString.pleaseEnterYourEmail,
      );
    });
  });
}
