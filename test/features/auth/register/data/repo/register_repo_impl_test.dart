import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/api_exception.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/auth/register/data/data_source/remote/register_remote_data_source.dart';
import 'package:flower_app/features/auth/register/data/models/register_response.dart';
import 'package:flower_app/features/auth/register/data/repo/register_repo_impl.dart';
import 'package:flower_app/features/auth/register/domain/entity/register_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../support/register_test_support.dart';
import 'register_repo_impl_test.mocks.dart';

@GenerateMocks([RegisterRemoteDataSource])
void main() {
  late RegisterRemoteDataSource remoteDataSource;
  late SafeCall safeCall;
  late RegisterRepositoryImpl repository;

  setUpAll(() {
    remoteDataSource = MockRegisterRemoteDataSource();
    safeCall = SafeCall();
    repository = RegisterRepositoryImpl(remoteDataSource, safeCall);
  });

  final request = validRegisterRequest();

  group('Register', () {
    test(
      'should return SuccessResponse with mapped entity when register succeeds',
      () async {
        provideDummy<BaseResponse<RegisterEntity>>(fakeRegisterSuccess);
        when(
          remoteDataSource.register(request),
        ).thenAnswer((_) async => successfulRegisterResponse());

        final result = await repository.register(request);

        expect(result, isA<SuccessResponse<RegisterEntity>>());
        final successResult = result as SuccessResponse<RegisterEntity>;
        expect(successResult.data.userId, 'user-1');
        expect(successResult.data.email, 'sara@example.com');
        expect(successResult.data.role, 'Customer');
        expect(successResult.data.status, 'Active');
        expect(successResult.data.message, 'Account registered successfully.');
        verify(remoteDataSource.register(request)).called(1);
      },
    );

    test('should return ErrorResponse when data source throws', () async {
      provideDummy<BaseResponse<RegisterEntity>>(fakeRegisterSuccess);
      when(
        remoteDataSource.register(request),
      ).thenThrow(Exception('network down'));

      final result = await repository.register(request);

      expect(result, isA<ErrorResponse<RegisterEntity>>());
    });

    test(
      'should map ApiException to BadResponseError via safeApiCall',
      () async {
        provideDummy<BaseResponse<RegisterEntity>>(fakeRegisterSuccess);
        when(
          remoteDataSource.register(request),
        ).thenThrow(ApiException(message: 'Sign up failed'));

        final result = await repository.register(request);

        expect(result, isA<ErrorResponse<RegisterEntity>>());
        final failure = result as ErrorResponse<RegisterEntity>;
        expect(failure.appError, isA<BadResponseError>());
        expect(failure.errorMessage, 'Sign up failed');
      },
    );

    test('should return ErrorResponse when isSuccess is false', () async {
      provideDummy<BaseResponse<RegisterEntity>>(fakeRegisterSuccess);
      when(remoteDataSource.register(request)).thenAnswer(
        (_) async => RegisterResponse(
          isSuccess: false,
          statusCode: 400,
          message: 'Sign up failed',
          data: RegisterData(
            userId: 'user-1',
            email: 'sara@example.com',
            role: 'Customer',
            status: 'Active',
          ),
        ),
      );

      final result = await repository.register(request);

      expect(result, isA<ErrorResponse<RegisterEntity>>());
      final failure = result as ErrorResponse<RegisterEntity>;
      expect(failure.errorMessage, 'Sign up failed');
    });

    test(
      'should return ErrorResponse when operation payload has no data',
      () async {
        provideDummy<BaseResponse<RegisterEntity>>(fakeRegisterSuccess);
        when(remoteDataSource.register(request)).thenAnswer(
          (_) async => RegisterResponse(
            isSuccess: true,
            statusCode: 201,
            message: 'Missing data',
          ),
        );

        final result = await repository.register(request);

        expect(result, isA<ErrorResponse<RegisterEntity>>());
        final failure = result as ErrorResponse<RegisterEntity>;
        expect(failure.errorMessage, 'Missing data');
      },
    );
  });
}
