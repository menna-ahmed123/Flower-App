import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/domain/entities/update_profile_params.dart';
import 'package:flower_app/features/profile/domain/repo/profile_repo.dart';
import 'package:flower_app/features/profile/domain/use_case/update_profile_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const params = UpdateProfileParams(
    fullName: 'Mariam Ahmed',
    email: 'mariam@example.com',
    phoneNumber: '01010000001',
    gender: 'Female',
  );

  const updatedProfile = ProfileEntity(
    userId: 'u1',
    fullName: 'Mariam Ahmed',
    firstName: 'Mariam',
    lastName: 'Ahmed',
    email: 'mariam@example.com',
    phoneNumber: '01010000001',
    gender: null,
    profilePictureUrl: null,
    roles: ['Customer'],
    emailChanged: false,
  );

  test('passes the exact UpdateProfileParams through to ProfileRepo.updateMyProfile', () async {
    final repo = _RecordingProfileRepo(
      updateResponse: const SuccessResponse(updatedProfile),
    );
    final useCase = UpdateProfileUseCase(repo);

    final result = await useCase(params);

    expect(repo.lastParams, params);
    expect(result, isA<SuccessResponse<ProfileEntity>>());
    expect((result as SuccessResponse<ProfileEntity>).data, updatedProfile);
  });

  test('propagates an ErrorResponse from the repo unchanged', () async {
    final repo = _RecordingProfileRepo(
      updateResponse: ErrorResponse(appError: BadResponseError('Email already registered')),
    );
    final useCase = UpdateProfileUseCase(repo);

    final result = await useCase(params);

    expect(result, isA<ErrorResponse<ProfileEntity>>());
  });
}

/// Hand-written fake `ProfileRepo`, consistent with the rest of the Profile
/// test suite — avoids a Mockito mock (and the build_runner regen it would
/// need) for this simple pass-through use case.
class _RecordingProfileRepo implements ProfileRepo {
  _RecordingProfileRepo({required this.updateResponse});

  final BaseResponse<ProfileEntity> updateResponse;
  UpdateProfileParams? lastParams;

  @override
  Future<BaseResponse<ProfileEntity>> getMyProfile() {
    throw UnimplementedError('Not exercised by UpdateProfileUseCase tests.');
  }

  @override
  Future<BaseResponse<ProfileEntity>> updateMyProfile(
    UpdateProfileParams params,
  ) async {
    lastParams = params;
    return updateResponse;
  }
}
