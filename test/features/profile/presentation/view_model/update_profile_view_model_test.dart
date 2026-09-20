import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/profile/data/models/update_profile_request.dart';
import 'package:flower_app/features/profile/domain/entities/gender.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/domain/use_case/update_profile_use_case.dart';
import 'package:flower_app/features/profile/presentation/view_model/edit_profile_event.dart';
import 'package:flower_app/features/profile/presentation/view_model/edit_profile_state.dart';
import 'package:flower_app/features/profile/presentation/view_model/update_profile_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'update_profile_view_model_test.mocks.dart';

@GenerateMocks([UpdateProfileUseCase])
void main() {
  late MockUpdateProfileUseCase mockUpdateProfileUseCase;
  late UpdateProfileViewModel updateProfileViewModel;

  setUp(() {
    mockUpdateProfileUseCase = MockUpdateProfileUseCase();

    updateProfileViewModel = UpdateProfileViewModel(mockUpdateProfileUseCase);
  });

  final dummyProfile = ProfileEntity(
    userId: 'userId',
    fullName: 'Full Name',
    firstName: 'firstName',
    lastName: 'lastName',
    roles: ['Customer'],
  );

  final dummySuccessResponse = SuccessResponse<ProfileEntity>(dummyProfile);

  final updateProfileRequest = UpdateProfileRequest(
    firstName: 'Menna',
    lastName: 'Ahmed',
    email: 'menna@test.com',
    phoneNumber: '01000000000',
    gender: Gender.female,
  );

  provideDummy<BaseResponse<ProfileEntity>>(dummySuccessResponse);

  group('UpdateProfile', () {
    test('should update profile successfully', () async {
      // Arrange

      when(
        mockUpdateProfileUseCase(updateProfileRequest: updateProfileRequest),
      ).thenAnswer((_) async => dummySuccessResponse);

      final future = expectLater(
        updateProfileViewModel.stream,
        emitsInOrder([
          isA<EditProfileState>().having(
            (state) => state.updateProfileState.isLoading,
            'isLoading',
            true,
          ),
          isA<EditProfileState>()
              .having(
                (state) => state.updateProfileState.isLoading,
                'isLoading',
                false,
              )
              .having(
                (state) => state.updateProfileState.data,
                'data',
                dummyProfile,
              )
              .having(
                (state) => state.updateProfileState.errorMessage,
                'errorMessage',
                '',
              ),
        ]),
      );

      // Act

      await updateProfileViewModel.doEvent(
        UpdateProfileRequested(
          firstName: updateProfileRequest.firstName,
          lastName: updateProfileRequest.lastName,
          email: updateProfileRequest.email ?? '',
          phone: updateProfileRequest.phoneNumber ?? '',
          gender: updateProfileRequest.gender,
          profilePicturePath: updateProfileRequest.profilePicturePath,
        ),
      );

      // Assert

      await future;

      verify(
        mockUpdateProfileUseCase(updateProfileRequest: updateProfileRequest),
      ).called(1);
    });

    test('should return error when update profile fails', () async {
      // Arrange

      final errorResponse = ErrorResponse<ProfileEntity>(
        appError: BadResponseError('Update profile failed')
        ,
      );

      when(
        mockUpdateProfileUseCase(updateProfileRequest: updateProfileRequest),
      ).thenAnswer((_) async => errorResponse);

      final future = expectLater(
        updateProfileViewModel.stream,
        emitsInOrder([
          isA<EditProfileState>().having(
            (state) => state.updateProfileState.isLoading,
            'isLoading',
            true,
          ),
          isA<EditProfileState>()
              .having(
                (state) => state.updateProfileState.isLoading,
                'isLoading',
                false,
              )
              .having(
                (state) => state.updateProfileState.errorMessage,
                'errorMessage',
                'Update profile failed',
              ),
        ]),
      );

      // Act

      await updateProfileViewModel.doEvent(
        UpdateProfileRequested(
          firstName: updateProfileRequest.firstName,
          lastName: updateProfileRequest.lastName,
          email: updateProfileRequest.email ?? '',
          phone: updateProfileRequest.phoneNumber ?? '',
          gender: updateProfileRequest.gender,
          profilePicturePath: updateProfileRequest.profilePicturePath,
        ),
      );

      // Assert

      await future;

      verify(
        mockUpdateProfileUseCase(updateProfileRequest: updateProfileRequest),
      ).called(1);
    });
  });
}
