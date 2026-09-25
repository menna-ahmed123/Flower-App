import 'package:flower_app/features/auth/forget_password/domain/entities/reset_password_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reset_password_response_model.g.dart';

@JsonSerializable()
class ResetPasswordResponseModel {
  final Object? status;
  final int? code;
  final String? message;
  final bool data;
  final dynamic pagination;
  final dynamic errors;

  ResetPasswordResponseModel({
    this.status,
    this.code,
    this.message,
    required this.data,
    this.pagination,
    this.errors,
  });

  factory ResetPasswordResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordResponseModelFromJson(json);

  Map<String, dynamic> toJson() {
    return _$ResetPasswordResponseModelToJson(this);
  }

  ResetPasswordEntity toDomain() {
    return ResetPasswordEntity(success: data, message: message);
  }
}
