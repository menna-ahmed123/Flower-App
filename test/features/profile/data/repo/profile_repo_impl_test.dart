import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:flower_app/features/profile/data/models/profile_response.dart';
import 'package:flower_app/features/profile/data/models/update_profile_request.dart';
import 'package:flower_app/features/profile/data/models/user_profile_dto.dart';
import 'package:flower_app/features/profile/data/repo/profile_repo_impl.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_repo_impl_test.mocks.dart';

@GenerateMocks([ProfileRemoteDataSource])
void main() {
  late MockProfileRemoteDataSource remoteDataSource;
  late SafeCall safeCall;
  late ProfileRepoImpl repo;

  final dto = UserProfileDto(
    userId: 'u1',
    fullName: 'Mariam Ahmed',
    firstName: 'Mariam',
    lastName: 'Ahmed',
    email: 'mariam@example.com',
    phoneNumber: '01010000001',
    gender: 'Female',
    profilePictureUrl: '/uploads/avatars/a.jpg',
    roles: const ['Customer'],
    emailChanged: false,
  );
  final response = ProfileResponse(
    isSuccess: true,
    statusCode: 200,
    message: 'ok',
    data: dto,
  );

  setUp(() {
    remoteDataSource = MockProfileRemoteDataSource();
    safeCall = SafeCall();
    repo = ProfileRepoImpl(remoteDataSource, safeCall);
  });

  group('getMyProfile', () {
    test('returns SuccessResponse mapped to ProfileEntity', () async {
      when(remoteDataSource.getMyProfile()).thenAnswer((_) async => response);

      final result = await repo.getMyProfile();

      expect(result, isA<SuccessResponse<ProfileEntity>>());
      final data = (result as SuccessResponse<ProfileEntity>).data;
      expect(data.fullName, 'Mariam Ahmed');
      expect(data.email, 'mariam@example.com');
    });

    test('returns ErrorResponse when the remote call throws', () async {
      when(remoteDataSource.getMyProfile()).thenThrow(Exception('network'));

      final result = await repo.getMyProfile();

      expect(result, isA<ErrorResponse<ProfileEntity>>());
    });
  });

  group('updateMyProfile', () {
    const request = UpdateProfileRequest(
      fullName: 'Mariam Ahmed',
      email: 'mariam@example.com',
      phoneNumber: '01010000001',
      gender: 'Female',
    );

    test('returns SuccessResponse mapped to ProfileEntity', () async {
      when(
        remoteDataSource.updateMyProfile(request),
      ).thenAnswer((_) async => response);

      final result = await repo.updateMyProfile(request);

      expect(result, isA<SuccessResponse<ProfileEntity>>());
      verify(remoteDataSource.updateMyProfile(request)).called(1);
    });

    test('returns ErrorResponse when the remote call throws', () async {
      when(
        remoteDataSource.updateMyProfile(request),
      ).thenThrow(Exception('validation failed'));

      final result = await repo.updateMyProfile(request);

      expect(result, isA<ErrorResponse<ProfileEntity>>());
    });
  });
}
