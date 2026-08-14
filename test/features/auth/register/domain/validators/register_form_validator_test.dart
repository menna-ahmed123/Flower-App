import 'package:flower_app/features/auth/register/domain/validators/register_field_errors.dart';
import 'package:flower_app/features/auth/register/domain/validators/register_form_validator.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/register_test_support.dart';

void main() {
  validInputGroup();
  emptyInputGroup();
  passwordMismatchGroup();
  passwordPolicyGroup();
  whitespaceInputGroup();
  fieldErrorApplyGroup();
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
      expect(errors.firstName, RegisterValidationError.empty);
      expect(errors.email, RegisterValidationError.empty);
    });
  });
}

void passwordMismatchGroup() {
  group('RegisterFormValidator password mismatch', () {
    const validator = RegisterFormValidator();
    test('rejects password mismatch', () {
      final errors = validator.validate(
        const RegisterFormInput(
          firstName: 'Sara',
          lastName: 'Ali',
          email: 'sara@example.com',
          password: 'Pass1234',
          confirmPassword: 'Pass9999',
          phoneNumber: '01012345678',
        ),
      );
      expect(errors.confirmPassword, RegisterValidationError.mismatch);
    });
  });
}

void passwordPolicyGroup() {
  group('RegisterFormValidator password policy', () {
    const validator = RegisterFormValidator();
    test('uses registration password policy', () {
      final errors = validator.validate(
        const RegisterFormInput(
          firstName: 'Sara',
          lastName: 'Ali',
          email: 'sara@example.com',
          password: 'Password',
          confirmPassword: 'Password',
          phoneNumber: '01012345678',
        ),
      );
      expect(errors.password, RegisterValidationError.invalid);
    });
  });
}

void whitespaceInputGroup() {
  group('RegisterFormValidator whitespace', () {
    const validator = RegisterFormValidator();

    test('accepts Egyptian phone numbers with surrounding whitespace', () {
      final errors = validator.validate(
        const RegisterFormInput(
          firstName: 'Sara',
          lastName: 'Ali',
          email: 'sara@example.com',
          password: 'Pass1234',
          confirmPassword: 'Pass1234',
          phoneNumber: ' 01012345678 ',
        ),
      );
      expect(errors.phoneNumber, isNull);
    });

    test('treats whitespace-only email as empty', () {
      final errors = validator.validate(
        const RegisterFormInput(
          firstName: 'Sara',
          lastName: 'Ali',
          email: '   ',
          password: 'Pass1234',
          confirmPassword: 'Pass1234',
          phoneNumber: '01012345678',
        ),
      );
      expect(errors.email, RegisterValidationError.empty);
    });
  });
}

void fieldErrorApplyGroup() {
  group('RegisterFieldErrors.applyChangedField', () {
    test('clears the changed field while keeping other errors', () {
      const previous = RegisterFieldErrors(
        firstName: RegisterValidationError.empty,
        email: RegisterValidationError.invalid,
      );
      const partial = RegisterFieldErrors();
      final next = previous.applyChangedField(RegisterField.firstName, partial);
      expect(next.firstName, isNull);
      expect(next.email, RegisterValidationError.invalid);
    });

    test('updates confirm-password when password changes', () {
      const previous = RegisterFieldErrors(
        password: RegisterValidationError.invalid,
        confirmPassword: RegisterValidationError.mismatch,
      );
      const partial = RegisterFieldErrors();
      final next = previous.applyChangedField(RegisterField.password, partial);
      expect(next.password, isNull);
      expect(next.confirmPassword, isNull);
    });
  });
}
