import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flower_app/features/profile/domain/entities/gender.dart';

class UpdateProfileRequest extends Equatable {
  const UpdateProfileRequest({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.gender,
    this.profilePicture,
  });

  final String firstName;
  final String lastName;
  final String phoneNumber;
  final Gender gender;
  final File? profilePicture;

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    phoneNumber,
    gender,
    profilePicture,
  ];
}
