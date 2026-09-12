import 'dart:io';

/// Fields for `PUT /identity/users/me/profile` (multipart/form-data).
///
/// Not a [JsonSerializable] DTO: the endpoint is multipart, sent as
/// individual `@Part` fields by [ProfileApiClient], not a JSON body.
class UpdateProfileRequest {
  const UpdateProfileRequest({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    this.profilePicture,
  });

  final String fullName;
  final String email;
  final String phoneNumber;

  /// API expects the literal `Male`/`Female` value.
  final String gender;

  /// Omit to keep the current avatar; the backend deletes the old file when set.
  final File? profilePicture;
}
