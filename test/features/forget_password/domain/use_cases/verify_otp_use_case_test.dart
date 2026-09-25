import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/auth/forget_password/domain/entities/verify_otp_entity.dart';
import 'package:flower_app/features/auth/forget_password/domain/entities/verify_otp_params.dart';
import 'package:flower_app/features/auth/forget_password/domain/repos/forget_password_repo.dart';
import 'package:flower_app/features/auth/forget_password/domain/use_cases/verify_otp_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'forget_password_use_case_test.mocks.dart';

@GenerateMocks([ForgetPasswordRepo])
void main() {
  _registerDummy();

  late VerifyOtpUseCase verifyOtpUseCase;
  late MockForgetPasswordRepo mockForgetPasswordRepo;

  setUp(() {
    mockForgetPasswordRepo = MockForgetPasswordRepo();

    verifyOtpUseCase = VerifyOtpUseCase(
      forgetPasswordRepo: mockForgetPasswordRepo,
    );
  });

  group('VerifyOtpUseCase Tests', () {
    test('should return success when verify OTP succeeds', () async {
      await _testVerifyOtpSuccess(verifyOtpUseCase, mockForgetPasswordRepo);
    });
  });
}

void _registerDummy() {
  provideDummy<BaseResponse<VerifyOtpEntity>>(
    SuccessResponse<VerifyOtpEntity>(
      VerifyOtpEntity(otpToken: 'test-otp-token', expiresInMinutes: 10),
    ),
  );
}

Future<void> _testVerifyOtpSuccess(
  VerifyOtpUseCase verifyOtpUseCase,
  MockForgetPasswordRepo mockForgetPasswordRepo,
) async {
  // Arrange
  final verifyOtpParams = VerifyOtpParams(
    email: 'test@example.com',
    otp: '123456',
  );

  final successResponse = SuccessResponse<VerifyOtpEntity>(
    VerifyOtpEntity(otpToken: 'test-otp-token', expiresInMinutes: 10),
  );

  when(
    mockForgetPasswordRepo.verifyOtp(verifyOtpParams: verifyOtpParams),
  ).thenAnswer((_) async => successResponse);

  // Act
  final result = await verifyOtpUseCase(verifyOtpParams: verifyOtpParams);

  // Assert
  expect(result, isA<SuccessResponse<VerifyOtpEntity>>());

  final successResult = result as SuccessResponse<VerifyOtpEntity>;

  expect(successResult.data.otpToken, 'test-otp-token');
  expect(successResult.data.expiresInMinutes, 10);
}
