import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/auth/forget_password/domain/entities/forget_password_entity.dart';
import 'package:flower_app/features/auth/forget_password/domain/entities/forget_password_params.dart';
import 'package:flower_app/features/auth/forget_password/domain/repos/forget_password_repo.dart';
import 'package:flower_app/features/auth/forget_password/domain/use_cases/forget_password_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'forget_password_use_case_test.mocks.dart';

@GenerateMocks([ForgetPasswordRepo])
void main() => _runTests();

void _runTests() {
  _registerDummy();

  late ForgetPasswordUseCase forgetPasswordUseCase;
  late MockForgetPasswordRepo mockForgetPasswordRepo;

  setUp(() {
    mockForgetPasswordRepo = MockForgetPasswordRepo();

    forgetPasswordUseCase = ForgetPasswordUseCase(
      forgetPasswordRepo: mockForgetPasswordRepo,
    );
  });

  _registerSuccessTest(
    () => forgetPasswordUseCase,
    () => mockForgetPasswordRepo,
  );

  _registerErrorTest(() => forgetPasswordUseCase, () => mockForgetPasswordRepo);
}

void _registerDummy() {
  provideDummy<BaseResponse<ForgetPasswordEntity>>(
    SuccessResponse<ForgetPasswordEntity>(
      ForgetPasswordEntity(cooldownRemainingSeconds: 30),
    ),
  );
}

void _registerSuccessTest(
  ForgetPasswordUseCase Function() getUseCase,
  MockForgetPasswordRepo Function() getRepo,
) {
  test('should return success when forget password succeeds', () async {
    final useCase = getUseCase();
    final repo = getRepo();

    final params = ForgetPasswordParams(email: 'test@example.com');

    final response = SuccessResponse<ForgetPasswordEntity>(
      ForgetPasswordEntity(cooldownRemainingSeconds: 30),
    );

    when(
      repo.forgetPassword(forgetPasswordParams: params),
    ).thenAnswer((_) async => response);

    final result = await useCase(forgetPasswordParams: params);

    expect(result, isA<SuccessResponse<ForgetPasswordEntity>>());

    final successResult = result as SuccessResponse<ForgetPasswordEntity>;

    expect(successResult.data.cooldownRemainingSeconds, 30);
  });
}

void _registerErrorTest(
  ForgetPasswordUseCase Function() getUseCase,
  MockForgetPasswordRepo Function() getRepo,
) {
  test('should return error when forget password fails', () async {
    final useCase = getUseCase();
    final repo = getRepo();

    final params = ForgetPasswordParams(email: 'test@example.com');

    final response = ErrorResponse<ForgetPasswordEntity>(
      appError: BadResponseError('Invalid email'),
    );

    when(
      repo.forgetPassword(forgetPasswordParams: params),
    ).thenAnswer((_) async => response);

    final result = await useCase(forgetPasswordParams: params);

    expect(result, isA<ErrorResponse<ForgetPasswordEntity>>());

    final errorResult = result as ErrorResponse<ForgetPasswordEntity>;

    expect(errorResult.errorMessage, 'Invalid email');
  });
}
