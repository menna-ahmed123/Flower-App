class ResetPasswordParams {
  final String? resetToken;
  final String? newPassword;
  final String? confirmPassword;

  ResetPasswordParams({
    this.resetToken,
    this.newPassword,
    this.confirmPassword,
  });
}
