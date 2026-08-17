import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/forget_password/data/data_sources/remote/forget_password_remote_data_source.dart';
import 'package:flower_app/features/forget_password/data/models/reset_password_response_model.dart';
import 'package:flower_app/features/forget_password/data/repos/forget_password_repo_impl.dart';
import 'package:flower_app/features/forget_password/domain/entities/reset_password_entity.dart';
import 'package:flower_app/features/forget_password/domain/entities/reset_password_params.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'forget_password_repo_impl_test.mocks.dart';

@GenerateMocks([ForgetPasswordRemoteDataSource])
void main() {
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
  late ForgetPasswordRepoImpl resetPasswordRepo;

  setUp(() {
    mockRemoteDataSource = MockForgetPasswordRemoteDataSource();

    resetPasswordRepo = ForgetPasswordRepoImpl(
      remoteDataSource: mockRemoteDataSource,
    );
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

      final result = await resetPasswordRepo.resetPassword(
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

      final result = await resetPasswordRepo.resetPassword(
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
