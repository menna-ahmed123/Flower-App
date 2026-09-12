import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';

class ProfileState extends Equatable {
  @override
  List<Object?> get props => [profileState, updateState];

  final BaseState<ProfileEntity> profileState;
  final BaseState<ProfileEntity> updateState;

  const ProfileState({
    this.profileState = const BaseState(),
    this.updateState = const BaseState(),
  });

  ProfileState copyWith({
    BaseState<ProfileEntity>? profileState,
    BaseState<ProfileEntity>? updateState,
  }) {
    return ProfileState(
      profileState: profileState ?? this.profileState,
      updateState: updateState ?? this.updateState,
    );
  }
}
