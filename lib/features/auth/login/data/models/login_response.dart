import 'package:flower_app/features/auth/login/domain/entity/auth_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final bool isSuccess;
  final int statusCode;
  final String message;
  final LoginData data;

  LoginResponse({
    required this.isSuccess,
    required this.statusCode,
    required this.message,
    required this.data,
  });
  
  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
@JsonSerializable()
class LoginData {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String role;
  final String? driverApplicationStatus;
  final bool canAccessDriverHome;
  final String? driverApplicationRejectionReason;

  LoginData({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.role,
    this.driverApplicationStatus,
    required this.canAccessDriverHome,
    this.driverApplicationRejectionReason,
  });
AuthEntity toDomain() {
  return AuthEntity(
    accessToken: accessToken,
    refreshToken: refreshToken,
    role: role,
  );
}
  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDataToJson(this);

}