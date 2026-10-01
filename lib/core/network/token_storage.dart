import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

/// Persists authentication tokens using the project's secure storage.
///
/// Access token key [SecureTokenStorage.accessTokenKey] matches the existing
/// interceptor contract (`USER_TOKEN`) so current authenticated requests
/// keep working.
abstract interface class TokenStorage {
  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  /// The access token's expiry, computed and stored at save time.
  /// Returns `null` if unknown (e.g. saved before expiry tracking existed,
  /// or the backend didn't return `expiresIn`).
  Future<DateTime?> getAccessTokenExpiry();

  /// [expiresIn] is the access token lifetime in seconds, as returned by
  /// the backend. Pass it whenever available so proactive refresh can be
  /// scheduled; omit only if genuinely unknown.
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    int? expiresIn,
  });

  Future<void> saveAccessToken(String accessToken, {int? expiresIn});

  Future<void> clearTokens();
}

@LazySingleton(as: TokenStorage)
class SecureTokenStorage implements TokenStorage {
  SecureTokenStorage(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  /// Existing project key used by [AuthInterceptors] before refresh support.
  static const accessTokenKey = 'USER_TOKEN';
  static const refreshTokenKey = 'REFRESH_TOKEN';
  static const accessTokenExpiryKey = 'ACCESS_TOKEN_EXPIRY';

  @override
  Future<String?> getAccessToken() {
    return _secureStorage.read(key: accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() {
    return _secureStorage.read(key: refreshTokenKey);
  }

  @override
  Future<DateTime?> getAccessTokenExpiry() async {
    final raw = await _secureStorage.read(key: accessTokenExpiryKey);
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    int? expiresIn,
  }) async {
    await Future.wait([
      _secureStorage.write(key: accessTokenKey, value: accessToken),
      _secureStorage.write(key: refreshTokenKey, value: refreshToken),
      _writeExpiry(expiresIn),
    ]);
  }

  @override
  Future<void> saveAccessToken(String accessToken, {int? expiresIn}) async {
    await Future.wait([
      _secureStorage.write(key: accessTokenKey, value: accessToken),
      _writeExpiry(expiresIn),
    ]);
  }

  Future<void> _writeExpiry(int? expiresIn) async {
    if (expiresIn == null) return;
    final expiry = DateTime.now().toUtc().add(Duration(seconds: expiresIn));
    await _secureStorage.write(
      key: accessTokenExpiryKey,
      value: expiry.toIso8601String(),
    );
  }

  @override
  Future<void> clearTokens() async {
    await Future.wait([
      _secureStorage.delete(key: accessTokenKey),
      _secureStorage.delete(key: refreshTokenKey),
      _secureStorage.delete(key: accessTokenExpiryKey),
    ]);
  }
}