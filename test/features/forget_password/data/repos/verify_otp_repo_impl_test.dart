import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/auth/forget_password/api/data_source/forget_password_remote_data_source_impl.dart';
import 'package:flower_app/features/auth/forget_password/data/models/verify_otp_response_model.dart';
import 'package:flower_app/features/auth/forget_password/data/repos/forget_password_repo_impl.dart';
import 'package:flower_app/features/auth/forget_password/domain/entities/verify_otp_entity.dart';
import 'package:flower_app/features/auth/forget_password/domain/entities/verify_otp_params.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'verify_otp_repo_impl_test.mocks.dart';

@GenerateMocks([ForgetPasswordRemoteDataSourceImpl])
void main() {
  _runVerifyOtpRepoTests();
}

void _runVerifyOtpRepoTests() {
  provideDummy<BaseResponse<VerifyOtpResponseModel>>(
    SuccessResponse<VerifyOtpResponseModel>(
      VerifyOtpResponseModel(
        resetToken: 'test-reset-token',
        expiresAtUtc: DateTime.utc(2026, 8, 16, 4),
        status: 'verified',
      ),
    ),
  );

  late MockForgetPasswordRemoteDataSourceImpl mockDataSource;
  late ForgetPasswordRepoImpl repository;

  setUp(() {
    mockDataSource = MockForgetPasswordRemoteDataSourceImpl();

    repository = ForgetPasswordRepoImpl(remoteDataSource: mockDataSource);
  });

  _verifySuccessTest(() => repository, () => mockDataSource);
  _verifyErrorTest(() => repository, () => mockDataSource);
}

void _verifySuccessTest(
  ForgetPasswordRepoImpl Function() getRepository,
  MockForgetPasswordRemoteDataSourceImpl Function() getDataSource,
) {
  test('Success when OTP is verified', () async {
    final params = VerifyOtpParams(email: 'test@gmail.com', otp: '123456');

    final response = SuccessResponse<VerifyOtpResponseModel>(
      VerifyOtpResponseModel(
        resetToken: 'test-reset-token',
        expiresAtUtc: DateTime.utc(2026, 8, 16, 4),
        status: 'verified',
      ),
    );

    when(
      getDataSource().verifyOtp(requestModel: anyNamed('requestModel')),
    ).thenAnswer((_) async => response);

    final result = await getRepository().verifyOtp(verifyOtpParams: params);

    expect(result, isA<SuccessResponse<VerifyOtpEntity>>());

    final success = result as SuccessResponse<VerifyOtpEntity>;

    expect(success.data.resetToken, 'test-reset-token');
    expect(success.data.expiresAtUtc, DateTime.utc(2026, 8, 16, 4));
    expect(success.data.status, 'verified');

    verify(
      getDataSource().verifyOtp(requestModel: anyNamed('requestModel')),
    ).called(1);
  });
}

void _verifyErrorTest(
  ForgetPasswordRepoImpl Function() getRepository,
  MockForgetPasswordRemoteDataSourceImpl Function() getDataSource,
) {
  test('Error when OTP verification fails', () async {
    final params = VerifyOtpParams(email: 'test@gmail.com', otp: '123456');

    final response = ErrorResponse<VerifyOtpResponseModel>(
      appError: BadResponseError('Invalid OTP'),
    );

    when(
      getDataSource().verifyOtp(requestModel: anyNamed('requestModel')),
    ).thenAnswer((_) async => response);

    final result = await getRepository().verifyOtp(verifyOtpParams: params);

    expect(result, isA<ErrorResponse<VerifyOtpEntity>>());

    final error = result as ErrorResponse<VerifyOtpEntity>;

    expect(error.errorMessage, 'Invalid OTP');

    verify(
      getDataSource().verifyOtp(requestModel: anyNamed('requestModel')),
    ).called(1);
  });
}
