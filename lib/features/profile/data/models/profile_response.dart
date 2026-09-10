import 'package:flower_app/features/profile/data/models/user_profile_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile_response.g.dart';

/// `OperationResult<UserProfile>` envelope returned by both GET and PUT.
@JsonSerializable()
class ProfileResponse {
  final bool isSuccess;
  final int statusCode;
  final String message;
  final UserProfileDto data;

  ProfileResponse({
    required this.isSuccess,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileResponseToJson(this);
}
