import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
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
      await _testForgetPasswordSuccess(
        forgetPasswordUseCase,
        mockForgetPasswordRepo,
      );
    });

    test('should return error when forget password fails', () async {
      await _testForgetPasswordError(
        forgetPasswordUseCase,
        mockForgetPasswordRepo,
      );
    });
  });
}

Future<void> _testForgetPasswordSuccess(
  ForgetPasswordUseCase forgetPasswordUseCase,
  MockForgetPasswordRepo mockForgetPasswordRepo,
) async {
  // Arrange
  final forgetPasswordParams = ForgetPasswordParams(email: 'test@example.com');

  final successResponse = SuccessResponse<ForgetPasswordEntity>(
    ForgetPasswordEntity(cooldownRemainingSeconds: 30),
  );

  when(
    mockForgetPasswordRepo.forgetPassword(
      forgetPasswordParams: forgetPasswordParams,
    ),
  ).thenAnswer((_) async => successResponse);

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
}

Future<void> _testForgetPasswordError(
  ForgetPasswordUseCase forgetPasswordUseCase,
  MockForgetPasswordRepo mockForgetPasswordRepo,
) async {
  // Arrange
  final forgetPasswordParams = ForgetPasswordParams(email: 'test@example.com');

  final errorResponse = ErrorResponse<ForgetPasswordEntity>(
    appError: BadResponseError('Invalid email'),
  );

  when(
    mockForgetPasswordRepo.forgetPassword(
      forgetPasswordParams: forgetPasswordParams,
    ),
  ).thenAnswer((_) async => errorResponse);

  // Act
  final result = await forgetPasswordUseCase(
    forgetPasswordParams: forgetPasswordParams,
  );

  // Assert
  expect(result, isA<ErrorResponse<ForgetPasswordEntity>>());

  expect(
    (result as ErrorResponse<ForgetPasswordEntity>).errorMessage,
    'Invalid email',
  );
}
