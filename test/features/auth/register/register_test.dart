import 'package:flower_app/core/base/base_response.dart';
import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/di/di.dart';
import 'package:flower_app/core/errors/api_exception.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/core/errors/error_parser.dart';
import 'package:flower_app/core/helpers/app_validators.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/auth/register/api/dio_register_api.dart';
import 'package:flower_app/features/auth/register/data/data_sources/register_remote_data_source.dart';
import 'package:flower_app/features/auth/register/data/data_sources/register_remote_data_source_impl.dart';
import 'package:flower_app/features/auth/register/data/repositories/register_repository_impl.dart';
import 'package:flower_app/features/auth/register/data/models/register_result_dto.dart';
import 'package:flower_app/features/auth/register/data/mappers/register_result_mapper.dart';
import 'package:flower_app/features/auth/register/domain/models/register_result.dart';
import 'package:flower_app/features/auth/register/domain/models/register_request.dart';
import 'package:flower_app/features/auth/register/domain/repositories/register_repository.dart';
import 'package:flower_app/features/auth/register/domain/use_cases/register_use_case.dart';
import 'package:flower_app/features/auth/register/domain/use_cases/register_use_case_impl.dart';
import 'package:flower_app/features/auth/register/presentation/intent/register_intent.dart';
import 'package:flower_app/features/auth/register/presentation/view_model/register_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/register_test_support.dart';

void main() {
  signupRequiredFieldValidatorGroup();
  signupPasswordMessagingGroup();
  registerRequestGroup();
  registerResultGroup();
  submitIntentGroup();
  dioValidationParsingGroup();
  apiValidationParsingGroup();
  dioRegisterApiGroup();
  registerRemoteDataSourceGroup();
  registerRepositoryGroup();
  registerUseCaseGroup();
  registerDependencyInjectionGroup();
}

void signupRequiredFieldValidatorGroup() {
  group('Signup required-field validators', () {
    test('rejects empty required fields', () {
      expect(
        AppValidators.requiredField('', field: AppString.firstName),
        AppString.fieldIsRequired(AppString.firstName),
      );
      expect(AppValidators.emailValidator(''), AppString.pleaseEnterYourEmail);
      expect(AppValidators.passwordValidator(''), AppString.passwordIsRequired);
    });
  });
}

void signupPasswordMessagingGroup() {
  group('Signup password validators', () {
    test('uses distinct password messaging', () {
      expect(
        AppValidators.passwordValidator('password'),
        AppString.passwordRequirement,
      );
      expect(
        AppValidators.registrationPasswordValidator('password'),
        AppString.registrationPasswordRequirement,
      );
    });
  });
}

void registerRequestGroup() {
  group('RegisterRequest', () {
    test('supports value equality', () {
      expect(validRegisterRequest(), equals(validRegisterRequest()));
      expect(
        validRegisterRequest(),
        isNot(equals(validRegisterRequest(email: 'other@example.com'))),
      );
    });
  });
}

void registerResultGroup() {
  group('RegisterResultDto', () {
    test('parses API contract', () {
      final dto = RegisterResultDto.fromOperationJson({
        'message': 'Account registered successfully.',
        'data': {
          'userId': 'user-1',
          'email': 'user@example.com',
          'role': 'Customer',
          'status': 'Active',
        },
      });
      final result = RegisterResultMapper.toDomain(dto);
      expect(result.userId, 'user-1');
      expect(result.email, 'user@example.com');
    });
  });
}

void submitIntentGroup() {
  group('SubmitRegisterIntent', () {
    test('is parameterless', () {
      expect(
        const SubmitRegisterIntent(),
        equals(const SubmitRegisterIntent()),
      );
    });
  });
}

void dioValidationParsingGroup() {
  group('Validation error parsing dio', () {
    test('maps Dio 422 field errors', () {
      final error = errorParser(dioEmailAlreadyRegisteredException());
      expect(error, isA<BadResponseError>());
      expect(error.message, contains('Email already registered'));
    });
  });
}

DioException dioEmailAlreadyRegisteredException() {
  return DioException(
    requestOptions: RequestOptions(path: ApiEndpoints.register),
    type: DioExceptionType.badResponse,
    response: Response(
      requestOptions: RequestOptions(path: ApiEndpoints.register),
      statusCode: 422,
      data: {
        'errors': {
          'Email': ['Email already registered'],
        },
      },
    ),
  );
}

