import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/di/app_environment.dart';
import 'package:flower_app/core/dummy/dummy_network.dart';
import 'package:flower_app/features/auth/forget_password/data/data_sources/remote/forget_password_remote_data_source.dart';
import 'package:flower_app/features/auth/forget_password/data/models/forget_password_request_model.dart';
import 'package:flower_app/features/auth/forget_password/data/models/forget_password_response_model.dart';
import 'package:flower_app/features/auth/forget_password/data/models/reset_password_request_model.dart';
import 'package:flower_app/features/auth/forget_password/data/models/reset_password_response_model.dart';
import 'package:flower_app/features/auth/forget_password/data/models/verify_otp_request_model.dart';
import 'package:flower_app/features/auth/forget_password/data/models/verify_otp_response_model.dart';
import 'package:injectable/injectable.dart';

/// Temporary forgot-password backend until [AppEnvironment.prod] is enabled.
@Injectable(as: ForgetPasswordRemoteDataSource, env: [AppEnvironment.mock])
class ForgetPasswordMockRemoteDataSource
    implements ForgetPasswordRemoteDataSource {
  @override
  Future<BaseResponse<ForgetPasswordResponseModel>> forgetPassword({
    required ForgetPasswordRequestModel requestModel,
  }) async {
    await DummyNetwork.wait();
    return SuccessResponse(
      ForgetPasswordResponseModel(cooldownRemainingSeconds: 30),
    );
  }

  @override
  Future<BaseResponse<VerifyOtpResponseModel>> verifyOtp({
    required VerifyOtpRequestModel requestModel,
  }) async {
    await DummyNetwork.wait();
    return SuccessResponse(
      VerifyOtpResponseModel(
        status: 'success',
        resetToken: 'mock-reset-token',
        expiresAtUtc: DateTime.now().toUtc().add(const Duration(minutes: 10)),
      ),
    );
  }

  @override
  Future<BaseResponse<ResetPasswordResponseModel>> resetPassword({
    required ResetPasswordRequestModel requestModel,
  }) async {
    await DummyNetwork.wait();
    return SuccessResponse(
      ResetPasswordResponseModel(
        isSuccess: true,
        statusCode: 200,
        message: 'Password reset successfully',
        errors: null,
      ),
    );
  }
}
