import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/auth/forget_password/domain/entities/forget_password_entity.dart';
import 'package:flower_app/features/auth/forget_password/domain/entities/forget_password_params.dart';
import 'package:flower_app/features/auth/forget_password/domain/entities/reset_password_entity.dart';
import 'package:flower_app/features/auth/forget_password/domain/entities/reset_password_params.dart';
import 'package:flower_app/features/auth/forget_password/domain/entities/verify_otp_entity.dart';
import 'package:flower_app/features/auth/forget_password/domain/entities/verify_otp_params.dart';

abstract interface class ForgetPasswordRepo {
  Future<BaseResponse<ForgetPasswordEntity>> forgetPassword({
    required ForgetPasswordParams forgetPasswordParams,
  });

  Future<BaseResponse<VerifyOtpEntity>> verifyOtp({
    required VerifyOtpParams verifyOtpParams,
  });

  Future<BaseResponse<ResetPasswordEntity>> resetPassword({
    required ResetPasswordParams resetPasswordParams,
  });
}
