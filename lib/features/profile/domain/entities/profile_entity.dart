import 'package:equatable/equatable.dart';
import 'package:flower_app/features/profile/domain/entities/gender.dart';

class ProfileEntity extends Equatable {
  const ProfileEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    this.profilePictureUrl,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final Gender gender;
  final String? profilePictureUrl;

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    phoneNumber,
    gender,
    profilePictureUrl,
  ];
}
