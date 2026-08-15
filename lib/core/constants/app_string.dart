abstract class AppString {
  static const String pleaseEnterYourEmail = 'Please enter your email';
  static const String pleaseEnterValidEmail = 'This Email is not valid';
  static const String passwordIsRequired = 'Password is required';
  static const String passwordRequirement =
      'Password must be 8+ chars and 1 uppercase letter';
  static const String registrationPasswordRequirement =
      'Password must contain at least 6 characters, one uppercase letter and one number';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String confirmPasswordIsRequired =
      'Confirm password is required';
  static const String phoneNumberIsRequired = 'Phone number is required';
  static const String validEgyptianPhone =
      'Enter a valid Egyptian phone number';
  static const String resetPasswordRequirement = registrationPasswordRequirement;
  static const String onlyLettersNumbersUnderscore =
      'Only letters, numbers and _ are allowed';

  // Sign up
  static const String signUp = 'Sign up';
  static const String firstName = 'First name';
  static const String lastName = 'Last name';
  static const String enterFirstName = 'Enter first name';
  static const String enterLastName = 'Enter last name';
  static const String email = 'Email';
  static const String enterYourEmail = 'Enter your email';
  static const String password = 'Password';
  static const String enterPassword = 'Enter password';
  static const String confirmPassword = 'Confirm password';
  static const String phoneNumber = 'Phone number';
  static const String enterPhoneNumber = 'Enter phone number';
  static const String gender = 'Gender';
  static const String female = 'Female';
  static const String male = 'Male';
  static const String creatingAccountAgreePrefix =
      'Creating an account, you agree to our ';
  static const String termsAndConditions = 'Terms&Conditions';
  static const String alreadyHaveAccount = 'Already have an account? ';
  static const String login = 'Login';
  static const String genderIsRequired = 'Gender is required';
  static const String signupSuccess = 'Account created successfully';
  static const String signupFailed = 'Sign up failed. Please try again.';

  static String fieldIsRequired(String field) => '$field is required';
  static String fieldMinLength(String field, int length) =>
      '$field must be at least $length characters';
  static String fieldNoSpaces(String field) => '$field cannot contain spaces';
}
