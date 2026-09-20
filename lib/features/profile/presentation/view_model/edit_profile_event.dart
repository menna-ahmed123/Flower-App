import 'package:flower_app/features/profile/domain/entities/gender.dart';

sealed class EditProfileEvent {}

class UpdateProfileRequested extends EditProfileEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final Gender? gender;
  final String? profilePicturePath;

  UpdateProfileRequested({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.gender,
    this.profilePicturePath,
  });
}

