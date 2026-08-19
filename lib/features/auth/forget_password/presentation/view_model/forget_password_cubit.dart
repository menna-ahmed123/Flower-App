import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/auth/forget_password/domain/entities/forget_password_entity.dart';
import 'package:flower_app/features/auth/forget_password/domain/entities/forget_password_params.dart';
import 'package:flower_app/features/auth/forget_password/domain/entities/verify_otp_entity.dart';
import 'package:flower_app/features/auth/forget_password/domain/entities/verify_otp_params.dart';
import 'package:flower_app/features/auth/forget_password/domain/use_cases/forget_password_use_case.dart';
import 'package:flower_app/features/auth/forget_password/domain/use_cases/verify_otp_use_case.dart';
import 'package:flower_app/features/auth/forget_password/presentation/view_model/forget_password_event.dart';
import 'package:flower_app/features/auth/forget_password/presentation/view_model/forget_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/reset_password_entity.dart';
import '../../domain/entities/reset_password_params.dart';
import '../../domain/use_cases/reset_password_use_case.dart';

@injectable
class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit(this._forgetPasswordUseCase, this._verifyOtpUseCase,
      this._resetPasswordUseCase)
      : super(ForgetPasswordState.initial());

  final ForgetPasswordUseCase _forgetPasswordUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  void onEvent(ForgetPasswordEvent event) {
    switch (event) {
      case ForgotPasswordSubmitted():
        _forgotPassword(event.params);

      case VerifyOtpSubmitted():
        _verifyOtp(event.params);

      case ResetPasswordSubmitted():
        _resetPassword(event.params);
    }
  }

  Future<void> _forgotPassword(ForgetPasswordParams params) async {
    _emitForgotPasswordLoading(params.email);

    final response = await _forgetPasswordUseCase(forgetPasswordParams: params);

    _emitForgotPasswordResult(response);
  }

  Future<void> _verifyOtp(VerifyOtpParams params) async {
    _emitVerifyOtpLoading();

    final response = await _verifyOtpUseCase(verifyOtpParams: params);

    _emitVerifyOtpResult(response);
  }

  void _emitForgotPasswordLoading(String email) {
    emit(
      state.copyWith(
        email: email,
        forgotPasswordState: state.forgotPasswordState?.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );
  }

  void _emitForgotPasswordResult(BaseResponse<ForgetPasswordEntity> response) {
    switch (response) {
      case SuccessResponse<ForgetPasswordEntity>():
        emit(
          state.copyWith(
            forgotPasswordState: state.forgotPasswordState?.copyWith(
              isLoading: false,
              data: response.data,
            ),
          ),
        );

      case ErrorResponse<ForgetPasswordEntity>():
        emit(
          state.copyWith(
            forgotPasswordState: state.forgotPasswordState?.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
    }
  }

  void _emitVerifyOtpLoading() {
    emit(
      state.copyWith(
        verifyOtpState: state.verifyOtpState?.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );
  }

  void _emitVerifyOtpResult(BaseResponse<VerifyOtpEntity> response) {
    switch (response) {
      case SuccessResponse<VerifyOtpEntity>():
        emit(
          state.copyWith(
            verifyOtpState: state.verifyOtpState?.copyWith(
              isLoading: false,
              data: response.data,
            ),
          ),
        );

      case ErrorResponse<VerifyOtpEntity>():
        emit(
          state.copyWith(
            verifyOtpState: state.verifyOtpState?.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
    }
  }

  Future<void> _resetPassword(ResetPasswordParams params) async {
    _emitResetPasswordLoading();
    final response = await _resetPasswordUseCase(resetPasswordParams: params);
    _emitResetPasswordResult(response);
  }

  void _emitResetPasswordLoading() {
    emit(
      state.copyWith(
        resetPasswordState: state.resetPasswordState?.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );
  }

  void _emitResetPasswordResult(BaseResponse<ResetPasswordEntity> response) {
    switch (response) {
      case SuccessResponse<ResetPasswordEntity>():
        emit(
          state.copyWith(
            resetPasswordState: state.resetPasswordState?.copyWith(
              isLoading: false,
              data: response.data,
            ),
          ),
        );
      case ErrorResponse<ResetPasswordEntity>():
        emit(
          state.copyWith(
            resetPasswordState: state.resetPasswordState?.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
    }
  }
}
