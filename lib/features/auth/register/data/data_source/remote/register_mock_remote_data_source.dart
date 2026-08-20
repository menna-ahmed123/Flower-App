import 'package:flower_app/core/di/app_environment.dart';
import 'package:flower_app/core/dummy/dummy_network.dart';
import 'package:flower_app/features/auth/register/data/data_source/remote/register_remote_data_source.dart';
import 'package:flower_app/features/auth/register/data/models/register_request.dart';
import 'package:flower_app/features/auth/register/data/models/register_response.dart';
import 'package:injectable/injectable.dart';

/// Temporary register backend until [AppEnvironment.prod] is enabled.
@Injectable(as: RegisterRemoteDataSource, env: [AppEnvironment.mock])
class RegisterMockRemoteDataSource implements RegisterRemoteDataSource {
  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    await DummyNetwork.wait();
    return RegisterResponse(
      isSuccess: true,
      statusCode: 201,
      message: 'Account created successfully',
      data: RegisterData(
        userId: 'c7e2a1f0-4b3d-4c8a-9f12-8d6e5a4b3c21',
        email: request.email,
        role: 'Customer',
        status: 'Active',
      ),
    );
  }
}
