import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/di/app_environment.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/auth/forget_password/api/client/forget_password_api_client.dart';
import 'package:flower_app/features/auth/forget_password/data/data_sources/remote/forget_password_remote_data_source.dart';
import 'package:flower_app/features/auth/forget_password/data/models/forget_password_request_model.dart';
import 'package:flower_app/features/auth/forget_password/data/models/forget_password_response_model.dart';
import 'package:flower_app/features/auth/forget_password/data/models/reset_password_request_model.dart';
import 'package:flower_app/features/auth/forget_password/data/models/reset_password_response_model.dart';
import 'package:flower_app/features/auth/forget_password/data/models/verify_otp_request_model.dart';
import 'package:flower_app/features/auth/forget_password/data/models/verify_otp_response_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ForgetPasswordRemoteDataSource, env: [AppEnvironment.prod])
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
  }) {
    return safeCall.safeApiCall(
      () => forgetPasswordApiClient.forgotPassword(requestModel),
    );
  }

  @override
  Future<BaseResponse<VerifyOtpResponseModel>> verifyOtp({
    required VerifyOtpRequestModel requestModel,
  }) {
    return safeCall.safeApiCall(
      () => forgetPasswordApiClient.verifyOtp(requestModel),
    );
  }

  @override
  Future<BaseResponse<ResetPasswordResponseModel>> resetPassword({
    required ResetPasswordRequestModel requestModel,
  }) {
    return safeCall.safeApiCall(
      () => forgetPasswordApiClient.resetPassword(requestModel),
    );
  }
}
