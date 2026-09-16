import 'package:flower_app/core/network/token_storage.dart';

/// In-memory [TokenStorage] for unit tests.
class FakeTokenStorage implements TokenStorage {
  String? accessToken;
  String? refreshToken;
  DateTime? accessTokenExpiry;
  int clearCount = 0;

  @override
  Future<String?> getAccessToken() async => accessToken;

  @override
  Future<String?> getRefreshToken() async => refreshToken;

  @override
  Future<DateTime?> getAccessTokenExpiry() async => accessTokenExpiry;

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    int? expiresIn,
  }) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
    if (expiresIn != null) {
      accessTokenExpiry = DateTime.now().toUtc().add(
        Duration(seconds: expiresIn),
      );
    }
  }

  @override
  Future<void> saveAccessToken(String accessToken, {int? expiresIn}) async {
    this.accessToken = accessToken;
    if (expiresIn != null) {
      accessTokenExpiry = DateTime.now().toUtc().add(
        Duration(seconds: expiresIn),
      );
    }
  }

  @override
  Future<void> clearTokens() async {
    clearCount++;
    accessToken = null;
    refreshToken = null;
    accessTokenExpiry = null;
  }
}