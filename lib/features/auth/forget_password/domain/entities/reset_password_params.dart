class ResetPasswordParams {
  final String otpToken;
  final String password;
  final String confirmPassword;

  ResetPasswordParams({
    required this.otpToken,
    required this.password,
    required this.confirmPassword,
  });
}
