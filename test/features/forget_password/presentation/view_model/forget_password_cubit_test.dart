import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/forget_password/domain/entities/forget_password_entity.dart';
import 'package:flower_app/features/forget_password/domain/entities/forget_password_params.dart';
import 'package:flower_app/features/forget_password/domain/entities/reset_password_entity.dart';
import 'package:flower_app/features/forget_password/domain/entities/reset_password_params.dart';
import 'package:flower_app/features/forget_password/domain/entities/verify_otp_entity.dart';
import 'package:flower_app/features/forget_password/domain/entities/verify_otp_params.dart';
import 'package:flower_app/features/forget_password/domain/use_cases/forget_password_use_case.dart';
import 'package:flower_app/features/forget_password/domain/use_cases/reset_password_use_case.dart';
import 'package:flower_app/features/forget_password/domain/use_cases/verify_otp_use_case.dart';
import 'package:flower_app/features/forget_password/presentation/view_model/forget_password_cubit.dart';
import 'package:flower_app/features/forget_password/presentation/view_model/forget_password_event.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'forget_password_cubit_test.mocks.dart';

@GenerateMocks([ForgetPasswordUseCase, VerifyOtpUseCase, ResetPasswordUseCase])
void main() => _runTests();

void _runTests() {
  _registerDummies();

  late MockForgetPasswordUseCase mockForgetPasswordUseCase;
  late MockVerifyOtpUseCase mockVerifyOtpUseCase;
  late MockResetPasswordUseCase mockResetPasswordUseCase;
  late ForgetPasswordCubit cubit;

  setUp(() {
    mockForgetPasswordUseCase = MockForgetPasswordUseCase();
    mockVerifyOtpUseCase = MockVerifyOtpUseCase();
    mockResetPasswordUseCase = MockResetPasswordUseCase();

    cubit = ForgetPasswordCubit(
      mockForgetPasswordUseCase,
      mockVerifyOtpUseCase,
      mockResetPasswordUseCase,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  _registerForgetPasswordTests(() => cubit, () => mockForgetPasswordUseCase);
  _registerVerifyOtpTests(() => cubit, () => mockVerifyOtpUseCase);
  _registerResetPasswordTests(() => cubit, () => mockResetPasswordUseCase);
}

void _registerDummies() {
  provideDummy<BaseResponse<ForgetPasswordEntity>>(
    SuccessResponse<ForgetPasswordEntity>(
      ForgetPasswordEntity(cooldownRemainingSeconds: 30),
    ),
  );

  provideDummy<BaseResponse<VerifyOtpEntity>>(
    SuccessResponse<VerifyOtpEntity>(
      VerifyOtpEntity(
        status: 'verified',
        resetToken: 'test-reset-token',
        expiresAtUtc: DateTime.utc(2026, 8, 17, 4),
      ),
    ),
  );

  provideDummy<BaseResponse<ResetPasswordEntity>>(
    SuccessResponse<ResetPasswordEntity>(
      ResetPasswordEntity(
        isSuccess: true,
        statusCode: 200,
        message: 'Password reset successfully',
        errors: null,
      ),
    ),
  );
}

void _registerForgetPasswordTests(ForgetPasswordCubit Function() getCubit,
    MockForgetPasswordUseCase Function() getUseCase,) {
  _registerForgotPasswordLoadingTest(getCubit, getUseCase);
  _registerForgotPasswordSuccessTest(getCubit, getUseCase);
  _registerForgotPasswordErrorTest(getCubit, getUseCase);
}

void _registerForgotPasswordLoadingTest(ForgetPasswordCubit Function() getCubit,
    MockForgetPasswordUseCase Function() getUseCase,) {
  test('should emit loading state when forgot password is submitted', () async {
    final cubit = getCubit();
    final useCase = getUseCase();
    final params = ForgetPasswordParams(email: 'test@gmail.com');

    when(useCase(forgetPasswordParams: params)).thenAnswer(
          (_) async =>
          SuccessResponse<ForgetPasswordEntity>(
            ForgetPasswordEntity(cooldownRemainingSeconds: 30),
          ),
    );

    cubit.onEvent(ForgotPasswordSubmitted(params: params));

    expect(cubit.state.email, 'test@gmail.com');
    expect(cubit.state.forgotPasswordState?.isLoading, true);
    expect(cubit.state.forgotPasswordState?.errorMessage, '');
  });
}

void _registerForgotPasswordSuccessTest(ForgetPasswordCubit Function() getCubit,
    MockForgetPasswordUseCase Function() getUseCase,) {
  test('should emit success state when forgot password succeeds', () async {
    final cubit = getCubit();
    final useCase = getUseCase();
    final params = ForgetPasswordParams(email: 'test@gmail.com');

    final response = SuccessResponse<ForgetPasswordEntity>(
      ForgetPasswordEntity(cooldownRemainingSeconds: 30),
    );

    when(
      useCase(forgetPasswordParams: params),
    ).thenAnswer((_) async => response);

    cubit.onEvent(ForgotPasswordSubmitted(params: params));

    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.email, 'test@gmail.com');
    expect(cubit.state.forgotPasswordState?.isLoading, false);
    expect(cubit.state.forgotPasswordState?.data?.cooldownRemainingSeconds, 30);
    expect(cubit.state.forgotPasswordState?.errorMessage, '');

    verify(useCase(forgetPasswordParams: params)).called(1);
  });
}

void _registerForgotPasswordErrorTest(ForgetPasswordCubit Function() getCubit,
    MockForgetPasswordUseCase Function() getUseCase,) {
  test('should emit error state when forgot password fails', () async {
    final cubit = getCubit();
    final useCase = getUseCase();
    final params = ForgetPasswordParams(email: 'invalid@email.com');

    final response = ErrorResponse<ForgetPasswordEntity>(
      appError: BadResponseError('Invalid email'),
    );

    when(
      useCase(forgetPasswordParams: params),
    ).thenAnswer((_) async => response);

    cubit.onEvent(ForgotPasswordSubmitted(params: params));

    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.email, 'invalid@email.com');
    expect(cubit.state.forgotPasswordState?.isLoading, false);
    expect(cubit.state.forgotPasswordState?.errorMessage, 'Invalid email');

    verify(useCase(forgetPasswordParams: params)).called(1);
  });
}

void _registerVerifyOtpTests(ForgetPasswordCubit Function() getCubit,
    MockVerifyOtpUseCase Function() getUseCase,) {
  _registerVerifyOtpLoadingTest(getCubit, getUseCase);
  _registerVerifyOtpSuccessTest(getCubit, getUseCase);
  _registerVerifyOtpErrorTest(getCubit, getUseCase);
}

void _registerVerifyOtpLoadingTest(ForgetPasswordCubit Function() getCubit,
    MockVerifyOtpUseCase Function() getUseCase,) {
  test('should emit loading state when verify OTP is submitted', () async {
    final cubit = getCubit();
    final useCase = getUseCase();
    final params = VerifyOtpParams(email: 'test@gmail.com', otp: '123456');

    when(useCase(verifyOtpParams: params)).thenAnswer(
          (_) async =>
          SuccessResponse<VerifyOtpEntity>(
            VerifyOtpEntity(
              status: 'verified',
              resetToken: 'test-reset-token',
              expiresAtUtc: DateTime.utc(2026, 8, 17, 4),
            ),
          ),
    );

    cubit.onEvent(VerifyOtpSubmitted(params: params));

    expect(cubit.state.verifyOtpState?.isLoading, true);
    expect(cubit.state.verifyOtpState?.errorMessage, '');
  });
}

void _registerVerifyOtpSuccessTest(ForgetPasswordCubit Function() getCubit,
    MockVerifyOtpUseCase Function() getUseCase,) {
  test('should emit success state when verify OTP succeeds', () async {
    final cubit = getCubit();
    final useCase = getUseCase();
    final params = VerifyOtpParams(email: 'test@gmail.com', otp: '123456');

    final response = SuccessResponse<VerifyOtpEntity>(
      VerifyOtpEntity(
        status: 'verified',
        resetToken: 'test-reset-token',
        expiresAtUtc: DateTime.utc(2026, 8, 17, 4),
      ),
    );

    when(useCase(verifyOtpParams: params)).thenAnswer((_) async => response);

    cubit.onEvent(VerifyOtpSubmitted(params: params));

    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.verifyOtpState?.isLoading, false);
    expect(cubit.state.verifyOtpState?.data?.status, 'verified');
    expect(cubit.state.verifyOtpState?.data?.resetToken, 'test-reset-token');
    expect(
      cubit.state.verifyOtpState?.data?.expiresAtUtc,
      DateTime.utc(2026, 8, 17, 4),
    );
    expect(cubit.state.verifyOtpState?.errorMessage, '');

    verify(useCase(verifyOtpParams: params)).called(1);
  });
}

