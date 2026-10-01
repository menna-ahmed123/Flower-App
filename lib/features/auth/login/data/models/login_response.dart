import 'package:flower_app/features/auth/login/domain/entity/auth_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final Object? status;
  final int? code;
  final String? message;
  final LoginData? data;
  final dynamic pagination;
  final dynamic errors;

  LoginResponse({
    this.status,
    this.code,
    this.message,
    this.data,
    this.pagination,
    this.errors,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class LoginData {
  final LoginUser user;
  final String token;
  final String refreshToken;

  LoginData({
    required this.user,
    required this.token,
    required this.refreshToken,
  });

  AuthEntity toDomain() {
    return AuthEntity(
      accessToken: token,
      refreshToken: refreshToken,
      role: user.roles.isEmpty ? '' : user.roles.first,
      expiresIn: 0,
    );
  }

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
}

@JsonSerializable()
class LoginUser {
  final String id;
  final String email;
  final String phone;
  final String name;
  final List<String> roles;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String gender;
  final String notificationStatus;

  LoginUser({
    required this.id,
    required this.email,
    required this.phone,
    required this.name,
    required this.roles,
    required this.createdAt,
    required this.updatedAt,
    required this.gender,
    required this.notificationStatus,
  });

  factory LoginUser.fromJson(Map<String, dynamic> json) =>
      _$LoginUserFromJson(json);

  Map<String, dynamic> toJson() => _$LoginUserToJson(this);
}
