import 'package:flower_app/features/auth/login/data/api/auth_api_client.dart';
import 'package:flower_app/features/auth/login/data/data_source/remote/auth_remote_data_source.dart';
import 'package:flower_app/features/auth/login/data/models/login_request.dart';
import 'package:flower_app/features/auth/login/data/models/login_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRemoteDataSource,)
class AuthRemoteDatasourceImpl implements AuthRemoteDataSource {
  final AuthApiClient authApiClient;

  AuthRemoteDatasourceImpl(this.authApiClient);

  @override
  Future<LoginResponse> login(LoginRequest request) {
    return authApiClient.login(request);
  }
}