void _registerVerifyOtpErrorTest(ForgetPasswordCubit Function() getCubit,
    MockVerifyOtpUseCase Function() getUseCase,) {
  test('should emit error state when verify OTP fails', () async {
    final cubit = getCubit();
    final useCase = getUseCase();
    final params = VerifyOtpParams(email: 'test@gmail.com', otp: '123456');

    final response = ErrorResponse<VerifyOtpEntity>(
      appError: BadResponseError('Invalid OTP'),
    );

    when(useCase(verifyOtpParams: params)).thenAnswer((_) async => response);

    cubit.onEvent(VerifyOtpSubmitted(params: params));

    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.verifyOtpState?.isLoading, false);
    expect(cubit.state.verifyOtpState?.errorMessage, 'Invalid OTP');

    verify(useCase(verifyOtpParams: params)).called(1);
  });
}

void _registerResetPasswordTests(ForgetPasswordCubit Function() getCubit,
    MockResetPasswordUseCase Function() getUseCase,) {
  _registerResetPasswordLoadingTest(getCubit, getUseCase);
  _registerResetPasswordSuccessTest(getCubit, getUseCase);
  _registerResetPasswordErrorTest(getCubit, getUseCase);
}

void _registerResetPasswordLoadingTest(ForgetPasswordCubit Function() getCubit,
    MockResetPasswordUseCase Function() getUseCase,) {
  test('should emit loading state when reset password is submitted', () async {
    final cubit = getCubit();
    final useCase = getUseCase();
    final params = ResetPasswordParams(
      resetToken: 'test-reset-token',
      newPassword: 'Password123',
      confirmPassword: 'Password123',
    );

    when(useCase(resetPasswordParams: params)).thenAnswer(
          (_) async =>
          SuccessResponse<ResetPasswordEntity>(
            ResetPasswordEntity(
              isSuccess: true,
              statusCode: 200,
              message: 'Password reset successfully',
              errors: null,
            ),
          ),
    );

    cubit.onEvent(ResetPasswordSubmitted(params: params));

    expect(cubit.state.resetPasswordState?.isLoading, true);
    expect(cubit.state.resetPasswordState?.errorMessage, '');
  });
}

