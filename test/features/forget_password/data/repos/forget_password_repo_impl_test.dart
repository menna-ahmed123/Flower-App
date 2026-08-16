import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/forget_password/api/data_source/forget_password_remote_data_source_impl.dart';
import 'package:flower_app/features/forget_password/data/models/forget_password_response_model.dart';
import 'package:flower_app/features/forget_password/data/repos/forget_password_repo_impl.dart';
import 'package:flower_app/features/forget_password/domain/entities/forget_password_entity.dart';
import 'package:flower_app/features/forget_password/domain/entities/forget_password_params.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'forget_password_repo_impl_test.mocks.dart';

@GenerateMocks([ForgetPasswordRemoteDataSourceImpl])
void main() {
  provideDummy<BaseResponse<ForgetPasswordResponseModel>>(
    SuccessResponse<ForgetPasswordResponseModel>(
      ForgetPasswordResponseModel(cooldownRemainingSeconds: 30),
    ),
  );

  late MockForgetPasswordRemoteDataSourceImpl mockForgetPasswordRemoteDataSource;

  late ForgetPasswordRepoImpl forgetPasswordRepoImpl;

  setUp(() {
    mockForgetPasswordRemoteDataSource = MockForgetPasswordRemoteDataSourceImpl();

    forgetPasswordRepoImpl = ForgetPasswordRepoImpl(
      remoteDataSource: mockForgetPasswordRemoteDataSource,
    );
  });

  group('Forget Password Function Tests', () {
    test('Success with valid email', () async {
      // Arrange
      final forgetPasswordParams = ForgetPasswordParams(
        email: 'test@gmail.com',
      );

      final successResponse = SuccessResponse<ForgetPasswordResponseModel>(
        ForgetPasswordResponseModel(cooldownRemainingSeconds: 30),
      );

      when(
        mockForgetPasswordRemoteDataSource.forgetPassword(
          requestModel: anyNamed('requestModel'),
        ),
      ).thenAnswer((_) async => successResponse);

      // Act
      final result = await forgetPasswordRepoImpl.forgetPassword(
        forgetPasswordParams: forgetPasswordParams,
      );

      // Assert
      expect(result, isA<SuccessResponse<ForgetPasswordEntity>>());

      final response = result as SuccessResponse<ForgetPasswordEntity>;

      expect(response.data.cooldownRemainingSeconds, 30);

      verify(
        mockForgetPasswordRemoteDataSource.forgetPassword(
          requestModel: anyNamed('requestModel'),
        ),
      ).called(1);
    });

    test('Error when forget password fails', () async {
      // Arrange
      final forgetPasswordParams = ForgetPasswordParams(
        email: 'invalid@email.com',
      );

      final errorResponse = ErrorResponse<ForgetPasswordResponseModel>(
        appError: BadResponseError('Invalid email'),
      );

      when(
        mockForgetPasswordRemoteDataSource.forgetPassword(
          requestModel: anyNamed('requestModel'),
        ),
      ).thenAnswer((_) async => errorResponse);

      // Act
      final result = await forgetPasswordRepoImpl.forgetPassword(
        forgetPasswordParams: forgetPasswordParams,
      );

      // Assert
      expect(result, isA<ErrorResponse<ForgetPasswordEntity>>());

      final response = result as ErrorResponse<ForgetPasswordEntity>;

      expect(response.errorMessage, 'Invalid email');

   
    });
  });
}
