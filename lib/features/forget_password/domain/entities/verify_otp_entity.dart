class VerifyOtpEntity {
  final String status;
  final String resetToken;
  final DateTime expiresAtUtc;

  VerifyOtpEntity({
    required this.status,
    required this.resetToken,
    required this.expiresAtUtc,
  });
}
