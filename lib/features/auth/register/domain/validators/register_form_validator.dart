import 'package:flower_app/features/auth/register/domain/validators/register_field_errors.dart';
import 'package:injectable/injectable.dart';

class RegisterFormInput {
  const RegisterFormInput({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phoneNumber,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;
  final String phoneNumber;
}

@Injectable()
class RegisterFormValidator {
  const RegisterFormValidator();

  static final RegExp _emailPattern = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  static final RegExp _passwordPattern = RegExp(r'^(?=.*[A-Z])(?=.*\d).{6,}$');
  static final RegExp _phonePattern = RegExp(r'^01[0125][0-9]{8}$');

  RegisterFieldErrors validate(RegisterFormInput input) {
    return RegisterFieldErrors(
      firstName: firstNameError(input.firstName),
      lastName: lastNameError(input.lastName),
      email: emailError(input.email),
      password: passwordError(input.password),
      confirmPassword: confirmPasswordError(
        input.confirmPassword,
        input.password,
      ),
      phoneNumber: phoneError(input.phoneNumber),
    );
  }

  RegisterFieldErrors validateChangedField(
    RegisterField field,
    RegisterFormInput input,
  ) {
    return switch (field) {
      RegisterField.firstName => RegisterFieldErrors(
        firstName: firstNameError(input.firstName),
      ),
      RegisterField.lastName => RegisterFieldErrors(
        lastName: lastNameError(input.lastName),
      ),
      RegisterField.email => RegisterFieldErrors(email: emailError(input.email)),
      RegisterField.password => RegisterFieldErrors(
        password: passwordError(input.password),
        confirmPassword: confirmPasswordError(
          input.confirmPassword,
          input.password,
        ),
      ),
      RegisterField.confirmPassword => RegisterFieldErrors(
        confirmPassword: confirmPasswordError(
          input.confirmPassword,
          input.password,
        ),
      ),
      RegisterField.phoneNumber => RegisterFieldErrors(
        phoneNumber: phoneError(input.phoneNumber),
      ),
    };
  }

  RegisterValidationError? firstNameError(String value) {
    if (value.trim().isEmpty) return RegisterValidationError.empty;
    return null;
  }

  RegisterValidationError? lastNameError(String value) {
    if (value.trim().isEmpty) return RegisterValidationError.empty;
    return null;
  }

  RegisterValidationError? emailError(String value) {
    if (value.isEmpty) return RegisterValidationError.empty;
    if (!_emailPattern.hasMatch(value.trim())) {
      return RegisterValidationError.invalid;
    }
    return null;
  }

  RegisterValidationError? passwordError(String value) {
    if (value.isEmpty) return RegisterValidationError.empty;
    if (!_passwordPattern.hasMatch(value)) {
      return RegisterValidationError.invalid;
    }
    return null;
  }

  RegisterValidationError? confirmPasswordError(String confirm, String password) {
    if (confirm.isEmpty) return RegisterValidationError.empty;
    if (confirm != password) return RegisterValidationError.mismatch;
    return null;
  }

  RegisterValidationError? phoneError(String value) {
    if (value.trim().isEmpty) return RegisterValidationError.empty;
    if (!_phonePattern.hasMatch(value)) return RegisterValidationError.invalid;
    return null;
  }
}
