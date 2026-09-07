import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/auth/login/data/models/login_request.dart';
import 'package:flower_app/features/auth/login/domain/entity/auth_entity.dart';
import 'package:flower_app/features/auth/login/domain/repo/auth_repo.dart';
import 'package:flower_app/features/auth/login/domain/use_case/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_address_use_case_test.mocks.dart';

@GenerateMocks([AuthRepo])
void main() {
  late AuthRepo authRepo;
  late LoginUseCase loginUseCase;

  setUp(() {
    authRepo = MockAuthRepo();
    loginUseCase = LoginUseCase(authRepo);
  });

  final request = LoginRequest(
    email: 'test@gmail.com',
    password: '123456',
  );

  final authEntity = AuthEntity(
    accessToken: 'access-token',
    refreshToken: 'refresh-token',
    role: 'Customer',
  );

  const String dummyErrorMessage = 'Dummy Message';

  group('test login use case states', () {
    test(
      'test login use case success state',
      () async {
        // Arrange
        provideDummy<BaseResponse<AuthEntity>>(
          SuccessResponse<AuthEntity>(authEntity),
        );

        when(
          authRepo.signIn(request),
        ).thenAnswer(
          (_) async => SuccessResponse<AuthEntity>(authEntity),
        );

        // Act
        final result = await loginUseCase(request);

        // Assert
        expect(
          result,
          isA<SuccessResponse<AuthEntity>>(),
        );

        final successResponse =
            result as SuccessResponse<AuthEntity>;

        expect(
          successResponse.data,
          authEntity,
        );

        verify(
          authRepo.signIn(request),
        ).called(1);
      },
    );

    test(
      'test login use case error state',
      () async {
        // Arrange
        final error = BadResponseError(dummyErrorMessage);

        provideDummy<BaseResponse<AuthEntity>>(
          ErrorResponse<AuthEntity>(
            appError: error,
          ),
        );

        when(
          authRepo.signIn(request),
        ).thenAnswer(
          (_) async => ErrorResponse<AuthEntity>(
            appError: error,
          ),
        );

        // Act
        final result = await loginUseCase(request);

        // Assert
        expect(
          result,
          isA<ErrorResponse<AuthEntity>>(),
        );

        final errorResponse =
            result as ErrorResponse<AuthEntity>;

        expect(
          errorResponse.errorMessage,
          dummyErrorMessage,
        );

        verify(
          authRepo.signIn(request),
        ).called(1);
      },
    );
  });
}