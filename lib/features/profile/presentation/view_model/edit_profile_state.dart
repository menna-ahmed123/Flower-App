import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';

class EditProfileState extends Equatable {
  final BaseState<ProfileEntity> updateProfileState;
  final String? selectedImagePath;
  final bool hasChanges;

  const EditProfileState({
    this.updateProfileState = const BaseState(),
    this.selectedImagePath,
    this.hasChanges = false,
  });

  EditProfileState copyWith({
    BaseState<ProfileEntity>? updateProfileState,
    String? selectedImagePath,
    bool? hasChanges,
  }) {
    return EditProfileState(
      updateProfileState: updateProfileState ?? this.updateProfileState,
      selectedImagePath: selectedImagePath ?? this.selectedImagePath,
      hasChanges: hasChanges ?? this.hasChanges,
    );
  }

  @override
  List<Object?> get props => [
    updateProfileState,
    selectedImagePath,
    hasChanges,
  ];
}
