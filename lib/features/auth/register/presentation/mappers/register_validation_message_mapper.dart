import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/auth/register/domain/validators/register_field_errors.dart';

class RegisterValidationMessageMapper {
  const RegisterValidationMessageMapper._();

  static String? message(RegisterField field, RegisterValidationError? error) {
    if (error == null) return null;
    return _messages[field]?[error];
  }

  static final Map<RegisterField, Map<RegisterValidationError, String>>
  _messages = {
    RegisterField.firstName: {
      RegisterValidationError.empty: AppString.fieldIsRequired(
        AppString.firstName,
      ),
    },
    RegisterField.lastName: {
      RegisterValidationError.empty: AppString.fieldIsRequired(
        AppString.lastName,
      ),
    },
    RegisterField.email: {
      RegisterValidationError.empty: AppString.pleaseEnterYourEmail,
      RegisterValidationError.invalid: AppString.pleaseEnterValidEmail,
    },
    RegisterField.password: {
      RegisterValidationError.empty: AppString.passwordIsRequired,
      RegisterValidationError.invalid:
          AppString.registrationPasswordRequirement,
    },
    RegisterField.confirmPassword: {
      RegisterValidationError.empty: AppString.confirmPasswordIsRequired,
      RegisterValidationError.mismatch: AppString.passwordsDoNotMatch,
    },
    RegisterField.phoneNumber: {
      RegisterValidationError.empty: AppString.phoneNumberIsRequired,
      RegisterValidationError.invalid: AppString.validEgyptianPhone,
    },
  };
}
