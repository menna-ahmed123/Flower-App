import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/forget_password/data/data_sources/remote/forget_password_remote_data_source.dart';
import 'package:flower_app/features/forget_password/data/models/forget_password_response_model.dart';
import 'package:flower_app/features/forget_password/data/models/reset_password_response_model.dart';
import 'package:flower_app/features/forget_password/data/repos/forget_password_repo_impl.dart';
import 'package:flower_app/features/forget_password/domain/entities/forget_password_entity.dart';
import 'package:flower_app/features/forget_password/domain/entities/forget_password_params.dart';
import 'package:flower_app/features/forget_password/domain/entities/reset_password_entity.dart';
import 'package:flower_app/features/forget_password/domain/entities/reset_password_params.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'forget_password_repo_impl_test.mocks.dart';

@GenerateMocks([ForgetPasswordRemoteDataSource])
void main() {
  provideDummy<BaseResponse<ForgetPasswordResponseModel>>(
    SuccessResponse<ForgetPasswordResponseModel>(
      ForgetPasswordResponseModel(
        cooldownRemainingSeconds: 30,
      ),
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
  late ForgetPasswordRepoImpl forgetPasswordRepoImpl;

  setUp(() {
    mockRemoteDataSource = MockForgetPasswordRemoteDataSource();

    forgetPasswordRepoImpl = ForgetPasswordRepoImpl(
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group('Forget Password Function Tests', () {
    test('Success with valid email', () async {
      final forgetPasswordParams = ForgetPasswordParams(
        email: 'test@gmail.com',
      );

      final successResponse = SuccessResponse<ForgetPasswordResponseModel>(
        ForgetPasswordResponseModel(
          cooldownRemainingSeconds: 30,
        ),
      );

      when(
        mockRemoteDataSource.forgetPassword(
          requestModel: anyNamed('requestModel'),
        ),
      ).thenAnswer((_) async => successResponse);

      final result = await forgetPasswordRepoImpl.forgetPassword(
        forgetPasswordParams: forgetPasswordParams,
      );

      expect(result, isA<SuccessResponse<ForgetPasswordEntity>>());

      final response = result as SuccessResponse<ForgetPasswordEntity>;

      expect(response.data.cooldownRemainingSeconds, 30);

      verify(
        mockRemoteDataSource.forgetPassword(
          requestModel: anyNamed('requestModel'),
        ),
      ).called(1);
    });

    test('Error when forget password fails', () async {
      final forgetPasswordParams = ForgetPasswordParams(
        email: 'invalid@email.com',
      );

      final errorResponse = ErrorResponse<ForgetPasswordResponseModel>(
        appError: BadResponseError('Invalid email'),
      );

      when(
        mockRemoteDataSource.forgetPassword(
          requestModel: anyNamed('requestModel'),
        ),
      ).thenAnswer((_) async => errorResponse);

      final result = await forgetPasswordRepoImpl.forgetPassword(
        forgetPasswordParams: forgetPasswordParams,
      );

      expect(result, isA<ErrorResponse<ForgetPasswordEntity>>());

      final response = result as ErrorResponse<ForgetPasswordEntity>;

      expect(response.errorMessage, 'Invalid email');

      verify(
        mockRemoteDataSource.forgetPassword(
          requestModel: anyNamed('requestModel'),
        ),
      ).called(1);
    });
  });

  group('Reset Password Function Tests', () {
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
        mockRemoteDataSource.resetPassword(
          requestModel: anyNamed('requestModel'),
        ),
      ).thenAnswer((_) async => successResponse);

      final result = await forgetPasswordRepoImpl.resetPassword(
        resetPasswordParams: params,
      );

      expect(result, isA<SuccessResponse<ResetPasswordEntity>>());

      final response = result as SuccessResponse<ResetPasswordEntity>;

      expect(response.data.isSuccess, true);
      expect(response.data.statusCode, 200);
      expect(response.data.message, 'Password reset successfully');
      expect(response.data.errors, isNull);

      verify(
        mockRemoteDataSource.resetPassword(
          requestModel: anyNamed('requestModel'),
        ),
      ).called(1);
    });

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
        mockRemoteDataSource.resetPassword(
          requestModel: anyNamed('requestModel'),
        ),
      ).thenAnswer((_) async => errorResponse);

      final result = await forgetPasswordRepoImpl.resetPassword(
        resetPasswordParams: params,
      );

      expect(result, isA<ErrorResponse<ResetPasswordEntity>>());

      final response = result as ErrorResponse<ResetPasswordEntity>;

      expect(response.errorMessage, 'Failed to reset password');

      verify(
        mockRemoteDataSource.resetPassword(
          requestModel: anyNamed('requestModel'),
        ),
      ).called(1);
    });
  });
}