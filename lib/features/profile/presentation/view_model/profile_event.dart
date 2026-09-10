import 'package:flower_app/features/profile/data/models/update_profile_request.dart';

sealed class ProfileEvent {}

class ProfileRequested extends ProfileEvent {}

class ProfileUpdateRequested extends ProfileEvent {
  final UpdateProfileRequest request;

  ProfileUpdateRequested(this.request);
}
