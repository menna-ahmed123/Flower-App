import 'package:equatable/equatable.dart';
import 'package:flower_app/features/auth/register/domain/entity/gender.dart';

/// The authenticated user's own profile (GET /identity/users/me/profile).
class ProfileEntity extends Equatable {
  const ProfileEntity({
    required this.userId,
    required this.fullName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.profilePictureUrl,
    required this.roles,
  });

  final String userId;
  final String fullName;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phoneNumber;
  final Gender? gender;
  final String? profilePictureUrl;
  final List<String> roles;

  @override
  List<Object?> get props => [
    userId,
    fullName,
    firstName,
    lastName,
    email,
    phoneNumber,
    gender,
    profilePictureUrl,
    roles,
  ];
}