void _registerResetPasswordSuccessTest(ForgetPasswordCubit Function() getCubit,
    MockResetPasswordUseCase Function() getUseCase,) {
  test('should emit success state when reset password succeeds', () async {
    final cubit = getCubit();
    final useCase = getUseCase();
    final params = ResetPasswordParams(
      resetToken: 'test-reset-token',
      newPassword: 'Password123',
      confirmPassword: 'Password123',
    );

    final response = SuccessResponse<ResetPasswordEntity>(
      ResetPasswordEntity(
        isSuccess: true,
        statusCode: 200,
        message: 'Password reset successfully',
        errors: null,
      ),
    );
    when(
      useCase(resetPasswordParams: params),
    ).thenAnswer((_) async => response);

    cubit.onEvent(ResetPasswordSubmitted(params: params));

    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.resetPasswordState?.isLoading, false);
    expect(cubit.state.resetPasswordState?.data?.isSuccess, true);
    expect(cubit.state.resetPasswordState?.data?.statusCode, 200);
    expect(
      cubit.state.resetPasswordState?.data?.message,
      'Password reset successfully',
    );
    expect(cubit.state.resetPasswordState?.errorMessage, '');

    verify(useCase(resetPasswordParams: params)).called(1);
  });
}

void _registerResetPasswordErrorTest(ForgetPasswordCubit Function() getCubit,
    MockResetPasswordUseCase Function() getUseCase,) {
  test('should emit error state when reset password fails', () async {
    final cubit = getCubit();
    final useCase = getUseCase();
    final params = ResetPasswordParams(
      resetToken: 'test-reset-token',
      newPassword: 'Password123',
      confirmPassword: 'WrongPassword',
    );

    final response = ErrorResponse<ResetPasswordEntity>(
      appError: BadResponseError('Password reset failed'),
    );

    when(
      useCase(resetPasswordParams: params),
    ).thenAnswer((_) async => response);

    cubit.onEvent(ResetPasswordSubmitted(params: params));

    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.resetPasswordState?.isLoading, false);
    expect(
        cubit.state.resetPasswordState?.errorMessage, 'Password reset failed');

    verify(useCase(resetPasswordParams: params)).called(1);
  });
}
