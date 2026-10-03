import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/core/services/image_picker_service.dart';
import 'package:flower_app/features/profile/data/models/update_profile_request.dart';
import 'package:flower_app/features/profile/domain/entities/gender.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/domain/use_case/update_profile_use_case.dart';
import 'package:flower_app/features/profile/presentation/view_model/edit_profile_event.dart';
import 'package:flower_app/features/profile/presentation/view_model/edit_profile_state.dart';
import 'package:flower_app/features/profile/presentation/view_model/update_profile_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'update_profile_view_model_test.mocks.dart';

@GenerateMocks([UpdateProfileUseCase, ImagePickerService])
void main() {
  late MockUpdateProfileUseCase mockUpdateProfileUseCase;
  late MockImagePickerService mockImagePickerService;
  late UpdateProfileViewModel updateProfileViewModel;

  setUp(() {
    mockUpdateProfileUseCase = MockUpdateProfileUseCase();
    mockImagePickerService = MockImagePickerService();

    updateProfileViewModel = UpdateProfileViewModel(
      mockUpdateProfileUseCase,
      mockImagePickerService,
    );
  });

  final dummyProfile = ProfileEntity(
    id: 'userId',
    firstName: 'firstName',
    lastName: 'lastName',
    email: 'user@example.com',
    phoneNumber: '01000000000',
    gender: Gender.male,
  );

  final dummySuccessResponse = SuccessResponse<ProfileEntity>(dummyProfile);

  final updateProfileRequest = UpdateProfileRequest(
    firstName: 'Menna',
    lastName: 'Ahmed',
    phoneNumber: '01000000000',
    gender: Gender.female,
  );

  provideDummy<BaseResponse<ProfileEntity>>(dummySuccessResponse);

  group('UpdateProfile', () {
    test('should update profile successfully', () async {
      // Arrange

      await updateProfileViewModel.doEvent(
        EditProfileInitialized(profile: dummyProfile),
      );
      await updateProfileViewModel.doEvent(FirstNameChanged('Menna'));
      await updateProfileViewModel.doEvent(LastNameChanged('Ahmed'));
      await updateProfileViewModel.doEvent(PhoneChanged('01000000000'));
      await updateProfileViewModel.doEvent(GenderChanged(Gender.female));

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
        UpdateProfileRequested(),
      );

      // Assert

      await future;

      verify(
        mockUpdateProfileUseCase(updateProfileRequest: updateProfileRequest),
      ).called(1);
    });

    test('should return error when update profile fails', () async {
      // Arrange

      await updateProfileViewModel.doEvent(
        EditProfileInitialized(profile: dummyProfile),
      );
      await updateProfileViewModel.doEvent(FirstNameChanged('Menna'));
      await updateProfileViewModel.doEvent(LastNameChanged('Ahmed'));
      await updateProfileViewModel.doEvent(PhoneChanged('01000000000'));
      await updateProfileViewModel.doEvent(GenderChanged(Gender.female));

      final errorResponse = ErrorResponse<ProfileEntity>(
        appError: BadResponseError('Update profile failed'),
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
        UpdateProfileRequested(),
      );

      // Assert

      await future;

      verify(
        mockUpdateProfileUseCase(updateProfileRequest: updateProfileRequest),
      ).called(1);
    });

    test('includes the selected local image in the update request', () async {
      final directory = await Directory.systemTemp.createTemp('profile-test');
      final imageFile = File('${directory.path}/avatar.jpg');
      await imageFile.writeAsBytes(List<int>.filled(10, 1));

      await updateProfileViewModel.doEvent(
        EditProfileInitialized(profile: dummyProfile),
      );
      when(mockImagePickerService.pickImage()).thenAnswer(
        (_) async => XFile(imageFile.path),
      );
      when(
        mockUpdateProfileUseCase(
          updateProfileRequest: anyNamed('updateProfileRequest'),
        ),
      ).thenAnswer((_) async => dummySuccessResponse);

      await updateProfileViewModel.doEvent(PickProfileImageRequested());
      expect(updateProfileViewModel.state.selectedImage?.path, imageFile.path);

      await updateProfileViewModel.doEvent(UpdateProfileRequested());

      final captured = verify(
        mockUpdateProfileUseCase(
          updateProfileRequest: captureAnyNamed('updateProfileRequest'),
        ),
      ).captured.single as UpdateProfileRequest;
      expect(captured.profilePicture?.path, imageFile.path);

      await directory.delete(recursive: true);
    });
  });
}
