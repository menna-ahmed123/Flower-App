class ResetPasswordParams {
  final String? resetToken;
  final String? newPassword;
  final String? confirmPassword;

  const ResetPasswordParams({
    this.resetToken,
    this.newPassword,
    this.confirmPassword,
  });
}
