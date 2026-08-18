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
  _runForgetPasswordRepoTests();
}

void _runForgetPasswordRepoTests() {
  provideDummy<BaseResponse<ForgetPasswordResponseModel>>(
    SuccessResponse<ForgetPasswordResponseModel>(
      ForgetPasswordResponseModel(cooldownRemainingSeconds: 30),
    ),
  );

  late MockForgetPasswordRemoteDataSourceImpl mockDataSource;
  late ForgetPasswordRepoImpl repository;

  setUp(() {
    mockDataSource = MockForgetPasswordRemoteDataSourceImpl();

    repository = ForgetPasswordRepoImpl(remoteDataSource: mockDataSource);
  });

  _successTest(() => repository, () => mockDataSource);
  _errorTest(() => repository, () => mockDataSource);
}

void _successTest(
  ForgetPasswordRepoImpl Function() getRepository,
  MockForgetPasswordRemoteDataSourceImpl Function() getDataSource,
) {
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

void _errorTest(
  ForgetPasswordRepoImpl Function() getRepository,
  MockForgetPasswordRemoteDataSourceImpl Function() getDataSource,
) {
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
