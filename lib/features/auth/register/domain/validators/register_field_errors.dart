import 'package:equatable/equatable.dart';

enum RegisterField {
  firstName,
  lastName,
  email,
  password,
  confirmPassword,
  phoneNumber,
}

enum RegisterValidationError { empty, invalid, mismatch }

class RegisterFieldErrors extends Equatable {
  const RegisterFieldErrors({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.confirmPassword,
    this.phoneNumber,
  });

  final RegisterValidationError? firstName;
  final RegisterValidationError? lastName;
  final RegisterValidationError? email;
  final RegisterValidationError? password;
  final RegisterValidationError? confirmPassword;
  final RegisterValidationError? phoneNumber;

  bool get hasErrors {
    return firstName != null ||
        lastName != null ||
        email != null ||
        password != null ||
        confirmPassword != null ||
        phoneNumber != null;
  }

  static const empty = RegisterFieldErrors();

  RegisterFieldErrors merge(RegisterFieldErrors other) {
    return RegisterFieldErrors(
      firstName: other.firstName ?? firstName,
      lastName: other.lastName ?? lastName,
      email: other.email ?? email,
      password: other.password ?? password,
      confirmPassword: other.confirmPassword ?? confirmPassword,
      phoneNumber: other.phoneNumber ?? phoneNumber,
    );
  }

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    password,
    confirmPassword,
    phoneNumber,
  ];
}
