import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/services/image_picker_service.dart';
import 'package:flower_app/features/profile/data/models/update_profile_request.dart';
import 'package:flower_app/features/profile/domain/entities/gender.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
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
  String _email = '';
  String _phone = '';
  Gender? _gender;

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

      case EmailChanged():
        _email = event.value;
        _updateHasChanges();

      case PhoneChanged():
        _phone = event.value;
        _updateHasChanges();

      case GenderChanged():
        _gender = event.value;
        _updateHasChanges();

      case PickProfileImageRequested():
        await _pickImage();

      case UpdateProfileRequested():
        await _updateProfile(
          event.firstName,
          event.lastName,
          event.email,
          event.phone,
          event.gender,
          event.profilePicturePath,
        );
    }
  }

  void _initializeProfile(ProfileEntity profile) {
    _initialProfile = profile;

    _firstName = profile.firstName;
    _lastName = profile.lastName;
    _email = profile.email ?? '';
    _phone = profile.phoneNumber ?? '';
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
        _email.trim() != (profile.email ?? '').trim() ||
        _phone.trim() != (profile.phoneNumber ?? '').trim() ||
        _gender != profile.gender ||
        state.selectedImagePath != null;

    emit(
      state.copyWith(
        hasChanges: hasChanges,
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedImage = await _imagePickerService.pickImage();

    if (pickedImage != null) {
      emit(
        state.copyWith(
          selectedImagePath: pickedImage.path,
        ),
      );

      _updateHasChanges();
    }
  }

  Future<void> _updateProfile(
    String firstName,
    String lastName,
    String email,
    String phone,
    Gender? gender,
    String? profilePicturePath,
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
      email: email,
      phoneNumber: phone,
      gender: gender,
      profilePicturePath: profilePicturePath,
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