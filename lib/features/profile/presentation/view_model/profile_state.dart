import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/presentation/models/profile_display_data.dart';

class ProfileState extends Equatable {
  @override
  List<Object?> get props => [
    profileState,
    isNotificationsEnabled,
    displayData,
  ];

  final BaseState<ProfileEntity> profileState;

  // UI-only for now (see NotificationToggleChanged); kept in state rather
  // than a View-local ValueNotifier so it stays the single source of truth.
  final bool isNotificationsEnabled;

  // Presentation-ready mapping of profileState.data, computed once in the
  // ViewModel so the View never maps ProfileEntity -> ProfileDisplayData
  // itself.
  final ProfileDisplayData? displayData;

  const ProfileState({
    this.profileState = const BaseState(),
    this.isNotificationsEnabled = true,
    this.displayData,
  });

  ProfileState copyWith({
    BaseState<ProfileEntity>? profileState,
    bool? isNotificationsEnabled,
    ProfileDisplayData? displayData,
  }) {
    return ProfileState(
      profileState: profileState ?? this.profileState,
      isNotificationsEnabled:
          isNotificationsEnabled ?? this.isNotificationsEnabled,
      displayData: displayData ?? this.displayData,
    );
  }
}
