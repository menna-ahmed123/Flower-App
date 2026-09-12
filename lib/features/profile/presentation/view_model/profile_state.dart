import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';

class ProfileState extends Equatable {
  @override
  List<Object?> get props => [profileState];

  final BaseState<ProfileEntity> profileState;

  const ProfileState({this.profileState = const BaseState()});

  ProfileState copyWith({BaseState<ProfileEntity>? profileState}) {
    return ProfileState(profileState: profileState ?? this.profileState);
  }
}
