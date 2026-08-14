// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterResultDto _$RegisterResultDtoFromJson(Map<String, dynamic> json) =>
    RegisterResultDto(
      userId: json['userId'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );

Map<String, dynamic> _$RegisterResultDtoToJson(RegisterResultDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'role': instance.role,
      'status': instance.status,
    };
