import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/forget_password/domain/entities/forget_password_entity.dart';
import 'package:flower_app/features/forget_password/domain/entities/forget_password_params.dart';
import 'package:flower_app/features/forget_password/domain/entities/verify_otp_entity.dart';
import 'package:flower_app/features/forget_password/domain/entities/verify_otp_params.dart';

abstract class ForgetPasswordRepo {
  Future<BaseResponse<ForgetPasswordEntity>> forgetPassword({
    required ForgetPasswordParams forgetPasswordParams,
  });

  Future<BaseResponse<VerifyOtpEntity>> verifyOtp({
    required VerifyOtpParams verifyOtpParams,
  });
}
