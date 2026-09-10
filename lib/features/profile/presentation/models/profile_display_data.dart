import 'package:equatable/equatable.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';

/// Presentation-only shape for the fields [ProfileInfoSection] renders.
class ProfileDisplayData extends Equatable {
  const ProfileDisplayData({
    required this.name,
    required this.email,
    this.photoUrl,
  });

  final String name;
  final String email;
  final String? photoUrl;

  factory ProfileDisplayData.fromEntity(ProfileEntity entity) {
    return ProfileDisplayData(
      name: entity.fullName,
      email: entity.email ?? '',
      photoUrl: ApiEndpoints.mediaUrl(entity.profilePictureUrl),
    );
  }

  @override
  List<Object?> get props => [name, email, photoUrl];
}
