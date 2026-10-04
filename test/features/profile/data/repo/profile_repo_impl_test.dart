import 'package:flower_app/core/base/api_response.dart';
import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:flower_app/features/profile/data/models/profile_model.dart';
import 'package:flower_app/features/profile/data/models/update_profile_request.dart';
import 'package:flower_app/features/profile/data/repo/profile_repo_impl.dart';
import 'package:flower_app/features/profile/domain/entities/gender.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_repo_impl_test.mocks.dart';

@GenerateMocks([ProfileRemoteDataSource])
void main() {
  late MockProfileRemoteDataSource remoteDataSource;
  late ProfileRepoImpl repo;

  final model = ProfileModel(
    id: 'u1',
    firstName: 'Mariam',
    lastName: 'Ahmed',
    email: 'mariam@example.com',
    phoneNumber: '01010000001',
    gender: 1,
  );

  setUp(() {
    remoteDataSource = MockProfileRemoteDataSource();
    repo = ProfileRepoImpl(remoteDataSource, SafeCall());
  });

  test('maps a successful envelope to ProfileEntity', () async {
    when(remoteDataSource.getMyProfile()).thenAnswer(
      (_) async => ApiResponse(
        status: true,
        code: 200,
        message: 'ok',
        data: model,
      ),
    );

    final result = await repo.getMyProfile();

    expect(result, isA<SuccessResponse<ProfileEntity>>());
    expect((result as SuccessResponse<ProfileEntity>).data.firstName, 'Mariam');
  });

  test('turns a false envelope into an ErrorResponse', () async {
    when(remoteDataSource.getMyProfile()).thenAnswer(
      (_) async => const ApiResponse<ProfileModel>(
        status: false,
        code: 400,
        message: 'Invalid profile',
        data: null,
      ),
    );

    final result = await repo.getMyProfile();

    expect(result, isA<ErrorResponse<ProfileEntity>>());
    expect((result as ErrorResponse<ProfileEntity>).errorMessage, 'Invalid profile');
  });

  test('passes the update request through and maps the response', () async {
    final request = UpdateProfileRequest(
      firstName: 'Mariam',
      lastName: 'Ahmed',
      phoneNumber: '01010000001',
      gender: Gender.female,
    );
    when(
      remoteDataSource.updateMyProfile(updateProfileRequest: request),
    ).thenAnswer(
      (_) async => ApiResponse(
        status: true,
        code: 200,
        message: 'updated',
        data: model,
      ),
    );

    final result = await repo.updateMyProfile(request);

    expect(result, isA<SuccessResponse<ProfileEntity>>());
    verify(remoteDataSource.updateMyProfile(updateProfileRequest: request)).called(1);
  });
}
