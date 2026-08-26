import 'package:flower_app/features/auth/register/data/models/register_request.dart';
import 'package:flower_app/features/auth/register/data/models/register_response.dart';
import 'package:flower_app/features/auth/register/domain/entity/gender.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/register_test_support.dart';

void main() {
  testRequestSerializesOpenApiBody();
  testRequestFromJson();
  testResponseParsesApiContract();
  testResponseParsesErrors();
  testDataToDomain();
  testGenderApiValues();
}

void testRequestSerializesOpenApiBody() {
  test('serializes RegisterRequest to the OpenAPI body', () {
    expect(validRegisterRequest().toJson(), expectedFemaleBody());
  });
}

void testRequestFromJson() {
  test('parses RegisterRequest from JSON', () {
    final request = RegisterRequest.fromJson(expectedFemaleBody());
    expect(request.fullName, 'Sara Ali');
    expect(request.email, 'sara@example.com');
    expect(request.phoneNumber, '01012345678');
    expect(request.gender, 'Female');
    expect(request.password, 'Pass1234');
    expect(request.confirmPassword, 'Pass1234');
  });
}

void testResponseParsesApiContract() {
  test('parses RegisterResponse API contract', () {
    final response = RegisterResponse.fromJson({
      'isSuccess': true,
      'statusCode': 201,
      'message': 'Account registered successfully.',
      'data': {
        'userId': 'user-1',
        'email': 'user@example.com',
        'role': 'Customer',
        'status': 'Active',
      },
    });
    expect(response.isSuccess, isTrue);
    expect(response.statusCode, 201);
    expect(response.message, 'Account registered successfully.');
    expect(response.data?.userId, 'user-1');
    expect(response.data?.email, 'user@example.com');
    expect(response.data?.role, 'Customer');
    expect(response.data?.status, 'Active');
  });

  test('parses RegisterResponse Docker success alias', () {
    final response = RegisterResponse.fromJson({
      'success': true,
      'statusCode': 201,
      'message': 'Account registered successfully.',
      'messageLocalized': 'Account registered successfully.',
      'data': {
        'userId': 'user-1',
        'email': 'user@example.com',
        'role': 'Customer',
        'status': 'Active',
      },
    });
    expect(response.isSuccess, isTrue);
    expect(response.data?.userId, 'user-1');
  });
}

void testResponseParsesErrors() {
  test('parses optional errors map', () {
    final response = RegisterResponse.fromJson({
      'isSuccess': false,
      'statusCode': 422,
      'message': 'Customer registration validation failed.',
      'errors': {
        'Email': ['Email already registered'],
      },
    });
    expect(response.isSuccess, isFalse);
    expect(response.data, isNull);
    expect(response.errors?['Email'], ['Email already registered']);
  });
}

void testDataToDomain() {
  test('maps RegisterData to RegisterEntity', () {
    final entity = RegisterData(
      userId: 'user-1',
      email: 'user@example.com',
      role: 'Customer',
      status: 'Active',
    ).toDomain(message: 'Account registered successfully.');
    expect(entity.userId, 'user-1');
    expect(entity.email, 'user@example.com');
    expect(entity.role, 'Customer');
    expect(entity.status, 'Active');
    expect(entity.message, 'Account registered successfully.');
  });
}

void testGenderApiValues() {
  test('maps gender enum to OpenAPI values', () {
    expect(Gender.female.apiValue, 'Female');
    expect(Gender.male.apiValue, 'Male');
  });
}
