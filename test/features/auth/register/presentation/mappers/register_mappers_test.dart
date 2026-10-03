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
    expect(request.firstName, 'Sara');
    expect(request.lastName, 'Ali');
    expect(request.email, 'sara@example.com');
    expect(request.phone, '01012345678');
    expect(request.gender, 1);
    expect(request.password, 'Pass1234');
    expect(request.confirmPassword, 'Pass1234');
  });
}

void testResponseParsesApiContract() {
  test('parses RegisterResponse API contract', () {
    final response = RegisterResponse.fromJson({
      'status': true,
      'code': 201,
      'message': 'Account registered successfully.',
      'data': {
        'user': {
          'id': 'user-1',
          'email': 'user@example.com',
          'phone': '01012345678',
          'name': 'Sara Ali',
          'roles': ['CUSTOMER'],
          'createdAt': '2026-01-01T00:00:00Z',
          'gender': 'Female',
          'notificationStatus': 'on',
        },
        'token': 'register-token',
      },
    });
    expect(response.isSuccess, isTrue);
    expect(response.code, 201);
    expect(response.message, 'Account registered successfully.');
    expect(response.data?.user.id, 'user-1');
    expect(response.data?.user.roles, ['CUSTOMER']);
    expect(response.data?.user.gender, 'FEMALE');
    expect(response.data?.user.notificationStatus, 'ON');
    expect(response.data?.refreshToken, isNull);
  });

  test('parses RegisterResponse Docker success alias', () {
    final response = RegisterResponse.fromJson({
      'status': true,
      'code': 201,
      'message': 'Account registered successfully.',
      'messageLocalized': 'Account registered successfully.',
      'data': {
        'user': {
          'id': 'user-1',
          'email': 'user@example.com',
          'phone': '01012345678',
          'name': 'Sara Ali',
          'roles': ['CUSTOMER'],
          'createdAt': '2026-01-01T00:00:00Z',
          'gender': 'Female',
          'notificationStatus': 'on',
        },
        'token': 'register-token',
      },
    });
    expect(response.isSuccess, isTrue);
    expect(response.data?.user.id, 'user-1');
  });
}

void testResponseParsesErrors() {
  test('parses optional errors map', () {
    final response = RegisterResponse.fromJson({
      'status': false,
      'code': 422,
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
      token: 'register-token',
      user: RegisterUser(
        id: 'user-1',
        email: 'user@example.com',
        phone: '01012345678',
        name: 'Sara Ali',
        roles: ['CUSTOMER'],
        createdAt: DateTime.parse('2026-01-01T00:00:00Z'),
        gender: 'FEMALE',
        notificationStatus: 'ON',
      ),
    ).toDomain(message: 'Account registered successfully.');
    expect(entity.userId, 'user-1');
    expect(entity.email, 'user@example.com');
    expect(entity.role, 'CUSTOMER');
    expect(entity.status, 'ON');
    expect(entity.message, 'Account registered successfully.');
  });
}

void testGenderApiValues() {
  test('maps gender enum to OpenAPI values', () {
    expect(Gender.female.apiValue, 1);
    expect(Gender.male.apiValue, 0);
  });
}
