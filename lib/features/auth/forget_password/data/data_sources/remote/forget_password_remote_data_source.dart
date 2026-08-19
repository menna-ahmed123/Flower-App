import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/auth/forget_password/data/models/forget_password_request_model.dart';
import 'package:flower_app/features/auth/forget_password/data/models/forget_password_response_model.dart';
import 'package:flower_app/features/auth/forget_password/data/models/reset_password_request_model.dart';
import 'package:flower_app/features/auth/forget_password/data/models/reset_password_response_model.dart';
import 'package:flower_app/features/auth/forget_password/data/models/verify_otp_request_model.dart';
import 'package:flower_app/features/auth/forget_password/data/models/verify_otp_response_model.dart';

abstract interface class ForgetPasswordRemoteDataSource {
  Future<BaseResponse<ForgetPasswordResponseModel>> forgetPassword({
    required ForgetPasswordRequestModel requestModel,
  });

  Future<BaseResponse<VerifyOtpResponseModel>> verifyOtp({
    required VerifyOtpRequestModel requestModel,
  });

  Future<BaseResponse<ResetPasswordResponseModel>> resetPassword({
    required ResetPasswordRequestModel requestModel,
  });
}
