import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

/// Persists authentication tokens using the project's secure storage.
///
/// Access token key [accessTokenKey] matches the existing interceptor contract
/// (`USER_TOKEN`) so current authenticated requests keep working.
abstract interface class TokenStorage {
  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });

  Future<void> saveAccessToken(String accessToken);

  Future<void> clearTokens();
}

@LazySingleton(as: TokenStorage)
class SecureTokenStorage implements TokenStorage {
  SecureTokenStorage(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  /// Existing project key used by [AuthInterceptors] before refresh support.
  static const accessTokenKey = 'USER_TOKEN';
  static const refreshTokenKey = 'REFRESH_TOKEN';

  @override
  Future<String?> getAccessToken() {
    return _secureStorage.read(key: accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() {
    return _secureStorage.read(key: refreshTokenKey);
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _secureStorage.write(key: accessTokenKey, value: accessToken),
      _secureStorage.write(key: refreshTokenKey, value: refreshToken),
    ]);
  }

  @override
  Future<void> saveAccessToken(String accessToken) {
    return _secureStorage.write(key: accessTokenKey, value: accessToken);
  }

  @override
  Future<void> clearTokens() async {
    await Future.wait([
      _secureStorage.delete(key: accessTokenKey),
      _secureStorage.delete(key: refreshTokenKey),
    ]);
  }
}
