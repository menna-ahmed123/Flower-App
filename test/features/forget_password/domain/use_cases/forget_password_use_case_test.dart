import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/forget_password/domain/entities/forget_password_entity.dart';
import 'package:flower_app/features/forget_password/domain/entities/forget_password_params.dart';
import 'package:flower_app/features/forget_password/domain/repos/forget_password_repo.dart';
import 'package:flower_app/features/forget_password/domain/use_cases/forget_password_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'forget_password_use_case_test.mocks.dart';

@GenerateMocks([ForgetPasswordRepo])
void main() {
  provideDummy<BaseResponse<ForgetPasswordEntity>>(
    SuccessResponse<ForgetPasswordEntity>(
      ForgetPasswordEntity(cooldownRemainingSeconds: 30),
    ),
  );

  late ForgetPasswordUseCase forgetPasswordUseCase;
  late MockForgetPasswordRepo mockForgetPasswordRepo;

  setUp(() {
    mockForgetPasswordRepo = MockForgetPasswordRepo();

    forgetPasswordUseCase = ForgetPasswordUseCase(
      forgetPasswordRepo: mockForgetPasswordRepo,
    );
  });

  group('ForgetPasswordUseCase Tests', () {
    test('should return success when forget password succeeds', () async {
      // Arrange
      final forgetPasswordParams = ForgetPasswordParams(
        email: 'test@example.com',
      );

      when(
        mockForgetPasswordRepo.forgetPassword(
          forgetPasswordParams: forgetPasswordParams,
        ),
      ).thenAnswer(
        (_) async => SuccessResponse<ForgetPasswordEntity>(
          ForgetPasswordEntity(cooldownRemainingSeconds: 30),
        ),
      );

      // Act
      final result = await forgetPasswordUseCase(
        forgetPasswordParams: forgetPasswordParams,
      );

      // Assert
      expect(result, isA<SuccessResponse<ForgetPasswordEntity>>());

      expect(
        (result as SuccessResponse<ForgetPasswordEntity>)
            .data
            .cooldownRemainingSeconds,
        30,
      );
    });
  });
}
