import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';

class EditProfileState extends Equatable {
  @override
  List<Object?> get props => [updateProfileState];

  final BaseState<ProfileEntity> updateProfileState;

  const EditProfileState({this.updateProfileState = const BaseState()});

  EditProfileState copyWith({BaseState<ProfileEntity>? updateProfileState}) {
    return EditProfileState(
      updateProfileState: updateProfileState ?? this.updateProfileState,
    );
  }
}

