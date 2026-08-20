import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/di/di.dart';
import 'package:flower_app/core/errors/api_exception.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/core/errors/error_parser.dart';
import 'package:flower_app/core/helpers/app_validators.dart';
import 'package:flower_app/features/auth/register/data/api/register_api_client.dart';
import 'package:flower_app/features/auth/register/data/data_source/remote/register_remote_data_source.dart';
import 'package:flower_app/features/auth/register/domain/repo/register_repo.dart';
import 'package:flower_app/features/auth/register/domain/use_case/register_usecase.dart';
import 'package:flower_app/features/auth/register/presentation/view_model/register_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  signupRequiredFieldValidatorGroup();
  signupPasswordMessagingGroup();
  dioValidationParsingGroup();
  apiValidationParsingGroup();
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

void registerDependencyInjectionGroup() {
  group('Register dependency injection', () {
    test(
      'registers the register graph once and resolves RegisterViewModel',
      () async {
        TestWidgetsFlutterBinding.ensureInitialized();
        SharedPreferences.setMockInitialValues({});
        await getIt.reset();
        addTearDown(getIt.reset);
        await configureDependencies();
        expect(getIt.isRegistered<RegisterApiClient>(), isTrue);
        expect(getIt.isRegistered<RegisterRemoteDataSource>(), isTrue);
        expect(getIt.isRegistered<RegisterRepo>(), isTrue);
        expect(getIt.isRegistered<RegisterUseCase>(), isTrue);
        expect(getIt.isRegistered<RegisterViewModel>(), isTrue);
        expect(getIt<RegisterViewModel>(), isA<RegisterViewModel>());
      },
    );
  });
}
