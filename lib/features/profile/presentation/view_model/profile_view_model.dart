import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/profile/domain/entities/update_profile_params.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/domain/use_case/get_profile_use_case.dart';
import 'package:flower_app/features/profile/domain/use_case/update_profile_use_case.dart';
import 'package:flower_app/features/profile/presentation/view_model/profile_event.dart';
import 'package:flower_app/features/profile/presentation/view_model/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// Single Cubit for the whole Profile feature (get + update), matching the
/// project's one-Cubit-per-screen convention; shared as a singleton so an
/// update made from Edit Profile is reflected on Profile immediately.
@lazySingleton
class ProfileViewModel extends Cubit<ProfileState> {
  ProfileViewModel(this._getProfileUseCase, this._updateProfileUseCase)
    : super(const ProfileState());

  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  Future<void> doEvent(ProfileEvent event) async {
    switch (event) {
      case ProfileRequested():
        await _getProfile();
        break;
      case ProfileUpdateRequested(:final params):
        await _updateProfile(params);
        break;
    }
  }

  Future<void> _getProfile() async {
    emit(
      state.copyWith(
        profileState: state.profileState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );

    final response = await _getProfileUseCase();

    switch (response) {
      case SuccessResponse<ProfileEntity>():
        emit(
          state.copyWith(
            profileState: state.profileState.copyWith(
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
            profileState: state.profileState.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
    }
  }

  Future<void> _updateProfile(UpdateProfileParams params) async {
    emit(
      state.copyWith(
        updateState: state.updateState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );

    final response = await _updateProfileUseCase(params);

    switch (response) {
      case SuccessResponse<ProfileEntity>():
        emit(
          state.copyWith(
            updateState: state.updateState.copyWith(
              isLoading: false,
              data: response.data,
              errorMessage: '',
            ),
            // The update response is the caller's fresh profile; reuse it.
            profileState: state.profileState.copyWith(data: response.data),
          ),
        );
        break;
      case ErrorResponse<ProfileEntity>():
        emit(
          state.copyWith(
            updateState: state.updateState.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
    }
  }
}
