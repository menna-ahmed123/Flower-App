import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/forget_password/api/client/forget_password_api_client.dart';
import 'package:flower_app/features/forget_password/data/data_sources/remote/forget_password_remote_data_source.dart';
import 'package:flower_app/features/forget_password/data/models/forget_password_request_model.dart';
import 'package:flower_app/features/forget_password/data/models/forget_password_response_model.dart';
import 'package:flower_app/features/forget_password/data/models/reset_password_request_model.dart';
import 'package:flower_app/features/forget_password/data/models/reset_password_response_model.dart';
import 'package:flower_app/features/forget_password/data/models/verify_otp_request_model.dart';
import 'package:flower_app/features/forget_password/data/models/verify_otp_response_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ForgetPasswordRemoteDataSource)
class ForgetPasswordRemoteDataSourceImpl
    implements ForgetPasswordRemoteDataSource {
  final ForgetPasswordApiClient forgetPasswordApiClient;
  final SafeCall safeCall;

  ForgetPasswordRemoteDataSourceImpl({
    required this.forgetPasswordApiClient,
    required this.safeCall,
  });

  @override
  Future<BaseResponse<ForgetPasswordResponseModel>> forgetPassword({
    required ForgetPasswordRequestModel requestModel,
  }) async {
    // Temporary mock response for testing until the real API is available.
    return SuccessResponse(
      ForgetPasswordResponseModel(cooldownRemainingSeconds: 30),
    );

    /*
    // Real API call - uncomment when the backend API is available.
    return safeCall.safeApiCall(
      () => forgetPasswordApiClient.forgotPassword(requestModel),
    );
    */
  }

  @override
  Future<BaseResponse<VerifyOtpResponseModel>> verifyOtp({
    required VerifyOtpRequestModel requestModel,
  }) async {
    // Temporary mock response for testing until the real API is available.
    return SuccessResponse(
      VerifyOtpResponseModel(
        status: 'success',
        resetToken: 'mock-reset-token',
        expiresAtUtc: DateTime.now().toUtc().add(const Duration(minutes: 10)),
      ),
    );

    /*
    // Real API call - uncomment when the backend API is available.
    return safeCall.safeApiCall(
      () => forgetPasswordApiClient.verifyOtp(requestModel),
    );
    */
  }

  @override
  Future<BaseResponse<ResetPasswordResponseModel>> resetPassword({
    required ResetPasswordRequestModel requestModel,
  }) async {
    // Temporary mock response for testing until the real API is available.
    return SuccessResponse(
      ResetPasswordResponseModel(
        isSuccess: true,
        statusCode: 200,
        message: 'Password reset successfully',
        errors: null,
      ),
    );

    /*
    // Real API call - uncomment when the backend API is available.
    return safeCall.safeApiCall(
      () => forgetPasswordApiClient.resetPassword(requestModel),
    );
    */
  }
}
