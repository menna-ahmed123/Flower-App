import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/auth/forget_password/data/data_sources/remote/forget_password_remote_data_source.dart';
import 'package:flower_app/features/auth/forget_password/data/models/forget_password_request_model.dart';
import 'package:flower_app/features/auth/forget_password/data/models/forget_password_response_model.dart';
import 'package:flower_app/features/auth/forget_password/data/models/reset_password_request_model.dart';
import 'package:flower_app/features/auth/forget_password/data/models/reset_password_response_model.dart';
import 'package:flower_app/features/auth/forget_password/data/models/verify_otp_request_model.dart';
import 'package:flower_app/features/auth/forget_password/data/models/verify_otp_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ForgetPasswordRemoteDataSource dataSource;

  setUp(() {
    dataSource = _ForgetPasswordRemoteDataSourceFake();
  });

  test('returns dummy success for forget password', () async {
    final result = await dataSource.forgetPassword(
      requestModel: ForgetPasswordRequestModel(email: 'test@gmail.com'),
    );

    expect(result, isA<SuccessResponse<ForgetPasswordResponseModel>>());
    final response = result as SuccessResponse<ForgetPasswordResponseModel>;
    expect(response.data.data, true);
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
    expect(response.data.data.otpToken, 'mock-otp-token');
    expect(response.data.data.expiresInMinutes, 10);
  });

  test('returns dummy success for reset password', () async {
    final result = await dataSource.resetPassword(
      requestModel: ResetPasswordRequestModel(
        otpToken: 'mock-otp-token',
        password: 'Password123',
        confirmPassword: 'Password123',
      ),
    );

    expect(result, isA<SuccessResponse<ResetPasswordResponseModel>>());
    final response = result as SuccessResponse<ResetPasswordResponseModel>;
    expect(response.data.data, true);
    expect(response.data.code, 200);
    expect(response.data.message, 'Password reset successfully');
    expect(response.data.errors, isNull);
  });
}

class _ForgetPasswordRemoteDataSourceFake
    implements ForgetPasswordRemoteDataSource {
  @override
  Future<BaseResponse<ForgetPasswordResponseModel>> forgetPassword({
    required ForgetPasswordRequestModel requestModel,
  }) async {
    return SuccessResponse(ForgetPasswordResponseModel(data: true));
  }

  @override
  Future<BaseResponse<VerifyOtpResponseModel>> verifyOtp({
    required VerifyOtpRequestModel requestModel,
  }) async {
    return SuccessResponse(
      VerifyOtpResponseModel(
        data: VerifyOtpData(otpToken: 'mock-otp-token', expiresInMinutes: 10),
      ),
    );
  }

  @override
  Future<BaseResponse<ResetPasswordResponseModel>> resetPassword({
    required ResetPasswordRequestModel requestModel,
  }) async {
    return SuccessResponse(
      ResetPasswordResponseModel(
        status: true,
        code: 200,
        message: 'Password reset successfully',
        data: true,
      ),
    );
  }
}
