import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/auth/forget_password/data/data_sources/remote/forget_password_remote_data_source.dart';
import 'package:flower_app/features/auth/forget_password/data/models/forget_password_response_model.dart';
import 'package:flower_app/features/auth/forget_password/data/models/reset_password_response_model.dart';
import 'package:flower_app/features/auth/forget_password/data/repos/forget_password_repo_impl.dart';
import 'package:flower_app/features/auth/forget_password/domain/entities/forget_password_entity.dart';
import 'package:flower_app/features/auth/forget_password/domain/entities/forget_password_params.dart';
import 'package:flower_app/features/auth/forget_password/domain/entities/reset_password_entity.dart';
import 'package:flower_app/features/auth/forget_password/domain/entities/reset_password_params.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'forget_password_repo_impl_test.mocks.dart';

@GenerateMocks([ForgetPasswordRemoteDataSource])
void main() {
  _runForgetPasswordRepoTests();
}

void _runForgetPasswordRepoTests() {
  provideDummy<BaseResponse<ForgetPasswordResponseModel>>(
    SuccessResponse<ForgetPasswordResponseModel>(
      ForgetPasswordResponseModel(cooldownRemainingSeconds: 30),
    ),
  );

  provideDummy<BaseResponse<ResetPasswordResponseModel>>(
    SuccessResponse<ResetPasswordResponseModel>(
      ResetPasswordResponseModel(
        isSuccess: true,
        statusCode: 200,
        message: 'Password reset successfully',
        errors: null,
      ),
    ),
  );

  late MockForgetPasswordRemoteDataSource mockRemoteDataSource;
  late ForgetPasswordRepoImpl repository;

  setUp(() {
    mockRemoteDataSource = MockForgetPasswordRemoteDataSource();

    repository = ForgetPasswordRepoImpl(
      remoteDataSource: mockRemoteDataSource,
    );
  });

  _forgetPasswordSuccessTest(() => repository, () => mockRemoteDataSource);
  _forgetPasswordErrorTest(() => repository, () => mockRemoteDataSource);
  _resetPasswordSuccessTest(() => repository, () => mockRemoteDataSource);
  _resetPasswordErrorTest(() => repository, () => mockRemoteDataSource);
}

void _forgetPasswordSuccessTest(ForgetPasswordRepoImpl Function() getRepository,
    MockForgetPasswordRemoteDataSource Function() getDataSource,) {
  test('Success with valid email', () async {
    final params = ForgetPasswordParams(email: 'test@gmail.com');

    final response = SuccessResponse<ForgetPasswordResponseModel>(
      ForgetPasswordResponseModel(cooldownRemainingSeconds: 30),
    );

    when(
      getDataSource().forgetPassword(requestModel: anyNamed('requestModel')),
    ).thenAnswer((_) async => response);

    final result = await getRepository().forgetPassword(
      forgetPasswordParams: params,
    );

    expect(result, isA<SuccessResponse<ForgetPasswordEntity>>());

    final success = result as SuccessResponse<ForgetPasswordEntity>;

    expect(success.data.cooldownRemainingSeconds, 30);

    verify(
      getDataSource().forgetPassword(requestModel: anyNamed('requestModel')),
    ).called(1);
  });
}

void _forgetPasswordErrorTest(ForgetPasswordRepoImpl Function() getRepository,
    MockForgetPasswordRemoteDataSource Function() getDataSource,) {
  test('Error when forget password fails', () async {
    final params = ForgetPasswordParams(email: 'invalid@email.com');

    final response = ErrorResponse<ForgetPasswordResponseModel>(
      appError: BadResponseError('Invalid email'),
    );

    when(
      getDataSource().forgetPassword(requestModel: anyNamed('requestModel')),
    ).thenAnswer((_) async => response);

    final result = await getRepository().forgetPassword(
      forgetPasswordParams: params,
    );

    expect(result, isA<ErrorResponse<ForgetPasswordEntity>>());

    final error = result as ErrorResponse<ForgetPasswordEntity>;

    expect(error.errorMessage, 'Invalid email');
  });
}

void _resetPasswordSuccessTest(ForgetPasswordRepoImpl Function() getRepository,
    MockForgetPasswordRemoteDataSource Function() getDataSource,) {
  test('Success when reset password succeeds', () async {
    final params = ResetPasswordParams(
      resetToken: 'mock-reset-token',
      newPassword: 'Password123',
      confirmPassword: 'Password123',
    );

    final successResponse = SuccessResponse<ResetPasswordResponseModel>(
      ResetPasswordResponseModel(
        isSuccess: true,
        statusCode: 200,
        message: 'Password reset successfully',
        errors: null,
      ),
    );

    when(
      getDataSource().resetPassword(requestModel: anyNamed('requestModel')),
    ).thenAnswer((_) async => successResponse);

    final result = await getRepository().resetPassword(
      resetPasswordParams: params,
    );

    expect(result, isA<SuccessResponse<ResetPasswordEntity>>());

    final response = result as SuccessResponse<ResetPasswordEntity>;

    expect(response.data.isSuccess, true);
    expect(response.data.statusCode, 200);
    expect(response.data.message, 'Password reset successfully');
    expect(response.data.errors, isNull);

    verify(
      getDataSource().resetPassword(requestModel: anyNamed('requestModel')),
    ).called(1);
  });
}

void _resetPasswordErrorTest(ForgetPasswordRepoImpl Function() getRepository,
    MockForgetPasswordRemoteDataSource Function() getDataSource,) {
  test('Error when reset password fails', () async {
    final params = ResetPasswordParams(
      resetToken: 'mock-reset-token',
      newPassword: 'Password123',
      confirmPassword: 'Password123',
    );

    final errorResponse = ErrorResponse<ResetPasswordResponseModel>(
      appError: BadResponseError('Failed to reset password'),
    );

    when(
      getDataSource().resetPassword(requestModel: anyNamed('requestModel')),
    ).thenAnswer((_) async => errorResponse);

    final result = await getRepository().resetPassword(
      resetPasswordParams: params,
    );

    expect(result, isA<ErrorResponse<ResetPasswordEntity>>());

    final response = result as ErrorResponse<ResetPasswordEntity>;

    expect(response.errorMessage, 'Failed to reset password');

    verify(
      getDataSource().resetPassword(requestModel: anyNamed('requestModel')),
    ).called(1);
  });
}
