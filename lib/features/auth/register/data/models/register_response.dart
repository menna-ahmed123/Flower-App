import 'package:flower_app/features/auth/register/domain/entity/register_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'register_response.g.dart';

@JsonSerializable()
class RegisterResponse {
  final bool isSuccess;
  final int statusCode;
  final String message;
  final RegisterData? data;
  final Map<String, dynamic>? errors;

  RegisterResponse({
    required this.isSuccess,
    required this.statusCode,
    required this.message,
    this.data,
    this.errors,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}

@JsonSerializable()
class RegisterData {
  final String userId;
  final String email;
  final String role;
  final String status;

  RegisterData({
    required this.userId,
    required this.email,
    required this.role,
    required this.status,
  });

  RegisterEntity toDomain({String message = ''}) {
    return RegisterEntity(
      userId: userId,
      email: email,
      role: role,
      status: status,
      message: message,
    );
  }

  factory RegisterData.fromJson(Map<String, dynamic> json) =>
      _$RegisterDataFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterDataToJson(this);
}
