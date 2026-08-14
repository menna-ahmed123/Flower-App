import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/auth/register/domain/validators/register_form_validator.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/register_test_support.dart';

void main() {
  validInputGroup();
  emptyInputGroup();
  passwordMismatchGroup();
  passwordPolicyGroup();
}

void validInputGroup() {
  group('RegisterFormValidator valid input', () {
    const validator = RegisterFormValidator();
    test('accepts valid signup input', () {
      expect(validator.validate(validRegisterFormInput).hasErrors, isFalse);
    });
  });
}

void emptyInputGroup() {
  group('RegisterFormValidator empty input', () {
    const validator = RegisterFormValidator();
    test('rejects empty signup input', () {
      final errors = validator.validate(emptyRegisterFormInput);
      expect(errors.firstName, AppString.fieldIsRequired(AppString.firstName));
      expect(errors.email, AppString.pleaseEnterYourEmail);
    });
  });
}

void passwordMismatchGroup() {
  group('RegisterFormValidator password mismatch', () {
    const validator = RegisterFormValidator();
    test('rejects password mismatch', () {
      final errors = validator.validate(
        const RegisterFormInput(
          firstName: 'Sara', lastName: 'Ali', email: 'sara@example.com',
          password: 'Pass1234', confirmPassword: 'Pass9999', phoneNumber: '01012345678',
        ),
      );
      expect(errors.confirmPassword, AppString.passwordsDoNotMatch);
    });
  });
}

void passwordPolicyGroup() {
  group('RegisterFormValidator password policy', () {
    const validator = RegisterFormValidator();
    test('uses registration password policy', () {
      final errors = validator.validate(
        const RegisterFormInput(
          firstName: 'Sara', lastName: 'Ali', email: 'sara@example.com',
          password: 'Password', confirmPassword: 'Password', phoneNumber: '01012345678',
        ),
      );
      expect(errors.password, AppString.registrationPasswordRequirement);
    });
  });
}
