import 'package:flower_app/features/auth/forget_password/data/models/forget_password_response_model.dart';
import 'package:flower_app/features/auth/login/data/models/login_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses Docker login envelope with success alias', () {
    final response = LoginResponse.fromJson({
      'data': {
        'user': {
          'id': 'user-1',
          'email': 'test@test.com',
          'phone': '01012345678',
          'name': 'Test User',
          'roles': ['CUSTOMER'],
          'createdAt': '2026-01-01T00:00:00Z',
          'updatedAt': '2026-01-01T00:00:00Z',
          'gender': 'MALE',
          'notificationStatus': 'ON',
        },
        'token': 'access-token',
        'refreshToken': 'refresh-token',
      },
      'status': true,
      'code': 200,
      'message': 'Login successful.',
    });

    expect(response.status, isTrue);
    expect(response.data?.token, 'access-token');
    expect(response.data?.refreshToken, 'refresh-token');
    expect(response.data?.user.roles, ['CUSTOMER']);
  });

  test('parses Docker forgot-password nested data envelope', () {
    final response = ForgetPasswordResponseModel.fromJson({
      'data': true,
      'status': true,
      'code': 200,
      'message': 'If this email is registered, a code has been sent.',
    });

    expect(response.data, isTrue);
  });
}
