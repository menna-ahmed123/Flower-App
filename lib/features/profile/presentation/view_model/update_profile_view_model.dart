import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/domain/entities/gender.dart';
import 'package:flower_app/features/profile/data/models/update_profile_request.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/domain/use_case/update_profile_use_case.dart';
import 'package:flower_app/features/profile/presentation/view_model/edit_profile_event.dart';
import 'package:flower_app/features/profile/presentation/view_model/edit_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateProfileViewModel extends Cubit<EditProfileState> {
  final UpdateProfileUseCase _updateProfileUseCase;

  UpdateProfileViewModel(this._updateProfileUseCase)
      : super(const EditProfileState());

  Future<void> doEvent(EditProfileEvent event) async {
    switch (event) {
      case UpdateProfileRequested():
        await updateProfile(
          event.firstName,
          event.lastName,
          event.email,
          event.phone,
          event.gender,
        );
        break;
    }
  }

  Future<void> updateProfile(
    String firstName,
    String lastName,
    String email,
    String phone,
    Gender? gender,
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
        break;

      case ErrorResponse<ProfileEntity>():
        emit(
          state.copyWith(
            updateProfileState: state.updateProfileState.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
        break;
    }
  }
}

