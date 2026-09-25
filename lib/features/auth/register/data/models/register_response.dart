import 'package:flower_app/features/auth/register/domain/entity/register_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'register_response.g.dart';

@JsonSerializable()
class RegisterResponse {
  final Object? status;
  final int? code;
  final String? message;
  final RegisterData? data;
  final dynamic pagination;
  final dynamic errors;

  RegisterResponse({
    this.status,
    this.code,
    this.message,
    this.data,
    this.pagination,
    this.errors,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);

  bool get isSuccess =>
      status == true ||
      (status is String && (status as String).toLowerCase() == 'success') ||
      (code != null && code! >= 200 && code! < 300);

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}

@JsonSerializable()
class RegisterData {
  final RegisterUser user;
  final String token;
  final String? refreshToken;

  RegisterData({required this.user, required this.token, this.refreshToken});

  RegisterEntity toDomain({String message = ''}) {
    return RegisterEntity(
      userId: user.id,
      email: user.email,
      role: user.roles.isEmpty ? '' : user.roles.first,
      status: user.notificationStatus,
      message: message,
    );
  }

  factory RegisterData.fromJson(Map<String, dynamic> json) =>
      _$RegisterDataFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterDataToJson(this);
}

@JsonSerializable()
class RegisterUser {
  final String id;
  final String email;
  final String phone;
  final String name;
  final List<String> roles;
  final DateTime createdAt;
  final String gender;
  final String notificationStatus;

  RegisterUser({
    required this.id,
    required this.email,
    required this.phone,
    required this.name,
    required this.roles,
    required this.createdAt,
    required this.gender,
    required this.notificationStatus,
  });

  factory RegisterUser.fromJson(Map<String, dynamic> json) => RegisterUser(
    id: json['id'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String,
    name: json['name'] as String,
    roles: List<String>.from(json['roles'] as List<dynamic>),
    createdAt: DateTime.parse(json['createdAt'] as String),
    gender: (json['gender'] as String).toUpperCase(),
    notificationStatus: (json['notificationStatus'] as String).toUpperCase(),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'email': email,
    'phone': phone,
    'name': name,
    'roles': roles,
    'createdAt': createdAt.toIso8601String(),
    'gender': gender,
    'notificationStatus': notificationStatus,
  };
}
