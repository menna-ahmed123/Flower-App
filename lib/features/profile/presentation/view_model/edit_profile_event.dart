import 'package:flower_app/features/profile/domain/entities/gender.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';

sealed class EditProfileEvent {}

class EditProfileInitialized extends EditProfileEvent {
  final ProfileEntity profile;

  EditProfileInitialized({required this.profile});
}

class FirstNameChanged extends EditProfileEvent {
  final String value;

  FirstNameChanged(this.value);
}

class LastNameChanged extends EditProfileEvent {
  final String value;

  LastNameChanged(this.value);
}

class EmailChanged extends EditProfileEvent {
  final String value;

  EmailChanged(this.value);
}

class PhoneChanged extends EditProfileEvent {
  final String value;

  PhoneChanged(this.value);
}

class GenderChanged extends EditProfileEvent {
  final Gender? value;

  GenderChanged(this.value);
}

class PickProfileImageRequested extends EditProfileEvent {}

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
