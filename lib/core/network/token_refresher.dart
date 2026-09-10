import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:injectable/injectable.dart';

/// Pair of tokens returned by a successful refresh (or login) operation.
class AuthTokens {
  const AuthTokens({required this.accessToken, this.refreshToken});

  final String accessToken;

  /// When null, the existing refresh token should be kept.
  final String? refreshToken;
}

/// Performs the HTTP refresh-token call.
abstract interface class TokenRefresher {
  /// Exchanges [refreshToken] for a new [AuthTokens] pair.
  ///
  /// Returns `null` when refresh cannot be performed (not configured, or
  /// backend reported failure without a transport-level error).
  /// Throws [DioException] (or other) on transport/HTTP failure so the
  /// interceptor can distinguish network errors from auth expiration.
  Future<AuthTokens?> refresh(String refreshToken);
}

/// Real implementation calling `POST /api/v1/identity/auth/refresh`.
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

  static const _refreshPath = '/identity/auth/refresh';

  @override
  Future<AuthTokens?> refresh(String refreshToken) async {
    // Let DioException propagate as-is (network/400/401/etc.) so
    // AuthInterceptors can tell an expired refresh token apart from a
    // transient network/server error.
    final response = await _dio.post<Map<String, dynamic>>(
      _refreshPath,
      data: {'refreshToken': refreshToken},
    );

    final body = response.data;
    if (body == null || body['isSuccess'] != true) {
      return null;
    }

    final data = body['data'];
    if (data is! Map<String, dynamic>) {
      return null;
    }

    final accessToken = data['accessToken'];
    if (accessToken is! String || accessToken.isEmpty) {
      return null;
    }

    final newRefreshToken = data['refreshToken'];
    return AuthTokens(
      accessToken: accessToken,
      refreshToken: newRefreshToken is String ? newRefreshToken : null,
    );
  }
}