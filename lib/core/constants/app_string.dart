abstract final class AppString {
  static const String pleaseEnterYourEmail = 'Please enter your email';
  static const String pleaseEnterValidEmail = 'Please enter a valid email';

  static const String passwordIsRequired = 'Password is required';
  static const String passwordRequirement =
      'Password must be 8+ chars and 1 uppercase letter';
  static const String passwordsDoNotMatch = 'Passwords do not match';

  static const String phoneNumberIsRequired = 'Phone number is required';
  static const String validEgyptianPhone =
      'Enter a valid Egyptian phone number';

  static const String resetPasswordRequirement =
      'Password must contain at least 6 characters, one uppercase letter and one number';

  static const String onlyLettersNumbersUnderscore =
      'Only letters, numbers and _ are allowed';

  static const String forgotPassword = 'Forgot Password';
  static const String forgotPasswordDescription =
      'Enter your email address and we will send you a verification code.';
  static const String email = 'Email';
  static const String enterYourEmail = 'Enter your email';
  static const String sendCode = 'Send Code';

  static const String verificationCode = 'Verification Code';
  static const String verificationCodeDescription =
      'Enter the verification code sent to';
  static const String verify = 'Verify';
  static const String otpRequired = 'Please enter the verification code';
  static const String invalidOtp = 'Please enter a valid verification code';
  static const String resetPassword = 'Reset Password';
  static const String newPassword = 'New Password';
  static const String enterYourPassword = 'Enter Your Password';
  static const String confirmPassword = 'Confirm Password';
  static const String confirm = 'Confirm';
  static const String password = 'Password';
  static const String resetPasswordSuccess = 'Reset Password Successfully';
  static const String resetPasswordDescription =
      'Password must not be empty and must contain 6 characters with upper case letter and one number at least ';

  static String fieldIsRequired(String field) => '$field is required';

  static String fieldMinLength(String field, int length) =>
      '$field must be at least $length characters';

  static String fieldNoSpaces(String field) => '$field cannot contain spaces';
}
