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

  /// [mediaUrlResolver] defaults to [ApiEndpoints.mediaUrl] so call sites
  /// don't need to pass anything, but tests can inject a fake resolver
  /// instead of depending on ApiEndpoints' global mutable base-URL state.
  factory ProfileDisplayData.fromEntity(
    ProfileEntity entity, {
    String Function(String?) mediaUrlResolver = ApiEndpoints.mediaUrl,
  }) {
    return ProfileDisplayData(
      name: entity.fullName,
      email: entity.email ?? '',
      photoUrl: mediaUrlResolver(entity.profilePictureUrl),
    );
  }

  @override
  List<Object?> get props => [name, email, photoUrl];
}
