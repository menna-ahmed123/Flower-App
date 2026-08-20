import 'package:flower_app/features/auth/register/data/models/register_request.dart';
import 'package:flower_app/features/auth/register/data/models/register_response.dart';

abstract interface class RegisterRemoteDataSource {
  Future<RegisterResponse> register(RegisterRequest request);
}
