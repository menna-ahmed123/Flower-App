import 'package:injectable/injectable.dart';

/// Pair of tokens returned by a successful refresh (or login) operation.
///
/// Field names follow common backend conventions. When the auth feature is
/// wired to the real API, map the backend JSON into this model — do not invent
/// extra fields (e.g. `expiresIn`) unless the backend actually returns them.
class AuthTokens {
  const AuthTokens({required this.accessToken, this.refreshToken});

  final String accessToken;

  /// When null, the existing refresh token should be kept.
  final String? refreshToken;
}

/// Performs the HTTP refresh-token call.
///
/// **Backend contract is not defined in this repository yet.**
/// The auth feature must replace [UnconfiguredTokenRefresher] with a real
/// implementation once the refresh endpoint, method, body, and response are known.
abstract interface class TokenRefresher {
  /// Exchanges [refreshToken] for a new [AuthTokens] pair.
  ///
  /// Returns `null` when refresh cannot be performed (not configured).
  /// Throws [DioException] (or other) on transport/HTTP failure so the
  /// interceptor can distinguish network errors from auth expiration.
  Future<AuthTokens?> refresh(String refreshToken);
}

/// Placeholder until the real refresh API contract is available.
///
/// Returns `null` so the interceptor skips refresh without inventing an
/// endpoint and without clearing the current session.
@LazySingleton(as: TokenRefresher)
class UnconfiguredTokenRefresher implements TokenRefresher {
  @override
  Future<AuthTokens?> refresh(String refreshToken) async {
    return null;
  }
}
