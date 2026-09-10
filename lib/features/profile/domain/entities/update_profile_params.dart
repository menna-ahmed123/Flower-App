import 'dart:io';

import 'package:equatable/equatable.dart';

/// Domain-level input for updating the authenticated user's profile.
///
/// Kept free of any data-layer import so domain and presentation code never
/// depend on how the request is transported (multipart, JSON, etc.); the
/// data layer builds its own request model from this via `.fromDomain()`.
class UpdateProfileParams extends Equatable {
  const UpdateProfileParams({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    this.profilePicture,
    this.vehicleType,
    this.vehiclePlateNumber,
    this.country,
  });

  final String fullName;
  final String email;
  final String phoneNumber;

  /// API expects the literal `Male`/`Female` value.
  final String gender;

  /// Omit to keep the current avatar; the backend deletes the old file when set.
  final File? profilePicture;

  /// Driver-only; omit to keep the current vehicle type. Ignored for other roles.
  final String? vehicleType;

  /// Driver-only; omit to keep the current vehicle plate number. Ignored for other roles.
  final String? vehiclePlateNumber;

  /// Driver-only; omit to keep the current country. Ignored for other roles.
  final String? country;

  @override
  List<Object?> get props => [
    fullName,
    email,
    phoneNumber,
    gender,
    profilePicture,
    vehicleType,
    vehiclePlateNumber,
    country,
  ];
}
