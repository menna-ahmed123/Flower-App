import 'package:flower_app/features/auth/register/domain/models/register_request.dart';
import 'package:flower_app/features/auth/register/domain/models/register_result.dart';

abstract interface class RegisterRemoteDataSource {
  Future<RegisterResult> register(RegisterRequest request);
}