void apiValidationParsingGroup() {
  group('Validation error parsing api', () {
    test('maps ApiException field errors', () {
      final error = errorParser(
        ApiException(
          message: 'Customer registration validation failed.',
          statusCode: 422,
          errors: {
            'Email': ['Email already registered'],
          },
        ),
      );
      expect(error, isA<BadResponseError>());
    });
  });
}

void dioRegisterApiGroup() {
  group('DioRegisterApi', () {
    testPostsOpenApiBody();
    testMapsMaleGender();
    testThrowsWhenPayloadHasNoData();
    testThrowsWhenIsSuccessFalse();
    testThrowsWhenIsSuccessMissing();
  });
}

void registerRemoteDataSourceGroup() {
  group('RegisterRemoteDataSourceImpl', () {
    testDelegatesToApi();
    testPropagatesApiFailures();
  });
}

void registerRepositoryGroup() {
  group('RegisterRepositoryImpl', () {
    testRepositorySuccessResponse();
    testRepositoryErrorResponse();
    testRepositoryApiExceptionResponse();
    testRepositoryPreservesRegisterResult();
  });
}

void registerUseCaseGroup() {
  group('RegisterUseCaseImpl', () {
    testUseCaseDelegatesToRepository();
    testUseCasePropagatesRepositoryFailure();
  });
}

void testPostsOpenApiBody() {
  test('posts OpenAPI body and parses operation result', () async {
    final adapter = successAdapter();
    final result = await buildRegisterRemoteDataSource(
      adapter,
    ).register(validRegisterRequest());
    expect(adapter.lastOptions?.path, ApiEndpoints.register);
    expect(adapter.lastOptions?.method, 'POST');
    expect(adapter.lastData, expectedFemaleBody());
    expect(result.userId, 'user-1');
    expect(result.message, 'Account registered successfully.');
  });
}

void testMapsMaleGender() {
  test('maps Male gender for OpenAPI contract', () async {
    final adapter = RecordingAdapter(201, {
      'isSuccess': true,
      'data': {
        'userId': 'user-2',
        'email': 'sara@example.com',
        'role': 'Customer',
        'status': 'Active',
      },
    });
    await buildRegisterRemoteDataSource(
      adapter,
    ).register(validRegisterRequest(gender: Gender.male));
    expect((adapter.lastData as Map)['gender'], 'Male');
  });
}

void testThrowsWhenPayloadHasNoData() {
  test('throws ApiException when operation payload has no data', () async {
    final api = buildRegisterRemoteDataSource(
      RecordingAdapter(201, {
        'isSuccess': true,
        'statusCode': 201,
        'message': 'Missing data',
      }),
    );
    expect(
      () => api.register(validRegisterRequest()),
      throwsA(
        isA<ApiException>().having((e) => e.message, 'message', 'Missing data'),
      ),
    );
  });
}

void testThrowsWhenIsSuccessFalse() {
  test('throws ApiException when isSuccess is false', () async {
    final api = buildRegisterRemoteDataSource(
      RecordingAdapter(200, {
        'isSuccess': false,
        'message': 'Sign up failed',
        'data': {
          'userId': 'user-1',
          'email': 'sara@example.com',
          'role': 'Customer',
          'status': 'Active',
        },
      }),
    );
    expect(
      () => api.register(validRegisterRequest()),
      throwsA(isA<ApiException>()),
    );
  });
}

RecordingAdapter isSuccessMissingAdapter() {
  return RecordingAdapter(200, {
    'message': 'Registration failed',
    'data': {
      'userId': 'user-1',
      'email': 'sara@example.com',
      'role': 'Customer',
      'status': 'Active',
    },
  });
}

void testThrowsWhenIsSuccessMissing() {
  test('throws ApiException when isSuccess is omitted', () async {
    final api = buildRegisterRemoteDataSource(isSuccessMissingAdapter());
    expect(
      () => api.register(validRegisterRequest()),
      throwsA(
        isA<ApiException>().having(
          (e) => e.message,
          'message',
          'Registration failed',
        ),
      ),
    );
  });
}

