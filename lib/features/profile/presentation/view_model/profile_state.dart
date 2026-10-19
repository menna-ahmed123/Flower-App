import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/presentation/models/profile_display_data.dart';

class ProfileState extends Equatable {
  final BaseState<ProfileEntity> profileState;
  final bool isNotificationsEnabled;
  final ProfileDisplayData? displayData;
  final bool isUpdatingNotifications;
  final bool shouldShowNotificationSettingsDialog;
  final String notificationErrorMessage;

  const ProfileState({
    this.profileState = const BaseState(),
    this.isNotificationsEnabled = true,
    this.displayData,
    this.isUpdatingNotifications = false,
    this.shouldShowNotificationSettingsDialog = false,
    this.notificationErrorMessage = '',
  });

  @override
  List<Object?> get props => [
        profileState,
        isNotificationsEnabled,
        displayData,
        isUpdatingNotifications,
        shouldShowNotificationSettingsDialog,
        notificationErrorMessage,
      ];

  ProfileState copyWith({
    BaseState<ProfileEntity>? profileState,
    bool? isNotificationsEnabled,
    ProfileDisplayData? displayData,
    bool? isUpdatingNotifications,
    bool? shouldShowNotificationSettingsDialog,
    String? notificationErrorMessage,
  }) {
    return ProfileState(
      profileState: profileState ?? this.profileState,
      isNotificationsEnabled:
          isNotificationsEnabled ?? this.isNotificationsEnabled,
      displayData: displayData ?? this.displayData,
      isUpdatingNotifications:
          isUpdatingNotifications ?? this.isUpdatingNotifications,
      shouldShowNotificationSettingsDialog:
          shouldShowNotificationSettingsDialog ??
              this.shouldShowNotificationSettingsDialog,
      notificationErrorMessage:
          notificationErrorMessage ?? this.notificationErrorMessage,
    );
  }
}