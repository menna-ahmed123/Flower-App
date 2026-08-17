import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/forget_password/domain/entities/forget_password_entity.dart';
import 'package:flower_app/features/forget_password/domain/entities/reset_password_entity.dart';
import 'package:flower_app/features/forget_password/domain/entities/reset_password_params.dart';
import 'package:flower_app/features/forget_password/domain/entities/verify_otp_entity.dart';
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
void main() {
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

  group('Reset Password Cubit', () {
    test(
      'should emit loading state when reset password is submitted',
      () async {
        final params = ResetPasswordParams(
          resetToken: 'test-reset-token',
          newPassword: 'Password123',
          confirmPassword: 'Password123',
        );

        when(mockResetPasswordUseCase(resetPasswordParams: params)).thenAnswer(
          (_) async => SuccessResponse<ResetPasswordEntity>(
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
      },
    );

    test('should emit success state when reset password succeeds', () async {
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
        mockResetPasswordUseCase(resetPasswordParams: params),
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

      verify(mockResetPasswordUseCase(resetPasswordParams: params)).called(1);
    });

    test('should emit error state when reset password fails', () async {
      final params = ResetPasswordParams(
        resetToken: 'test-reset-token',
        newPassword: 'Password123',
        confirmPassword: 'WrongPassword',
      );

      final response = ErrorResponse<ResetPasswordEntity>(
        appError: BadResponseError('Password reset failed'),
      );

      when(
        mockResetPasswordUseCase(resetPasswordParams: params),
      ).thenAnswer((_) async => response);

      cubit.onEvent(ResetPasswordSubmitted(params: params));

      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.resetPasswordState?.isLoading, false);

      expect(
        cubit.state.resetPasswordState?.errorMessage,
        'Password reset failed',
      );

      verify(mockResetPasswordUseCase(resetPasswordParams: params)).called(1);
    });
  });
}
