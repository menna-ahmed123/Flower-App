import 'package:json_annotation/json_annotation.dart';

part 'register_result_dto.g.dart';

@JsonSerializable()
class RegisterResultDto {
  const RegisterResultDto({
    required this.userId,
    required this.email,
    required this.role,
    required this.status,
    this.message = '',
  });

  @JsonKey(defaultValue: '')
  final String userId;
  @JsonKey(defaultValue: '')
  final String email;
  @JsonKey(defaultValue: '')
  final String role;
  @JsonKey(defaultValue: '')
  final String status;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String message;

  factory RegisterResultDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResultDtoToJson(this);

  factory RegisterResultDto.fromOperationJson(Map<String, dynamic> json) {
    final data = json['data'];
    final dataMap = data is Map<String, dynamic> ? data : <String, dynamic>{};

    return RegisterResultDto(
      userId: dataMap['userId']?.toString() ?? '',
      email: dataMap['email']?.toString() ?? '',
      role: dataMap['role']?.toString() ?? '',
      status: dataMap['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }
}
