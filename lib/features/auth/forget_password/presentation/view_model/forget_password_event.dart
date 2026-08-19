import 'package:flower_app/features/auth/forget_password/domain/entities/forget_password_params.dart';
import 'package:flower_app/features/auth/forget_password/domain/entities/verify_otp_params.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/reset_password_params.dart';

part 'forget_password_event.freezed.dart';

@freezed
sealed class ForgetPasswordEvent with _$ForgetPasswordEvent {
  const factory ForgetPasswordEvent.forgotPassword({
    required ForgetPasswordParams params,
  }) = ForgotPasswordSubmitted;

  const factory ForgetPasswordEvent.verifyOtp({
    required VerifyOtpParams params,
  }) = VerifyOtpSubmitted;

  const factory ForgetPasswordEvent.resetPassword({
    required ResetPasswordParams params,
  }) = ResetPasswordSubmitted;
}
