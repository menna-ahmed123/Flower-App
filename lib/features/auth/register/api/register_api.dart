import 'package:flower_app/features/auth/register/domain/models/register_request.dart';
import 'package:flower_app/features/auth/register/domain/models/register_result.dart';

abstract interface class RegisterApi {
  Future<RegisterResult> register(RegisterRequest request);
}
