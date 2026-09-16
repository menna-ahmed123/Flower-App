import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/core/network/token_refresh_coordinator.dart';
import 'package:flower_app/core/network/token_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// Request [RequestOptions.extra] keys used by [AuthInterceptors].
abstract final class AuthRequestExtra {
  /// Marks a request that has already been retried after a token refresh.
  static const retried = 'auth_retried';

  /// Marks the refresh-token HTTP call so it never triggers another refresh.
  ///
  /// Currently unused: [ApiTokenRefresher] performs the refresh call on its
  /// own [Dio] instance (no [AuthInterceptors] attached), so it can never
  /// re-enter this interceptor. Kept for forward compatibility in case the
  /// refresh call is ever routed through the main Dio instance.
  static const skipRefresh = 'skip_auth_refresh';
}

/// Attaches the access token and transparently refreshes on 401.
///
/// Header contract: `Authorization: Bearer <accessToken>`.
///
/// Refresh itself (both the HTTP call and single-flight de-duplication) is
/// delegated to [TokenRefreshCoordinator], which is shared with
/// [TokenRefreshScheduler] so a proactive refresh and a reactive 401 never
/// race each other into two HTTP calls.
@lazySingleton
class AuthInterceptors extends Interceptor {
  AuthInterceptors(this._tokenStorage, this._coordinator);

  final TokenStorage _tokenStorage;
  final TokenRefreshCoordinator _coordinator;

  /// Set by [DioModule] after Dio is created to avoid a DI cycle.
  Dio? _dio;

  void attachDio(Dio dio) {
    _dio = dio;
  }

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final token = await _tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onResponse(
      Response<dynamic> response,
      ResponseInterceptorHandler handler,
      ) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _handleError(err, handler);
  }

  Future<void> _handleError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {
    final options = err.requestOptions;
    final statusCode = err.response?.statusCode;
    final skipRefresh = options.extra[AuthRequestExtra.skipRefresh] == true;
    final alreadyRetried = options.extra[AuthRequestExtra.retried] == true;

    if (statusCode != 401 || skipRefresh || alreadyRetried) {
      return handler.next(err);
    }

    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      _log('Token refresh skipped: no refresh token');
      return handler.next(err);
    }

    try {
      _log('Token refresh started');
      final tokens = await _coordinator.refresh();
      if (tokens == null) {
        // Backend reported failure without a transport-level error — do
        // not clear a potentially still-valid session; surface the
        // original 401.
        _log('Token refresh skipped: no tokens returned');
        return handler.next(err);
      }

      _log('Token refresh succeeded');

      final response = await _retryRequest(options, tokens.accessToken);
      return handler.resolve(response);
    } on SessionExpiredException {
      _log('Token refresh failed: refresh token invalid or expired');
      return handler.reject(_sessionExpiredException(err));
    } on DioException catch (_) {
      _log('Token refresh failed: network or server error');
      return handler.next(err);
    } catch (_) {
      _log('Token refresh failed: unexpected error');
      await _tokenStorage.clearTokens();
      return handler.reject(_sessionExpiredException(err));
    }
  }

  Future<Response<dynamic>> _retryRequest(
      RequestOptions options,
      String accessToken,
      ) {
    final dio = _dio;
    if (dio == null) {
      throw StateError('AuthInterceptors.attachDio was not called');
    }

    options.headers['Authorization'] = 'Bearer $accessToken';
    options.extra[AuthRequestExtra.retried] = true;

    return dio.fetch<dynamic>(options);
  }

  DioException _sessionExpiredException(DioException original) {
    return DioException(
      requestOptions: original.requestOptions,
      response: original.response,
      type: DioExceptionType.badResponse,
      error: ForceLogin(),
      message: 'Session expired',
    );
  }

  void _log(String message) {
    if (kDebugMode) {
      developer.log(message, name: 'AuthInterceptors');
    }
  }
}