import 'package:injectable/injectable.dart';

import '../../../network/token_storage.dart';
import '../../domain/repos/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._tokenStorage);

  final TokenStorage _tokenStorage;

  @override
  Future<bool> isAuthenticated() async {
    final token = await _tokenStorage.getAccessToken();

    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> logout() async {
    await _tokenStorage.clearTokens();
  }
}
