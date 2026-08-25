import 'package:flower_app/features/auth/register/data/api/register_api_client.dart';
import 'package:flower_app/features/auth/register/data/data_source/remote/register_remote_data_source.dart';
import 'package:flower_app/features/auth/register/data/models/register_request.dart';
import 'package:flower_app/features/auth/register/data/models/register_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: RegisterRemoteDataSource, env: ['prod'])
class RegisterRemoteDataSourceImpl implements RegisterRemoteDataSource {
  final RegisterApiClient registerApiClient;

  RegisterRemoteDataSourceImpl(this.registerApiClient);

  @override
  Future<RegisterResponse> register(RegisterRequest request) {
    return registerApiClient.register(request);
  }
}
