import 'package:flower_app/features/auth/register/data/models/register_result_dto.dart';
import 'package:flower_app/features/auth/register/domain/models/register_result.dart';

class RegisterResultMapper {
  const RegisterResultMapper._();

  static RegisterResult toDomain(RegisterResultDto dto) {
    return RegisterResult(
      userId: dto.userId,
      email: dto.email,
      role: dto.role,
      status: dto.status,
      message: dto.message,
    );
  }
}