void testDelegatesToApi() {
  test('delegates register call to DioRegisterApi', () async {
    final api = FakeDioRegisterApi();
    final dataSource = RegisterRemoteDataSourceImpl(api);
    final result = await dataSource.register(validRegisterRequest());
    expect(api.callCount, 1);
    expect(api.lastRequest?.email, 'sara@example.com');
    expect(result.userId, 'user-1');
  });
}

void testPropagatesApiFailures() {
  test('propagates DioRegisterApi failures', () async {
    final api = FakeDioRegisterApi()..errorToThrow = Exception('api down');
    final dataSource = RegisterRemoteDataSourceImpl(api);
    expect(
      () => dataSource.register(validRegisterRequest()),
      throwsA(isA<Exception>()),
    );
    expect(api.callCount, 1);
  });
}

void testRepositorySuccessResponse() {
  test('returns SuccessResponse when data source succeeds', () async {
    final dataSource = FakeRegisterRemoteDataSource();
    final repository = RegisterRepositoryImpl(dataSource, SafeCall());
    final response = await repository.register(validRegisterRequest());
    expect(dataSource.callCount, 1);
    expect(response, isA<SuccessResponse<RegisterResult>>());
  });
}

void testRepositoryErrorResponse() {
  test('returns ErrorResponse when data source throws', () async {
    final dataSource = FakeRegisterRemoteDataSource()
      ..errorToThrow = Exception('network down');
    final repository = RegisterRepositoryImpl(dataSource, SafeCall());
    final response = await repository.register(validRegisterRequest());
    expect(response, isA<ErrorResponse<RegisterResult>>());
  });
}

void testRepositoryApiExceptionResponse() {
  test('maps ApiException to BadResponseError via safeApiCall', () async {
    final dataSource = FakeRegisterRemoteDataSource()
      ..errorToThrow = ApiException(message: 'Sign up failed');
    final repository = RegisterRepositoryImpl(dataSource, SafeCall());
    final response = await repository.register(validRegisterRequest());
    expect(response, isA<ErrorResponse<RegisterResult>>());
    final failure = response as ErrorResponse<RegisterResult>;
    expect(failure.appError, isA<BadResponseError>());
  });
}

void testRepositoryPreservesRegisterResult() {
  test('safeApiCall keeps RegisterResult data', () async {
    final dataSource = FakeRegisterRemoteDataSource()
      ..result = const RegisterResult(
        userId: 'abc',
        email: 'a@b.com',
        role: 'Customer',
        status: 'Active',
      );
    final repository = RegisterRepositoryImpl(dataSource, SafeCall());
    final response = await repository.register(validRegisterRequest());
    final success = response as SuccessResponse<RegisterResult>;
    expect(success.data.userId, 'abc');
  });
}

void testUseCaseDelegatesToRepository() {
  test('delegates request to repository and returns success', () async {
    final repository = FakeRegisterRepository();
    final useCase = RegisterUseCaseImpl(repository);
    final result = await useCase(validRegisterRequest());
    expect(repository.callCount, 1);
    expect(result, isA<SuccessResponse<RegisterResult>>());
  });
}

void testUseCasePropagatesRepositoryFailure() {
  test('propagates repository failure', () async {
    final repository = FakeRegisterRepository(shouldFail: true);
    final useCase = RegisterUseCaseImpl(repository);
    final result = await useCase(validRegisterRequest());
    expect(result, isA<ErrorResponse<RegisterResult>>());
    final failure = result as ErrorResponse<RegisterResult>;
    expect(failure.errorMessage, AppString.signupFailed);
  });
}

void registerDependencyInjectionGroup() {
  group('Register dependency injection', () {
    test(
      'registers the register graph once and resolves RegisterBloc',
      () async {
        TestWidgetsFlutterBinding.ensureInitialized();
        SharedPreferences.setMockInitialValues({});
        await getIt.reset();
        addTearDown(getIt.reset);
        await configureDependencies();
        expect(getIt.isRegistered<DioRegisterApi>(), isTrue);
        expect(getIt.isRegistered<RegisterRemoteDataSource>(), isTrue);
        expect(getIt.isRegistered<RegisterRepository>(), isTrue);
        expect(getIt.isRegistered<RegisterUseCase>(), isTrue);
        expect(getIt.isRegistered<RegisterBloc>(), isTrue);
        expect(getIt<RegisterBloc>(), isA<RegisterBloc>());
      },
    );
  });
}
