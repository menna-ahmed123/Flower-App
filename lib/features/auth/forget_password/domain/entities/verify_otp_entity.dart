import 'package:equatable/equatable.dart';

class VerifyOtpEntity extends Equatable {
  final String otpToken;
  final num expiresInMinutes;

  const VerifyOtpEntity({
    required this.otpToken,
    required this.expiresInMinutes,
  });

  @override
  List<Object?> get props => [otpToken, expiresInMinutes];
}
