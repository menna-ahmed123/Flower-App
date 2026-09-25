import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/auth/forget_password/domain/entities/reset_password_entity.dart';
import 'package:flower_app/features/auth/forget_password/domain/entities/reset_password_params.dart';
import 'package:flower_app/features/auth/forget_password/domain/repos/forget_password_repo.dart';
import 'package:flower_app/features/auth/forget_password/domain/use_cases/reset_password_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'reset_password_use_case_test.mocks.dart';

@GenerateMocks([ForgetPasswordRepo])
void main() {
  provideDummy<BaseResponse<ResetPasswordEntity>>(
    SuccessResponse(
      ResetPasswordEntity(success: true, message: 'Dummy response'),
    ),
  );

  late MockForgetPasswordRepo mockForgetPasswordRepo;
  late ResetPasswordUseCase useCase;
  late ResetPasswordParams params;
  late SuccessResponse<ResetPasswordEntity> response;

  setUp(() {
    mockForgetPasswordRepo = MockForgetPasswordRepo();
    useCase = ResetPasswordUseCase(forgetPasswordRepo: mockForgetPasswordRepo);

    params = ResetPasswordParams(
      otpToken: 'otp-token',
      password: 'Password123',
      confirmPassword: 'Password123',
    );

    response = SuccessResponse<ResetPasswordEntity>(
      ResetPasswordEntity(
        success: true,
        message: 'Password reset successfully',
      ),
    );
  });

  test('should call repository with correct params', () async {
    when(
      mockForgetPasswordRepo.resetPassword(resetPasswordParams: params),
    ).thenAnswer((_) async => response);

    await useCase(resetPasswordParams: params);

    verify(
      mockForgetPasswordRepo.resetPassword(resetPasswordParams: params),
    ).called(1);
  });

  test('should return repository response', () async {
    when(
      mockForgetPasswordRepo.resetPassword(resetPasswordParams: params),
    ).thenAnswer((_) async => response);

    final result = await useCase(resetPasswordParams: params);

    expect(result, response);
  });
}
