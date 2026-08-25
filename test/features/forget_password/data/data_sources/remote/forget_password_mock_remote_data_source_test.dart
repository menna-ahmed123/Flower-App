import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/auth/forget_password/data/data_sources/remote/forget_password_mock_remote_data_source.dart';
import 'package:flower_app/features/auth/forget_password/data/models/forget_password_request_model.dart';
import 'package:flower_app/features/auth/forget_password/data/models/forget_password_response_model.dart';
import 'package:flower_app/features/auth/forget_password/data/models/reset_password_request_model.dart';
import 'package:flower_app/features/auth/forget_password/data/models/reset_password_response_model.dart';
import 'package:flower_app/features/auth/forget_password/data/models/verify_otp_request_model.dart';
import 'package:flower_app/features/auth/forget_password/data/models/verify_otp_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ForgetPasswordMockRemoteDataSource dataSource;

  setUp(() {
    dataSource = ForgetPasswordMockRemoteDataSource();
  });

  test('returns dummy success for forget password', () async {
    final result = await dataSource.forgetPassword(
      requestModel: ForgetPasswordRequestModel(email: 'test@gmail.com'),
    );

    expect(result, isA<SuccessResponse<ForgetPasswordResponseModel>>());
    final response = result as SuccessResponse<ForgetPasswordResponseModel>;
    expect(response.data.cooldownRemainingSeconds, 30);
  });

  test('returns dummy success for verify OTP', () async {
    final result = await dataSource.verifyOtp(
      requestModel: VerifyOtpRequestModel(
        email: 'test@gmail.com',
        otp: '123456',
      ),
    );

    expect(result, isA<SuccessResponse<VerifyOtpResponseModel>>());
    final response = result as SuccessResponse<VerifyOtpResponseModel>;
    expect(response.data.status, 'success');
    expect(response.data.resetToken, 'mock-reset-token');
    expect(response.data.expiresAtUtc, isNotNull);
  });

  test('returns dummy success for reset password', () async {
    final result = await dataSource.resetPassword(
      requestModel: ResetPasswordRequestModel(
        resetToken: 'mock-reset-token',
        newPassword: 'Password123',
        confirmPassword: 'Password123',
      ),
    );

    expect(result, isA<SuccessResponse<ResetPasswordResponseModel>>());
    final response = result as SuccessResponse<ResetPasswordResponseModel>;
    expect(response.data.isSuccess, true);
    expect(response.data.statusCode, 200);
    expect(response.data.message, 'Password reset successfully');
    expect(response.data.errors, isNull);
  });
}
