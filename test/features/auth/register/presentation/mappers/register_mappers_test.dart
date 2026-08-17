import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/auth/register/domain/validators/register_field_errors.dart';
import 'package:flower_app/features/auth/register/presentation/mappers/register_state_mapper.dart';
import 'package:flower_app/features/auth/register/presentation/mappers/register_validation_message_mapper.dart';
import 'package:flower_app/features/auth/register/presentation/state/register_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testStateMapperTrimsIdentityFields();
  testValidationMessageMapsEmail();
  testValidationMessageMapsFirstName();
  testValidationMessageNullError();
}

void testStateMapperTrimsIdentityFields() {
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
}

void testValidationMessageMapsEmail() {
  test('maps invalid email to UI string', () {
    expect(
      RegisterValidationMessageMapper.message(
        RegisterField.email,
        RegisterValidationError.invalid,
      ),
      AppString.pleaseEnterValidEmail,
    );
  });
}

void testValidationMessageMapsFirstName() {
  test('maps empty first name to UI string', () {
    expect(
      RegisterValidationMessageMapper.message(
        RegisterField.firstName,
        RegisterValidationError.empty,
      ),
      AppString.fieldIsRequired(AppString.firstName),
    );
  });
}

void testValidationMessageNullError() {
  test('maps null domain error to null', () {
    expect(
      RegisterValidationMessageMapper.message(RegisterField.email, null),
      isNull,
    );
  });
}
