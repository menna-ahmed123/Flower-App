import 'dart:io';

import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/di/di.dart';
import 'package:flower_app/core/services/image_picker_service.dart';
import 'package:flower_app/features/profile/data/models/update_profile_request.dart';
import 'package:flower_app/features/profile/domain/entities/gender.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/domain/profile_constants.dart';
import 'package:flower_app/features/profile/domain/use_case/update_profile_use_case.dart';
import 'package:flower_app/features/profile/presentation/view_model/edit_profile_event.dart';
import 'package:flower_app/features/profile/presentation/view_model/edit_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Injectable()
class UpdateProfileViewModel extends Cubit<EditProfileState> {
  static const profileImagePathKey = 'profile_image_path';

  final UpdateProfileUseCase _updateProfileUseCase;
  final ImagePickerService _imagePickerService;

  UpdateProfileViewModel(this._updateProfileUseCase, this._imagePickerService)
    : super(const EditProfileState());

  ProfileEntity? _initialProfile;

  String _firstName = '';
  String _lastName = '';
  String _phone = '';
  Gender _gender = Gender.male;

  Future<void> doEvent(EditProfileEvent event) async {
    switch (event) {
      case EditProfileInitialized():
        _initializeProfile(event.profile);

      case FirstNameChanged():
        _firstName = event.value;
        _updateHasChanges();

      case LastNameChanged():
        _lastName = event.value;
        _updateHasChanges();

      case PhoneChanged():
        _phone = event.value;
        _updateHasChanges();

      case GenderChanged():
        _gender = event.value ?? Gender.male;
        _updateHasChanges();

      case PickProfileImageRequested():
        await _pickImage();

      case UpdateProfileRequested():
        await _updateProfile();
    }
  }

  void _initializeProfile(ProfileEntity profile) {
    _initialProfile = profile;

    _firstName = profile.firstName;
    _lastName = profile.lastName;
    _phone = profile.phoneNumber;
    _gender = profile.gender;

    emit(state.copyWith(hasChanges: false));
  }

  void _updateHasChanges() {
    final profile = _initialProfile;

    if (profile == null) {
      return;
    }

    final hasChanges =
        _firstName.trim() != profile.firstName.trim() ||
        _lastName.trim() != profile.lastName.trim() ||
        _phone.trim() != profile.phoneNumber.trim() ||
        _gender != profile.gender ||
        state.selectedImage != null;

    emit(state.copyWith(hasChanges: hasChanges));
  }

  Future<void> _pickImage() async {
    try {
      final pickedImage = await _imagePickerService.pickImage();

      if (pickedImage == null) return;

      final imageFile = File(pickedImage.path);
      final extension = pickedImage.path.split('.').last.toLowerCase();
      if (!ProfileConstants.allowedExtensions.contains(extension)) {
        emit(
          state.copyWith(
            updateProfileState: state.updateProfileState.copyWith(
              errorMessage: AppString.invalidImageType,
            ),
          ),
        );
        return;
      }
      if (await imageFile.length() > ProfileConstants.maxImageBytes) {
        emit(
          state.copyWith(
            updateProfileState: state.updateProfileState.copyWith(
              errorMessage: AppString.profileImageTooLarge,
            ),
          ),
        );
        return;
      }
      emit(state.copyWith(selectedImage: imageFile));

      _updateHasChanges();
    } catch (_) {
      emit(
        state.copyWith(
          updateProfileState: state.updateProfileState.copyWith(
            errorMessage: AppString.unableToSelectProfileImage,
          ),
        ),
      );
    }
  }

  Future<void> _updateProfile() async {
    emit(
      state.copyWith(
        updateProfileState: state.updateProfileState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );

    final request = UpdateProfileRequest(
      firstName: _firstName,
      lastName: _lastName,
      phoneNumber: _phone,
      gender: _gender,
      profilePicture: state.selectedImage,
    );

    final response = await _updateProfileUseCase(updateProfileRequest: request);

    switch (response) {
      case SuccessResponse<ProfileEntity>():
        final selectedImage = state.selectedImage;

        if (selectedImage != null && getIt.isRegistered<SharedPreferences>()) {
          await getIt<SharedPreferences>().setString(
            profileImagePathKey,
            selectedImage.path,
          );
        }

        emit(
          state.copyWith(
            updateProfileState: state.updateProfileState.copyWith(
              isLoading: false,
              data: response.data,
              errorMessage: '',
            ),
          ),
        );

      case ErrorResponse<ProfileEntity>():
        emit(
          state.copyWith(
            updateProfileState: state.updateProfileState.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
    }
  }
}
