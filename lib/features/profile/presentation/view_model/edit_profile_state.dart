import 'package:equatable/equatable.dart';
import 'dart:io';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';

class EditProfileState extends Equatable {
  final BaseState<ProfileEntity> updateProfileState;
  final File? selectedImage;
  final bool hasChanges;

  const EditProfileState({
    this.updateProfileState = const BaseState(),
    this.selectedImage,
    this.hasChanges = false,
  });

  EditProfileState copyWith({
    BaseState<ProfileEntity>? updateProfileState,
    File? selectedImage,
    bool? hasChanges,
  }) {
    return EditProfileState(
      updateProfileState: updateProfileState ?? this.updateProfileState,
      selectedImage: selectedImage ?? this.selectedImage,
      hasChanges: hasChanges ?? this.hasChanges,
    );
  }

  @override
  List<Object?> get props => [
    updateProfileState,
    selectedImage,
    hasChanges,
  ];
}
