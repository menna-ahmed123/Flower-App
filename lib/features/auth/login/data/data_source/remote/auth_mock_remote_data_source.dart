import 'package:flower_app/core/di/app_environment.dart';
import 'package:flower_app/core/dummy/dummy_network.dart';
import 'package:flower_app/features/auth/login/data/data_source/remote/auth_remote_data_source.dart';
import 'package:flower_app/features/auth/login/data/models/login_request.dart';
import 'package:flower_app/features/auth/login/data/models/login_response.dart';
import 'package:injectable/injectable.dart';

/// Temporary login backend until [AppEnvironment.prod] is enabled.
@Injectable(as: AuthRemoteDataSource, env: [AppEnvironment.mock])
class AuthMockRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<LoginResponse> login(LoginRequest request) async {
    await DummyNetwork.wait();
    return LoginResponse(
      isSuccess: true,
      statusCode: 200,
      message: 'Login successful',
      data: LoginData(
        accessToken:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.dummy-access-token.user-001',
        refreshToken: 'dummy-refresh-token-user-001',
        expiresIn: 3600,
        role: 'Customer',
        canAccessDriverHome: false,
      ),
    );
  }
}
