import 'package:equatable/equatable.dart';

enum RegisterField {
  firstName,
  lastName,
  email,
  password,
  confirmPassword,
  phoneNumber,
}

class RegisterFieldErrors extends Equatable {
  const RegisterFieldErrors({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.confirmPassword,
    this.phoneNumber,
  });

  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final String? confirmPassword;
  final String? phoneNumber;

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
