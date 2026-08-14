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
    return _changedFieldErrors(field, input);
  }

  RegisterFieldErrors _changedFieldErrors(
    RegisterField field,
    RegisterFormInput input,
  ) {
    return switch (field) {
      RegisterField.firstName => _firstNameErrors(input),
      RegisterField.lastName => _lastNameErrors(input),
      RegisterField.email => _emailErrors(input),
      RegisterField.password => _passwordFieldErrors(input),
      RegisterField.confirmPassword => _confirmPasswordErrors(input),
      RegisterField.phoneNumber => _phoneErrors(input),
    };
  }

  RegisterFieldErrors _firstNameErrors(RegisterFormInput input) {
    return RegisterFieldErrors(firstName: firstNameError(input.firstName));
  }

  RegisterFieldErrors _lastNameErrors(RegisterFormInput input) {
    return RegisterFieldErrors(lastName: lastNameError(input.lastName));
  }

  RegisterFieldErrors _emailErrors(RegisterFormInput input) {
    return RegisterFieldErrors(email: emailError(input.email));
  }

  RegisterFieldErrors _confirmPasswordErrors(RegisterFormInput input) {
    return RegisterFieldErrors(
      confirmPassword: confirmPasswordError(
        input.confirmPassword,
        input.password,
      ),
    );
  }

  RegisterFieldErrors _phoneErrors(RegisterFormInput input) {
    return RegisterFieldErrors(phoneNumber: phoneError(input.phoneNumber));
  }

  RegisterFieldErrors _passwordFieldErrors(RegisterFormInput input) {
    return RegisterFieldErrors(
      password: passwordError(input.password),
      confirmPassword: confirmPasswordError(
        input.confirmPassword,
        input.password,
      ),
    );
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

  RegisterValidationError? confirmPasswordError(
    String confirm,
    String password,
  ) {
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
