import 'package:flower_app/features/auth/register/domain/models/register_request.dart';
import 'package:flower_app/features/auth/register/domain/validators/register_form_validator.dart';
import 'package:flower_app/features/auth/register/presentation/state/register_state.dart';

class RegisterStateMapper {
  const RegisterStateMapper._();

  static RegisterRequest toRequest(RegisterState state) {
    return RegisterRequest(
      firstName: state.firstName.trim(),
      lastName: state.lastName.trim(),
      email: state.email.trim(),
      password: state.password,
      phoneNumber: state.phoneNumber.trim(),
      gender: state.gender,
    );
  }

  static RegisterFormInput toFormInput(RegisterState state) {
    return RegisterFormInput(
      firstName: state.firstName,
      lastName: state.lastName,
      email: state.email,
      password: state.password,
      confirmPassword: state.confirmPassword,
      phoneNumber: state.phoneNumber,
    );
  }
}
