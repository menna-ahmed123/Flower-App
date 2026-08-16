import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/forget_password/api/data_source/forget_password_remote_data_source_impl.dart';
import 'package:flower_app/features/forget_password/data/models/verify_otp_response_model.dart';
import 'package:flower_app/features/forget_password/data/repos/forget_password_repo_impl.dart';
import 'package:flower_app/features/forget_password/domain/entities/verify_otp_entity.dart';
import 'package:flower_app/features/forget_password/domain/entities/verify_otp_params.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'forget_password_repo_impl_test.mocks.dart';


@GenerateMocks([ForgetPasswordRemoteDataSourceImpl])
void main() {
  provideDummy<BaseResponse<VerifyOtpResponseModel>>(
    SuccessResponse<VerifyOtpResponseModel>(
      VerifyOtpResponseModel(
        resetToken: 'test-reset-token',
        expiresAtUtc: DateTime.utc(2026, 8, 16, 4, 0),
        status: 'verified',
      ),
    ),
  );

  late MockForgetPasswordRemoteDataSourceImpl
  mockForgetPasswordRemoteDataSource;

  late ForgetPasswordRepoImpl forgetPasswordRepoImpl;

  setUp(() {
    mockForgetPasswordRemoteDataSource =
        MockForgetPasswordRemoteDataSourceImpl();

    forgetPasswordRepoImpl = ForgetPasswordRepoImpl(
      remoteDataSource: mockForgetPasswordRemoteDataSource,
    );
  });

  group('Verify OTP Function Tests', () {
    test('Success when OTP is verified', () async {
      // Arrange
      final verifyOtpParams = VerifyOtpParams(
        email: 'test@gmail.com',
        otp: '123456',
      );

      final successResponse = SuccessResponse<VerifyOtpResponseModel>(
        VerifyOtpResponseModel(
          resetToken: 'test-reset-token',
          expiresAtUtc: DateTime.utc(2026, 8, 16, 4, 0),
          status: 'verified',
        ),
      );

      when(
        mockForgetPasswordRemoteDataSource.verifyOtp(
          requestModel: anyNamed('requestModel'),
        ),
      ).thenAnswer((_) async => successResponse);

      // Act
      final result = await forgetPasswordRepoImpl.verifyOtp(
        verifyOtpParams: verifyOtpParams,
      );

      // Assert
      expect(result, isA<SuccessResponse<VerifyOtpEntity>>());

      final response = result as SuccessResponse<VerifyOtpEntity>;

      expect(response.data.resetToken, 'test-reset-token');

      expect(response.data.expiresAtUtc, DateTime.utc(2026, 8, 16, 4, 0));

      expect(response.data.status, 'verified');

      verify(
        mockForgetPasswordRemoteDataSource.verifyOtp(
          requestModel: anyNamed('requestModel'),
        ),
      ).called(1);
    });

    test('Error when OTP verification fails', () async {
      // Arrange
      final verifyOtpParams = VerifyOtpParams(
        email: 'test@gmail.com',
        otp: '123456',
      );

      final errorResponse = ErrorResponse<VerifyOtpResponseModel>(
        appError: BadResponseError('Invalid OTP'),
      );

      when(
        mockForgetPasswordRemoteDataSource.verifyOtp(
          requestModel: anyNamed('requestModel'),
        ),
      ).thenAnswer((_) async => errorResponse);

      // Act
      final result = await forgetPasswordRepoImpl.verifyOtp(
        verifyOtpParams: verifyOtpParams,
      );

      // Assert
      expect(result, isA<ErrorResponse<VerifyOtpEntity>>());

      final response = result as ErrorResponse<VerifyOtpEntity>;

      expect(response.errorMessage, 'Invalid OTP');

      verify(
        mockForgetPasswordRemoteDataSource.verifyOtp(
          requestModel: anyNamed('requestModel'),
        ),
      ).called(1);
    });
  });
}
