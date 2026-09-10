import 'package:flower_app/features/auth/register/domain/entity/gender.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile_dto.g.dart';

/// Matches the `UserProfile` schema from `/identity/users/me/profile`.
@JsonSerializable()
class UserProfileDto {
  final String userId;
  final String fullName;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phoneNumber;
  final String? gender;
  final String? profilePictureUrl;
  final List<String> roles;
  final bool emailChanged;

  /// Driver-only; null for customers and admins.
  final String? vehicleType;

  /// Driver-only; null for customers and admins.
  final String? vehiclePlateNumber;

  /// Driver-only; null for customers and admins.
  final String? country;

  UserProfileDto({
    required this.userId,
    required this.fullName,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phoneNumber,
    this.gender,
    this.profilePictureUrl,
    required this.roles,
    required this.emailChanged,
    this.vehicleType,
    this.vehiclePlateNumber,
    this.country,
  });

  ProfileEntity toDomain() {
    return ProfileEntity(
      userId: userId,
      fullName: fullName,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      gender: GenderParsing.fromApiValue(gender),
      profilePictureUrl: profilePictureUrl,
      roles: roles,
      emailChanged: emailChanged,
      vehicleType: vehicleType,
      vehiclePlateNumber: vehiclePlateNumber,
      country: country,
    );
  }

  factory UserProfileDto.fromJson(Map<String, dynamic> json) =>
      _$UserProfileDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileDtoToJson(this);
}
