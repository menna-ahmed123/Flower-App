import 'package:flower_app/features/auth/forget_password/domain/entities/forget_password_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'forget_password_response_model.g.dart';

@JsonSerializable()
class ForgetPasswordResponseModel {
  final Object? status;
  final int? code;
  final String? message;
  final bool data;
  final dynamic pagination;
  final dynamic errors;

  ForgetPasswordResponseModel({
    this.status,
    this.code,
    this.message,
    required this.data,
    this.pagination,
    this.errors,
  });

  factory ForgetPasswordResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ForgetPasswordResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ForgetPasswordResponseModelToJson(this);

  ForgetPasswordEntity toDomain() {
    return ForgetPasswordEntity(success: data);
  }
}
