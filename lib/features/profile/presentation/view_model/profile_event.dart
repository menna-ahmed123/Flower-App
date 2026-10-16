import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';

sealed class ProfileEvent {}

class ProfileInitialized extends ProfileEvent {}

class ProfileRequested extends ProfileEvent {}

class ProfileUpdated extends ProfileEvent {
  ProfileUpdated(this.profile);

  final ProfileEntity profile;
}

class NotificationToggleChanged extends ProfileEvent {
  NotificationToggleChanged(this.isEnabled);

  final bool isEnabled;
}

class OpenNotificationSettingsRequested extends ProfileEvent {}

class NotificationSettingsPromptDismissed extends ProfileEvent {}
