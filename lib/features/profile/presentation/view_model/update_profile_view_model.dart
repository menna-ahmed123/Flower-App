import 'dart:io';

import 'package:flower_app/core/base/base_response.dart';
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

@Injectable()
class UpdateProfileViewModel extends Cubit<EditProfileState> {
  final UpdateProfileUseCase _updateProfileUseCase;
  final ImagePickerService _imagePickerService;

  UpdateProfileViewModel(
    this._updateProfileUseCase,
    this._imagePickerService,
  ) : super(const EditProfileState());

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
        await _updateProfile(
          event.firstName,
          event.lastName,
          event.phone,
          event.gender ?? Gender.male,
          event.profilePicture,
        );
    }
  }

  void _initializeProfile(ProfileEntity profile) {
    _initialProfile = profile;

    _firstName = profile.firstName;
    _lastName = profile.lastName;
    _phone = profile.phoneNumber;
    _gender = profile.gender;

    emit(
      state.copyWith(
        hasChanges: false,
      ),
    );
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

    emit(
      state.copyWith(
        hasChanges: hasChanges,
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedImage = await _imagePickerService.pickImage();

    if (pickedImage != null) {
      final imageFile = File(pickedImage.path);
      final extension = pickedImage.path.split('.').last.toLowerCase();
      if (!ProfileConstants.allowedExtensions.contains(extension)) {
        emit(state.copyWith(
          updateProfileState: state.updateProfileState.copyWith(
            errorMessage: 'Please choose a JPG, JPEG, PNG, or WEBP image.',
          ),
        ));
        return;
      }
      if (await imageFile.length() > ProfileConstants.maxImageBytes) {
        emit(state.copyWith(
          updateProfileState: state.updateProfileState.copyWith(
            errorMessage: 'Profile image must be 5 MB or smaller.',
          ),
        ));
        return;
      }
      emit(
        state.copyWith(
          selectedImage: imageFile,
        ),
      );

      _updateHasChanges();
    }
  }

  Future<void> _updateProfile(
    String firstName,
    String lastName,
    String phone,
    Gender gender,
    File? profilePicture,
  ) async {
    emit(
      state.copyWith(
        updateProfileState: state.updateProfileState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );

    final request = UpdateProfileRequest(
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phone,
      gender: gender,
      profilePicture: profilePicture,
    );

    final response = await _updateProfileUseCase(
      updateProfileRequest: request,
    );

    switch (response) {
      case SuccessResponse<ProfileEntity>():
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