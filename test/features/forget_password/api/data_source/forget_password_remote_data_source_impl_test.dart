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
    final apiResponse = ForgetPasswordResponseModel(data: true);
    when(
      mockApiClient.forgotPassword(requestModel),
    ).thenAnswer((_) async => apiResponse);

    final result = await dataSource.forgetPassword(requestModel: requestModel);

    expect(result, isA<SuccessResponse<ForgetPasswordResponseModel>>());
    final response = result as SuccessResponse<ForgetPasswordResponseModel>;
    expect(response.data.data, true);
    verify(mockApiClient.forgotPassword(requestModel)).called(1);
  });

  test('returns success when verify OTP API succeeds', () async {
    final requestModel = VerifyOtpRequestModel(
      email: 'test@gmail.com',
      otp: '123456',
    );
    final apiResponse = VerifyOtpResponseModel(
      data: VerifyOtpData(otpToken: 'mock-otp-token', expiresInMinutes: 10),
    );
    when(
      mockApiClient.verifyOtp(requestModel),
    ).thenAnswer((_) async => apiResponse);

    final result = await dataSource.verifyOtp(requestModel: requestModel);

    expect(result, isA<SuccessResponse<VerifyOtpResponseModel>>());
    final response = result as SuccessResponse<VerifyOtpResponseModel>;
    expect(response.data.data.otpToken, 'mock-otp-token');
    expect(response.data.data.expiresInMinutes, 10);
    verify(mockApiClient.verifyOtp(requestModel)).called(1);
  });

  test('returns success when reset password API succeeds', () async {
    final requestModel = ResetPasswordRequestModel(
      otpToken: 'mock-otp-token',
      password: 'Password123',
      confirmPassword: 'Password123',
    );
    final apiResponse = ResetPasswordResponseModel(
      status: true,
      code: 200,
      message: 'Password reset successfully',
      data: true,
    );
    when(
      mockApiClient.resetPassword(requestModel),
    ).thenAnswer((_) async => apiResponse);

    final result = await dataSource.resetPassword(requestModel: requestModel);

    expect(result, isA<SuccessResponse<ResetPasswordResponseModel>>());
    final response = result as SuccessResponse<ResetPasswordResponseModel>;
    expect(response.data.data, true);
    expect(response.data.code, 200);
    expect(response.data.message, 'Password reset successfully');
    verify(mockApiClient.resetPassword(requestModel)).called(1);
  });
}
