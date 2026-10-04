import 'package:flower_app/features/auth/forget_password/domain/entities/verify_otp_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_response_model.g.dart';

@JsonSerializable()
class VerifyOtpResponseModel {
  final Object? status;
  final int? code;
  final String? message;
  final VerifyOtpData data;
  final dynamic pagination;
  final dynamic errors;

  VerifyOtpResponseModel({
    this.status,
    this.code,
    this.message,
    required this.data,
    this.pagination,
    this.errors,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpResponseModelToJson(this);

  VerifyOtpEntity toDomain() {
    return VerifyOtpEntity(
      otpToken: data.otpToken,
      expiresInMinutes: data.expiresInMinutes,
    );
  }
}

@JsonSerializable()
class VerifyOtpData {
  final String otpToken;
  final num expiresInMinutes;

  VerifyOtpData({required this.otpToken, required this.expiresInMinutes});

  factory VerifyOtpData.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpDataFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpDataToJson(this);
}
