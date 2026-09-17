import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/domain/repo/profile_repo.dart';
import 'package:flower_app/features/profile/domain/use_case/get_profile_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const profile = ProfileEntity(
    userId: 'u1',
    fullName: 'Mariam Ahmed',
    firstName: 'Mariam',
    lastName: 'Ahmed',
    email: 'mariam@example.com',
    phoneNumber: '01010000001',
    gender: null,
    profilePictureUrl: null,
    roles: ['Customer'],
  );

  test('delegates to ProfileRepo.getMyProfile and returns its response', () async {
    final repo = _RecordingProfileRepo(getResponse: const SuccessResponse(profile));
    final useCase = GetProfileUseCase(repo);

    final result = await useCase();

    expect(repo.getMyProfileCallCount, 1);
    expect(result, isA<SuccessResponse<ProfileEntity>>());
    expect((result as SuccessResponse<ProfileEntity>).data, profile);
  });

  test('propagates an ErrorResponse from the repo unchanged', () async {
    final repo = _RecordingProfileRepo(
      getResponse: ErrorResponse(appError: BadResponseError('network error')),
    );
    final useCase = GetProfileUseCase(repo);

    final result = await useCase();

    expect(result, isA<ErrorResponse<ProfileEntity>>());
  });
}

/// Hand-written fake `ProfileRepo`: mirrors the fakes already used in the
/// Profile widget tests instead of a Mockito mock, to avoid depending on
/// generated code for this simple pass-through use case.
class _RecordingProfileRepo implements ProfileRepo {
  _RecordingProfileRepo({required this.getResponse});

  final BaseResponse<ProfileEntity> getResponse;
  int getMyProfileCallCount = 0;

  @override
  Future<BaseResponse<ProfileEntity>> getMyProfile() async {
    getMyProfileCallCount++;
    return getResponse;
  }
}
