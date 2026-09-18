import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/domain/entities/gender.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/profile/data/models/update_profile_request.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/domain/repo/profile_repo.dart';
import 'package:flower_app/features/profile/domain/use_case/update_profile_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'update_profile_use_case_test.mocks.dart';

@GenerateMocks([ProfileRepo])
void main() {
  late MockProfileRepo mockProfileRepo;
  late UpdateProfileUseCase updateProfileUseCase;

  final dummyResponse = SuccessResponse(
    ProfileEntity(
      userId: '',
      fullName: '',
      firstName: '',
      lastName: '',
      email: '',
      phoneNumber: '',
      gender: null,
      profilePictureUrl: '',
      roles: [],
    ),
  );

  provideDummy<BaseResponse<ProfileEntity>>(dummyResponse);

  setUp(() {
    mockProfileRepo = MockProfileRepo();
    updateProfileUseCase = UpdateProfileUseCase(mockProfileRepo);
  });

  group('UpdateProfileUseCase', () {
    test(
      'should return success response when repository updates profile successfully',
      () async {
        // Arrange
        final updateProfileRequest = UpdateProfileRequest(
          firstName: 'Menna',
          lastName: 'Ahmed',
          email: 'menna@test.com',
          phoneNumber: '01000000000',
          gender: Gender.female,
        );

        when(
          mockProfileRepo.updateMyProfile(updateProfileRequest),
        ).thenAnswer((_) async => dummyResponse);

        // Act
        final result = await updateProfileUseCase(
          updateProfileRequest: updateProfileRequest,
        );

        // Assert
        // Assert
        expect(result, isA<SuccessResponse<ProfileEntity>>());
        final successResponse = result as SuccessResponse<ProfileEntity>;
        expect(successResponse.data, dummyResponse.data);
      },
    );

   test(
  'should return error response when repository fails to update profile',
  () async {
    // Arrange
    final updateProfileRequest = UpdateProfileRequest(
      firstName: 'Menna',
      lastName: 'Ahmed',
      email: 'menna@test.com',
      phoneNumber: '01000000000',
      gender: Gender.female,
    );

    final error = BadResponseError('Update profile failed');

    final dummyErrorResponse = ErrorResponse<ProfileEntity>(
      appError: error,
    );

    when(
      mockProfileRepo.updateMyProfile(updateProfileRequest),
    ).thenAnswer((_) async => dummyErrorResponse);

    // Act
    final result = await updateProfileUseCase(
      updateProfileRequest: updateProfileRequest,
    );

    // Assert
    expect(result, isA<ErrorResponse<ProfileEntity>>());
  },
);
  });
}

