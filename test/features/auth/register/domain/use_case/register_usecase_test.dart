import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/auth/register/domain/entity/register_entity.dart';
import 'package:flower_app/features/auth/register/domain/repo/register_repo.dart';
import 'package:flower_app/features/auth/register/domain/use_case/register_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../support/register_test_support.dart';
import 'register_usecase_test.mocks.dart';

@GenerateMocks([RegisterRepo])
void main() {
  late RegisterRepo registerRepo;
  late RegisterUseCase registerUseCase;

  setUpAll(() {
    registerRepo = MockRegisterRepo();
    registerUseCase = RegisterUseCase(registerRepo);
  });

  final request = validRegisterRequest();
  const dummyErrorMessage = 'Dummy Message';

  group('test use case states', () {
    test('test register use case success state', () async {
      provideDummy<BaseResponse<RegisterEntity>>(fakeRegisterSuccess);
      when(
        registerRepo.register(request),
      ).thenAnswer((_) async => fakeRegisterSuccess);

      final result = await registerUseCase(request);

      expect(result, isA<SuccessResponse<RegisterEntity>>());
      final successResponse = result as SuccessResponse<RegisterEntity>;
      expect(successResponse.data, fakeRegisterEntity);
      verify(registerRepo.register(request)).called(1);
    });
  });

  test('test register use case error state', () async {
    final error = BadResponseError(dummyErrorMessage);
    provideDummy<BaseResponse<RegisterEntity>>(ErrorResponse(appError: error));
    when(
      registerRepo.register(request),
    ).thenAnswer((_) async => ErrorResponse(appError: error));

    final result = await registerUseCase(request);

    expect(result, isA<ErrorResponse<RegisterEntity>>());
    final errorResponse = result as ErrorResponse<RegisterEntity>;
    expect(errorResponse.errorMessage, dummyErrorMessage);
    verify(registerRepo.register(request)).called(1);
  });
}
