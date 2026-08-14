import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/auth/register/domain/validators/register_field_errors.dart';
import 'package:flower_app/features/auth/register/presentation/mappers/register_state_mapper.dart';
import 'package:flower_app/features/auth/register/presentation/mappers/register_validation_message_mapper.dart';
import 'package:flower_app/features/auth/register/presentation/state/register_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RegisterStateMapper', () {
    test('trims identity fields on toRequest', () {
      const state = RegisterState(
        firstName: ' Sara ',
        lastName: ' Ali ',
        email: '  sara@example.com  ',
        password: 'Pass1234',
        phoneNumber: ' 01012345678 ',
      );

      final request = RegisterStateMapper.toRequest(state);

      expect(request.firstName, 'Sara');
      expect(request.lastName, 'Ali');
      expect(request.email, 'sara@example.com');
      expect(request.phoneNumber, '01012345678');
      expect(request.password, 'Pass1234');
    });
  });

  group('RegisterValidationMessageMapper', () {
    test('maps domain error codes to UI strings', () {
      expect(
        RegisterValidationMessageMapper.message(
          RegisterField.email,
          RegisterValidationError.invalid,
        ),
        AppString.pleaseEnterValidEmail,
      );
      expect(
        RegisterValidationMessageMapper.message(
          RegisterField.firstName,
          RegisterValidationError.empty,
        ),
        AppString.fieldIsRequired(AppString.firstName),
      );
      expect(
        RegisterValidationMessageMapper.message(RegisterField.email, null),
        isNull,
      );
    });
  });
}
