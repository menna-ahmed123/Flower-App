import 'package:flower_app/features/forget_password/domain/entities/reset_password_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reset_password_response_model.g.dart';

@JsonSerializable()
class ResetPasswordResponseModel {
  @JsonKey(name: "isSuccess")
  final bool? isSuccess;
  @JsonKey(name: "statusCode")
  final int? statusCode;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "errors")
  final List<String>? errors;

  ResetPasswordResponseModel({
    this.isSuccess,
    this.statusCode,
    this.message,
    this.errors,
  });

  factory ResetPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return _$ResetPasswordResponseModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ResetPasswordResponseModelToJson(this);
  }

  ResetPasswordEntity toDomain() {
    return ResetPasswordEntity(
      message: message,
      isSuccess: isSuccess,
      statusCode: statusCode,
      errors: errors,
    );
  }
}
