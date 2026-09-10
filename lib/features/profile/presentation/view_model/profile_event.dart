import 'package:flower_app/features/profile/domain/entities/update_profile_params.dart';

sealed class ProfileEvent {}

class ProfileRequested extends ProfileEvent {}

class ProfileUpdateRequested extends ProfileEvent {
  final UpdateProfileParams params;

  ProfileUpdateRequested(this.params);
}
