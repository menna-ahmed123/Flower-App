import 'package:flower_app/features/auth/forget_password/domain/entities/forget_password_params.dart';
import 'package:json_annotation/json_annotation.dart';

part 'forget_password_request_model.g.dart';

@JsonSerializable()
class ForgetPasswordRequestModel {
  final String email;

  ForgetPasswordRequestModel({required this.email});

  factory ForgetPasswordRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ForgetPasswordRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ForgetPasswordRequestModelToJson(this);

  factory ForgetPasswordRequestModel.fromDomain(ForgetPasswordParams params) {
    return ForgetPasswordRequestModel(email: params.email);
  }
}
