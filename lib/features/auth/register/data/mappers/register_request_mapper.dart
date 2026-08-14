import 'package:flower_app/features/auth/register/data/models/register_request_dto.dart';
import 'package:flower_app/features/auth/register/domain/models/register_request.dart';

class RegisterRequestMapper {
  const RegisterRequestMapper._();

  static RegisterRequestDto toDto(RegisterRequest request) {
    return RegisterRequestDto(
      fullName: '${request.firstName} ${request.lastName}'.trim(),
      email: request.email,
      phoneNumber: request.phoneNumber,
      gender: request.gender.apiValue,
      password: request.password,
      confirmPassword: request.password,
    );
  }
}
