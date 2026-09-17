import 'package:equatable/equatable.dart';
import 'package:flower_app/features/auth/register/domain/entity/gender.dart';

class UpdateProfileRequest extends Equatable {
  const UpdateProfileRequest({
    required this.firstName,
    required this.lastName,
    this.email,
    this.phoneNumber,
    this.gender,
    this.profilePicturePath,
  });

  final String firstName;
  final String lastName;
  final String? email;
  final String? phoneNumber;
  final Gender? gender;
  final String? profilePicturePath;

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    phoneNumber,
    gender,
    profilePicturePath,
  ];
}
