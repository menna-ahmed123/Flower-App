import 'package:cached_network_image/cached_network_image.dart';
import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/core/enums/notification_permission_status.dart';
import 'package:flower_app/features/notification/domain/use_cases/is_notification_permission_granted_use_case.dart';
import 'package:flower_app/features/notification/domain/use_cases/open_notification_settings_use_case.dart';
import 'package:flower_app/features/notification/domain/use_cases/request_notification_permission_use_case.dart';
import 'package:flower_app/features/notification/domain/use_cases/update_notification_status_use_case.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/domain/use_case/get_profile_use_case.dart';
import 'package:flower_app/features/profile/presentation/models/profile_display_data.dart';
import 'package:flower_app/features/profile/presentation/view_model/profile_event.dart';
import 'package:flower_app/features/profile/presentation/view_model/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ProfileViewModel extends Cubit<ProfileState> {
  ProfileViewModel(
    this._getProfileUseCase,
    this._requestNotificationPermissionUseCase,
    this._isNotificationPermissionGrantedUseCase,
    this._openNotificationSettingsUseCase,
    this._updateNotificationStatusUseCase,
  ) : super(const ProfileState());

  final GetProfileUseCase _getProfileUseCase;
  final RequestNotificationPermissionUseCase
      _requestNotificationPermissionUseCase;
  final IsNotificationPermissionGrantedUseCase
      _isNotificationPermissionGrantedUseCase;
  final OpenNotificationSettingsUseCase
      _openNotificationSettingsUseCase;
  final UpdateNotificationStatusUseCase
      _updateNotificationStatusUseCase;

  Future<void> doEvent(ProfileEvent event) async {
    switch (event) {
      case ProfileInitialized():
        if (state.profileState.data == null) {
          await _getProfile();
        }
        break;

      case ProfileRequested():
        await _getProfile();
        break;

      case ProfileUpdated(:final profile):
        await _evictProfileImage(state.profileState.data);
        await _evictProfileImage(profile);

        emit(
          state.copyWith(
            profileState: state.profileState.copyWith(data: profile),
            displayData: ProfileDisplayData.fromEntity(profile),
          ),
        );
        break;

      case NotificationToggleChanged(:final isEnabled):
        await _handleNotificationToggle(isEnabled);
        break;

      case OpenNotificationSettingsRequested():
        await _openNotificationSettingsUseCase();
        break;

      case NotificationSettingsPromptDismissed():
        emit(
          state.copyWith(
            shouldShowNotificationSettingsDialog: false,
          ),
        );
        break;
    }
  }

  Future<void> _handleNotificationToggle(bool isEnabled) async {
    if (state.isUpdatingNotifications) return;

    emit(
      state.copyWith(
        isUpdatingNotifications: true,
        notificationErrorMessage: '',
        shouldShowNotificationSettingsDialog: false,
      ),
    );

    try {
      if (isEnabled) {
        var permissionStatus =
            await _isNotificationPermissionGrantedUseCase();

        if (permissionStatus != NotificationPermissionStatus.granted) {
          permissionStatus =
              await _requestNotificationPermissionUseCase();
        }

        if (permissionStatus != NotificationPermissionStatus.granted) {
          emit(
            state.copyWith(
              isUpdatingNotifications: false,
              shouldShowNotificationSettingsDialog: true,
            ),
          );
          return;
        }
      }

      final response = await _updateNotificationStatusUseCase(
        enabled: isEnabled,
      );

      switch (response) {
        case SuccessResponse<void>():
          emit(
            state.copyWith(
              isNotificationsEnabled: isEnabled,
              isUpdatingNotifications: false,
              notificationErrorMessage: '',
            ),
          );
          break;

        case ErrorResponse<void>():
          emit(
            state.copyWith(
              isUpdatingNotifications: false,
              notificationErrorMessage: response.errorMessage,
            ),
          );
          break;
      }
    } catch (_) {
      emit(
        state.copyWith(
          isUpdatingNotifications: false,
          notificationErrorMessage:
              'Something went wrong. Please try again.',
        ),
      );
    }
  }

  Future<void> _evictProfileImage(ProfileEntity? profile) async {
    final imageUrl = ApiEndpoints.mediaUrl(profile?.profilePictureUrl);

    if (imageUrl.isEmpty) return;

    await CachedNetworkImage.evictFromCache(imageUrl);
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
            displayData: ProfileDisplayData.fromEntity(response.data),
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
        break;
    }
  }
}
