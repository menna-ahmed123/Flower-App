import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/reset_password_params.dart';

part 'reset_password_request_model.g.dart';

@JsonSerializable()
class ResetPasswordRequestModel {
  @JsonKey(name: "resetToken")
  final String? resetToken;
  @JsonKey(name: "newPassword")
  final String? newPassword;
  @JsonKey(name: "confirmPassword")
  final String? confirmPassword;

  ResetPasswordRequestModel({
    this.resetToken,
    this.newPassword,
    this.confirmPassword,
  });

  factory ResetPasswordRequestModel.fromJson(Map<String, dynamic> json) {
    return _$ResetPasswordRequestModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ResetPasswordRequestModelToJson(this);
  }

  factory ResetPasswordRequestModel.fromDomain(ResetPasswordParams params) {
    return ResetPasswordRequestModel(
      confirmPassword: params.confirmPassword,
      newPassword: params.newPassword,
      resetToken: params.resetToken,
    );
  }
}
