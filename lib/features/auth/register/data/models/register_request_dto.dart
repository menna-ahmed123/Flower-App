class RegisterRequestDto {
  const RegisterRequestDto({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.password,
    required this.confirmPassword,
  });

  final String fullName;
  final String email;
  final String phoneNumber;
  final String gender;
  final String password;
  final String confirmPassword;

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}
