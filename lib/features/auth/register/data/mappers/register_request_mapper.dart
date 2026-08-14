import 'package:flower_app/features/auth/register/domain/models/register_request.dart';

class RegisterRequestMapper {
  const RegisterRequestMapper._();

  static Map<String, dynamic> toApiBody(RegisterRequest request) {
    return {
      'fullName': '${request.firstName} ${request.lastName}'.trim(),
      'email': request.email,
      'phoneNumber': request.phoneNumber,
      'gender': request.gender.apiValue,
      'password': request.password,
      // API requires confirmPassword; UI already validated the match.
      'confirmPassword': request.password,
    };
  }
}
