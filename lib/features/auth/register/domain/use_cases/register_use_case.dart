import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/auth/register/domain/models/register_request.dart';
import 'package:flower_app/features/auth/register/domain/models/register_result.dart';

abstract interface class RegisterUseCase {
  Future<BaseResponse<RegisterResult>> call(RegisterRequest request);
}
