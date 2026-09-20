import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/profile/data/api/profile_api_client.dart';
import 'package:flower_app/features/profile/data/data_source/remote/profile_remote_data_source_impl.dart';
import 'package:flower_app/features/profile/data/models/profile_response.dart';
import 'package:flower_app/features/profile/data/models/update_profile_request.dart';
import 'package:flower_app/features/profile/data/models/user_profile_dto.dart';
import 'package:flower_app/features/profile/domain/entities/gender.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ProfileApiClient])
void main() {
  late MockProfileApiClient mockProfileApiClient;
  late ProfileRemoteDataSourceImpl profileRemoteDataSourceImpl;

  setUp(() {
    mockProfileApiClient = MockProfileApiClient();

    profileRemoteDataSourceImpl = ProfileRemoteDataSourceImpl(
      mockProfileApiClient,
    );
  });

  group("test update profile", () {
    test("success profile update", () async {
      // Arrange

      final profileResponse = ProfileResponse(
        isSuccess: true,
        statusCode: 200,
        message: "success",
        data: UserProfileDto.fromJson({
          "userId": "123",
          "fullName": "Menna Ahmed",
          "firstName": "Menna",
          "lastName": "Ahmed",
          "email": "menna@test.com",
          "phoneNumber": "01000000000",
          "gender": "Female",
          "profilePictureUrl": null,
          "roles": ["Customer"],
        }),
      );

      final request = UpdateProfileRequest(
        firstName: "Menna",
        lastName: "Ahmed",
        email: "menna@test.com",
        phoneNumber: "01000000000",
        gender: Gender.female,
        profilePicturePath: null,
      );

      when(
        mockProfileApiClient.updateMyProfile(
          "Menna",
          "Ahmed",
          "menna@test.com",
          "01000000000",
          "Female",
          null,
        ),
      ).thenAnswer((_) async => profileResponse);

      // Act

      final result = await profileRemoteDataSourceImpl.upadateMyProfile(
        updateProfileRequest: request,
      );

      // Assert

      expect(result, profileResponse);
    });

    test("throw error when update profile fails", () async {
      // Arrange

      final error = BadResponseError("Update profile failed");

      final request = UpdateProfileRequest(
        firstName: "Menna",
        lastName: "Ahmed",
        email: "menna@test.com",
        phoneNumber: "01000000000",
        gender: Gender.female,
        profilePicturePath: null,
      );

      when(
        mockProfileApiClient.updateMyProfile(
          "Menna",
          "Ahmed",
          "menna@test.com",
          "01000000000",
          "Female",
          null,
        ),
      ).thenThrow(error);

      // Act & Assert

      expect(
        () => profileRemoteDataSourceImpl.upadateMyProfile(
          updateProfileRequest: request,
        ),
        throwsA(error),
      );
    });
  });
}
