abstract class AppString{
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

  static String fieldIsRequired(String field) => '$field is required';
  static String fieldMinLength(String field, int length) =>
      '$field must be at least $length characters';
  static String fieldNoSpaces(String field) => '$field cannot contain spaces';

}