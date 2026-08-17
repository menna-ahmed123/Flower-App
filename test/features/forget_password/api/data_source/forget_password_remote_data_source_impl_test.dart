import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/forget_password/api/client/forget_password_api_client.dart';
import 'package:flower_app/features/forget_password/api/data_source/forget_password_remote_data_source_impl.dart';
import 'package:flower_app/features/forget_password/data/models/reset_password_request_model.dart';
import 'package:flower_app/features/forget_password/data/models/reset_password_response_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'forget_password_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ForgetPasswordApiClient, SafeCall])
void main() {
  late MockForgetPasswordApiClient mockForgetPasswordApiClient;
  late MockSafeCall mockSafeCall;

  late ForgetPasswordRemoteDataSourceImpl resetPasswordRemoteDataSourceImpl;

  setUp(() {
    mockForgetPasswordApiClient = MockForgetPasswordApiClient();
    mockSafeCall = MockSafeCall();

    resetPasswordRemoteDataSourceImpl = ForgetPasswordRemoteDataSourceImpl(
      forgetPasswordApiClient: mockForgetPasswordApiClient,
      safeCall: mockSafeCall,
    );
  });

  group('ResetPasswordRemoteDataSourceImpl Tests', () {
    test(
      'should return success response when reset password is called',
      () async {
        final requestModel = ResetPasswordRequestModel(
          resetToken: 'mock-reset-token',
          newPassword: 'Password123',
          confirmPassword: 'Password123',
        );

        final result = await resetPasswordRemoteDataSourceImpl.resetPassword(
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
  });
}
