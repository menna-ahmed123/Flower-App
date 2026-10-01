import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/reset_password_params.dart';

part 'reset_password_request_model.g.dart';

@JsonSerializable()
class ResetPasswordRequestModel {
  final String otpToken;
  final String password;
  final String confirmPassword;

  ResetPasswordRequestModel({
    required this.otpToken,
    required this.password,
    required this.confirmPassword,
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
      password: params.password,
      otpToken: params.otpToken,
    );
  }
}
