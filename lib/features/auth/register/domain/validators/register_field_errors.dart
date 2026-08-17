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

  /// Overwrites [field] even when [partial] has a null (valid) error.
  RegisterFieldErrors applyChangedField(
    RegisterField field,
    RegisterFieldErrors partial,
  ) {
    return RegisterFieldErrors(
      firstName: field == RegisterField.firstName
          ? partial.firstName
          : firstName,
      lastName: field == RegisterField.lastName ? partial.lastName : lastName,
      email: field == RegisterField.email ? partial.email : email,
      password: field == RegisterField.password ? partial.password : password,
      confirmPassword:
          field == RegisterField.password ||
              field == RegisterField.confirmPassword
          ? partial.confirmPassword
          : confirmPassword,
      phoneNumber: field == RegisterField.phoneNumber
          ? partial.phoneNumber
          : phoneNumber,
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
