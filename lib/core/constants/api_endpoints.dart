class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://localhost:5086/api/v1';

  static const String forgotPassword = '/identity/auth/forgot-password';

  static const String verifyOtp = '/identity/auth/verify-otp';

  static const String resetPassword = '/identity/auth/reset-password';

  static const String login = '/identity/auth/login';

  static const String register = '/identity/users/register';
}
