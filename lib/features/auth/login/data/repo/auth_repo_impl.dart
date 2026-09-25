import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/core/network/token_storage.dart';
import 'package:flower_app/features/auth/login/data/data_source/remote/auth_remote_data_source.dart';
import 'package:flower_app/features/auth/login/data/models/login_request.dart';
import 'package:flower_app/features/auth/login/domain/entity/auth_entity.dart';
import 'package:flower_app/features/auth/login/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepo)
class AuthRepositoryImpl implements AuthRepo {
  final AuthRemoteDataSource remoteDatasource;
  final SafeCall safeCall;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl(this.remoteDatasource, this.safeCall, this.tokenStorage);

  @override
  Future<BaseResponse<AuthEntity>> signIn(LoginRequest request) {
    return safeCall.safeApiCall(() async {
      final response = await remoteDatasource.login(request);
      final data = response.data;
      if (data == null) {
        throw StateError(
          response.message ?? 'Login response did not contain data',
        );
      }
      await tokenStorage.saveTokens(
        accessToken: data.token,
        refreshToken: data.refreshToken,
      );
      return data.toDomain();
    });
  }

  @override
  Future<void> signOut() {
    return tokenStorage.clearTokens();
  }
}