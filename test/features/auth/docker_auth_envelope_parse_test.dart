import 'package:flower_app/features/auth/forget_password/data/models/forget_password_response_model.dart';
import 'package:flower_app/features/auth/login/data/models/login_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses Docker login envelope with success alias', () {
    final response = LoginResponse.fromJson({
      'data': {
        'accessToken': 'access-token',
        'refreshToken': 'refresh-token',
        'expiresIn': 900,
        'role': 'Customer',
        'driverApplicationStatus': null,
        'canAccessDriverHome': true,
        'driverApplicationRejectionReason': null,
      },
      'statusCode': 200,
      'success': true,
      'message': 'Login successful.',
      'messageLocalized': 'Login successful.',
    });

    expect(response.isSuccess, isTrue);
    expect(response.data.accessToken, 'access-token');
    expect(response.data.refreshToken, 'refresh-token');
    expect(response.data.role, 'Customer');
  });

  test('parses Docker forgot-password nested data envelope', () {
    final response = ForgetPasswordResponseModel.fromJson({
      'data': {'cooldownRemainingSeconds': 30},
      'statusCode': 200,
      'success': true,
      'message': 'If this email is registered, a code has been sent.',
      'messageLocalized': 'If this email is registered, a code has been sent.',
    });

    expect(response.cooldownRemainingSeconds, 30);
  });
}
