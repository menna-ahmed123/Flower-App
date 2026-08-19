import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/forget_password/api/client/forget_password_api_client.dart';
import 'package:flower_app/features/forget_password/api/data_source/forget_password_remote_data_source_impl.dart';
import 'package:flower_app/features/forget_password/data/models/forget_password_request_model.dart';
import 'package:flower_app/features/forget_password/data/models/forget_password_response_model.dart';
import 'package:flower_app/features/forget_password/data/models/reset_password_request_model.dart';
import 'package:flower_app/features/forget_password/data/models/reset_password_response_model.dart';
import 'package:flower_app/features/forget_password/data/models/verify_otp_request_model.dart';
import 'package:flower_app/features/forget_password/data/models/verify_otp_response_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'forget_password_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ForgetPasswordApiClient, SafeCall])
void main() {
  _runForgetPasswordRemoteDataSourceTests();
}

void _runForgetPasswordRemoteDataSourceTests() {
  late MockForgetPasswordApiClient mockApiClient;
  late MockSafeCall mockSafeCall;
  late ForgetPasswordRemoteDataSourceImpl dataSource;

  setUp(() {
    mockApiClient = MockForgetPasswordApiClient();
    mockSafeCall = MockSafeCall();

    dataSource = ForgetPasswordRemoteDataSourceImpl(
      forgetPasswordApiClient: mockApiClient,
      safeCall: mockSafeCall,
    );
  });

  _forgetPasswordTests(() => dataSource);
  _verifyOtpTests(() => dataSource);
  _resetPasswordTests(() => dataSource);
}

void _forgetPasswordTests(
  ForgetPasswordRemoteDataSourceImpl Function() getDataSource,
) {
  test(
    'should return success response when forget password is called',
    () async {
      final requestModel = ForgetPasswordRequestModel(email: 'test@gmail.com');

      final result = await getDataSource().forgetPassword(
        requestModel: requestModel,
      );

      expect(result, isA<SuccessResponse<ForgetPasswordResponseModel>>());

      final response = result as SuccessResponse<ForgetPasswordResponseModel>;

      expect(response.data.cooldownRemainingSeconds, 30);
    },
  );
}

void _verifyOtpTests(
  ForgetPasswordRemoteDataSourceImpl Function() getDataSource,
) {
  test('should return success response when verify OTP is called', () async {
    final requestModel = VerifyOtpRequestModel(
      email: 'test@gmail.com',
      otp: '123456',
    );

    final result = await getDataSource().verifyOtp(requestModel: requestModel);

    expect(result, isA<SuccessResponse<VerifyOtpResponseModel>>());

    final response = result as SuccessResponse<VerifyOtpResponseModel>;

    expect(response.data.status, 'success');
    expect(response.data.resetToken, 'mock-reset-token');
    expect(response.data.expiresAtUtc, isNotNull);
  });
}

void _resetPasswordTests(
  ForgetPasswordRemoteDataSourceImpl Function() getDataSource,
) {
  test(
    'should return success response when reset password is called',
    () async {
      final requestModel = ResetPasswordRequestModel(
        resetToken: 'mock-reset-token',
        newPassword: 'Password123',
        confirmPassword: 'Password123',
      );

      final result = await getDataSource().resetPassword(
        requestModel: requestModel,
      );

      expect(result, isA<SuccessResponse<ResetPasswordResponseModel>>());

      final response = result as SuccessResponse<ResetPasswordResponseModel>;

      expect(response.data.isSuccess, true);
      expect(response.data.statusCode, 200);
      expect(response.data.message, 'Password reset successfully');
      expect(response.data.errors, isNull);
    },
  );
}
