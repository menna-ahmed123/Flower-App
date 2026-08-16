import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/forget_password/api/client/forget_password_api_client.dart';
import 'package:flower_app/features/forget_password/api/data_source/forget_password_remote_data_source_impl.dart';
import 'package:flower_app/features/forget_password/data/models/forget_password_request_model.dart';
import 'package:flower_app/features/forget_password/data/models/forget_password_response_model.dart';
import 'package:flower_app/features/forget_password/data/models/verify_otp_request_model.dart';
import 'package:flower_app/features/forget_password/data/models/verify_otp_response_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'forget_password_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ForgetPasswordApiClient, SafeCall])
void main() {
  late MockForgetPasswordApiClient mockForgetPasswordApiClient;
  late MockSafeCall mockSafeCall;

  late ForgetPasswordRemoteDataSourceImpl forgetPasswordRemoteDataSourceImpl;

  setUp(() {
    mockForgetPasswordApiClient = MockForgetPasswordApiClient();
    mockSafeCall = MockSafeCall();

    forgetPasswordRemoteDataSourceImpl = ForgetPasswordRemoteDataSourceImpl(
      forgetPasswordApiClient: mockForgetPasswordApiClient,
      safeCall: mockSafeCall,
    );
  });

  group('ForgetPasswordRemoteDataSourceImpl Tests', () {
    test(
      'should return success response when forget password is called',
      () async {
        // Arrange
        final requestModel = ForgetPasswordRequestModel(
          email: 'test@gmail.com',
        );

        // Act
        final result = await forgetPasswordRemoteDataSourceImpl.forgetPassword(
          requestModel: requestModel,
        );

        // Assert
        expect(result, isA<SuccessResponse<ForgetPasswordResponseModel>>());

        final response = result as SuccessResponse<ForgetPasswordResponseModel>;

        expect(response.data.cooldownRemainingSeconds, 30);
      },
    );

    test('should return success response when verify OTP is called', () async {
      // Arrange
      final requestModel = VerifyOtpRequestModel(
        email: 'test@gmail.com',
        otp: '123456',
      );

      // Act
      final result = await forgetPasswordRemoteDataSourceImpl.verifyOtp(
        requestModel: requestModel,
      );

      // Assert
      expect(result, isA<SuccessResponse<VerifyOtpResponseModel>>());

      final response = result as SuccessResponse<VerifyOtpResponseModel>;

      expect(response.data.status, 'success');

      expect(response.data.resetToken, 'mock-reset-token');

      expect(response.data.expiresAtUtc, isNotNull);
    });
  });
}
