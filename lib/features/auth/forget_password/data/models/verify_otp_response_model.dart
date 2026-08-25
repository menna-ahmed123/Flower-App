import 'package:flower_app/features/auth/forget_password/domain/entities/verify_otp_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_response_model.g.dart';

@JsonSerializable()
class VerifyOtpResponseModel {
  final String status;
  final String resetToken;
  final DateTime expiresAtUtc;

  VerifyOtpResponseModel({
    required this.status,
    required this.resetToken,
    required this.expiresAtUtc,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    final payload = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    return _$VerifyOtpResponseModelFromJson(payload);
  }

  Map<String, dynamic> toJson() => _$VerifyOtpResponseModelToJson(this);

  VerifyOtpEntity toDomain() {
    return VerifyOtpEntity(
      status: status,
      resetToken: resetToken,
      expiresAtUtc: expiresAtUtc,
    );
  }
}
