import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/helpers/app_validators.dart';
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

  RegisterFieldErrors validate(RegisterFormInput input) {
    return RegisterFieldErrors(
      firstName: firstNameError(input.firstName),
      lastName: lastNameError(input.lastName),
      email: emailError(input.email),
      password: passwordError(input.password),
      confirmPassword: confirmPasswordError(input.confirmPassword, input.password),
      phoneNumber: phoneError(input.phoneNumber),
    );
  }

  RegisterFieldErrors validateChangedField(
    RegisterField field,
    RegisterFormInput input,
  ) {
    return switch (field) {
      RegisterField.firstName => RegisterFieldErrors(firstName: firstNameError(input.firstName)),
      RegisterField.lastName => RegisterFieldErrors(lastName: lastNameError(input.lastName)),
      RegisterField.email => RegisterFieldErrors(email: emailError(input.email)),
      RegisterField.password => RegisterFieldErrors(
        password: passwordError(input.password),
        confirmPassword: confirmPasswordError(input.confirmPassword, input.password),
      ),
      RegisterField.confirmPassword => RegisterFieldErrors(
        confirmPassword: confirmPasswordError(input.confirmPassword, input.password),
      ),
      RegisterField.phoneNumber => RegisterFieldErrors(phoneNumber: phoneError(input.phoneNumber)),
    };
  }

  String? firstNameError(String value) =>
      AppValidators.requiredField(value, field: AppString.firstName);

  String? lastNameError(String value) =>
      AppValidators.requiredField(value, field: AppString.lastName);

  String? emailError(String value) => AppValidators.emailValidator(value);

  String? passwordError(String value) =>
      AppValidators.registrationPasswordValidator(value);

  String? confirmPasswordError(String confirm, String password) =>
      AppValidators.confirmPasswordValidator(confirm, password);

  String? phoneError(String value) => AppValidators.phoneValidator(value);
}
