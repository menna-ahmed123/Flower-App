import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/auth/forget_password/domain/entities/forget_password_entity.dart';
import 'package:flower_app/features/auth/forget_password/domain/entities/verify_otp_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/reset_password_entity.dart';

part 'forget_password_state.freezed.dart';

@freezed
abstract class ForgetPasswordState with _$ForgetPasswordState {
  const factory ForgetPasswordState({
    @Default('') String email,
    BaseState<ForgetPasswordEntity>? forgotPasswordState,
    BaseState<VerifyOtpEntity>? verifyOtpState,
    BaseState<ResetPasswordEntity>? resetPasswordState,
  }) = _ForgetPasswordState;

  factory ForgetPasswordState.initial() {
    return const ForgetPasswordState(
      forgotPasswordState: BaseState<ForgetPasswordEntity>(),
      verifyOtpState: BaseState<VerifyOtpEntity>(),
      resetPasswordState: BaseState<ResetPasswordEntity>(),
    );
  }
}
