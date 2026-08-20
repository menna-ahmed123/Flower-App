import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/auth/forget_password/api/client/forget_password_api_client.dart';
import 'package:flower_app/features/auth/forget_password/api/data_source/forget_password_remote_data_source_impl.dart';
import 'package:flower_app/features/auth/forget_password/data/models/forget_password_request_model.dart';
import 'package:flower_app/features/auth/forget_password/data/models/forget_password_response_model.dart';
import 'package:flower_app/features/auth/forget_password/data/models/reset_password_request_model.dart';
import 'package:flower_app/features/auth/forget_password/data/models/reset_password_response_model.dart';
import 'package:flower_app/features/auth/forget_password/data/models/verify_otp_request_model.dart';
import 'package:flower_app/features/auth/forget_password/data/models/verify_otp_response_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'forget_password_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ForgetPasswordApiClient])
void main() {
  late MockForgetPasswordApiClient mockApiClient;
  late ForgetPasswordRemoteDataSourceImpl dataSource;

  setUp(() {
    mockApiClient = MockForgetPasswordApiClient();
    dataSource = ForgetPasswordRemoteDataSourceImpl(
      forgetPasswordApiClient: mockApiClient,
      safeCall: SafeCall(),
    );
  });

  test('returns success when forget password API succeeds', () async {
    final requestModel = ForgetPasswordRequestModel(email: 'test@gmail.com');
    final apiResponse = ForgetPasswordResponseModel(
      cooldownRemainingSeconds: 30,
    );
    when(
      mockApiClient.forgotPassword(requestModel),
    ).thenAnswer((_) async => apiResponse);

    final result = await dataSource.forgetPassword(requestModel: requestModel);

    expect(result, isA<SuccessResponse<ForgetPasswordResponseModel>>());
    final response = result as SuccessResponse<ForgetPasswordResponseModel>;
    expect(response.data.cooldownRemainingSeconds, 30);
    verify(mockApiClient.forgotPassword(requestModel)).called(1);
  });

  test('returns success when verify OTP API succeeds', () async {
    final requestModel = VerifyOtpRequestModel(
      email: 'test@gmail.com',
      otp: '123456',
    );
    final expiresAt = DateTime.utc(2026, 1, 1, 12);
    final apiResponse = VerifyOtpResponseModel(
      status: 'success',
      resetToken: 'mock-reset-token',
      expiresAtUtc: expiresAt,
    );
    when(
      mockApiClient.verifyOtp(requestModel),
    ).thenAnswer((_) async => apiResponse);

    final result = await dataSource.verifyOtp(requestModel: requestModel);

    expect(result, isA<SuccessResponse<VerifyOtpResponseModel>>());
    final response = result as SuccessResponse<VerifyOtpResponseModel>;
    expect(response.data.status, 'success');
    expect(response.data.resetToken, 'mock-reset-token');
    expect(response.data.expiresAtUtc, expiresAt);
    verify(mockApiClient.verifyOtp(requestModel)).called(1);
  });

  test('returns success when reset password API succeeds', () async {
    final requestModel = ResetPasswordRequestModel(
      resetToken: 'mock-reset-token',
      newPassword: 'Password123',
      confirmPassword: 'Password123',
    );
    final apiResponse = ResetPasswordResponseModel(
      isSuccess: true,
      statusCode: 200,
      message: 'Password reset successfully',
      errors: null,
    );
    when(
      mockApiClient.resetPassword(requestModel),
    ).thenAnswer((_) async => apiResponse);

    final result = await dataSource.resetPassword(requestModel: requestModel);

    expect(result, isA<SuccessResponse<ResetPasswordResponseModel>>());
    final response = result as SuccessResponse<ResetPasswordResponseModel>;
    expect(response.data.isSuccess, true);
    expect(response.data.statusCode, 200);
    expect(response.data.message, 'Password reset successfully');
    verify(mockApiClient.resetPassword(requestModel)).called(1);
  });
}
