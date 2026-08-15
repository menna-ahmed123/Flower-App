import 'package:flower_app/features/forget_password/domain/entities/forget_password_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'forget_password_response_model.g.dart';

@JsonSerializable()
class ForgetPasswordResponseModel {
  final int cooldownRemainingSeconds;

  ForgetPasswordResponseModel({required this.cooldownRemainingSeconds});

  factory ForgetPasswordResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ForgetPasswordResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ForgetPasswordResponseModelToJson(this);

  ForgetPasswordEntity toDomain() {
    return ForgetPasswordEntity(
      cooldownRemainingSeconds: cooldownRemainingSeconds,
    );
  }
}
