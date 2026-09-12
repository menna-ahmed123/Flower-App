import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/domain/use_case/get_profile_use_case.dart';
import 'package:flower_app/features/profile/presentation/view_model/profile_event.dart';
import 'package:flower_app/features/profile/presentation/view_model/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// Single Cubit for the Profile feature, matching the project's
/// one-Cubit-per-screen convention.
@lazySingleton
class ProfileViewModel extends Cubit<ProfileState> {
  ProfileViewModel(this._getProfileUseCase) : super(const ProfileState());

  final GetProfileUseCase _getProfileUseCase;

  Future<void> doEvent(ProfileEvent event) async {
    switch (event) {
      case ProfileRequested():
        await _getProfile();
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
}
