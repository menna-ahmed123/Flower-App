import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/core/network/refresh_token_models.dart';
import 'package:injectable/injectable.dart';

/// Pair of tokens returned by a successful refresh (or login) operation.
class AuthTokens {
  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    this.expiresIn,
  });

  final String accessToken;
  final String refreshToken;

  /// Access token lifetime in seconds, when the backend returns it.
  /// Used to schedule the next proactive refresh.
  final int? expiresIn;
}

/// Performs the HTTP refresh-token call.
abstract interface class TokenRefresher {
  /// Exchanges [refreshToken] for a new [AuthTokens] pair.
  ///
  /// Returns `null` when refresh cannot be performed (not configured, or
  /// backend reported failure without a transport-level error).
  /// Throws [DioException] (or other) on transport/HTTP failure so the
  /// caller can distinguish network errors from auth expiration.
  Future<AuthTokens?> refresh(String refreshToken);
}

/// Real implementation calling `POST /api/identity/auth/refresh-token`.
///
/// Uses its own [Dio] instance (no [AuthInterceptors] attached) so the
/// refresh call can never trigger another refresh or get stuck in a loop.
@LazySingleton(as: TokenRefresher)
class ApiTokenRefresher implements TokenRefresher {
  ApiTokenRefresher()
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiEndpoints.resolvedBaseUrl,
          connectTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: const {'Content-Type': 'application/json'},
        ),
      );

  final Dio _dio;

  @override
  Future<AuthTokens?> refresh(String refreshToken) async {
    // Let DioException propagate as-is (network/400/401/etc.) so the
    // caller can tell an expired refresh token apart from a transient
    // network/server error.
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.refreshToken,
      data: RefreshTokenRequest(refreshToken: refreshToken).toJson(),
    );

    final body = response.data;
    if (body == null) {
      return null;
    }

    final parsed = RefreshTokenResponse.fromJson(body);
    if (parsed.status != true || parsed.data == null) {
      return null;
    }

    final data = parsed.data!;
    if (data.token.isEmpty || data.refreshToken.isEmpty) {
      return null;
    }

    return AuthTokens(accessToken: data.token, refreshToken: data.refreshToken);
  }
}
