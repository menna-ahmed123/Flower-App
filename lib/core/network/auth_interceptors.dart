import 'dart:async';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/core/localization/locale_controller.dart';
import 'package:flower_app/core/network/token_refresher.dart';
import 'package:flower_app/core/network/token_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// Request [RequestOptions.extra] keys used by [AuthInterceptors].
abstract final class AuthRequestExtra {
  /// Marks a request that has already been retried after a token refresh.
  static const retried = 'auth_retried';

  /// Marks the refresh-token HTTP call so it never triggers another refresh.
  static const skipRefresh = 'skip_auth_refresh';
}

/// Attaches JWT, Accept-Language, and transparently refreshes on 401.
///
/// Header contract matches Team 1 Postman: `Authorization: Bearer <token>`.
@lazySingleton
class AuthInterceptors extends Interceptor {
  AuthInterceptors(
    this._tokenStorage,
    this._tokenRefresher,
    this._localeController,
  );

  final TokenStorage _tokenStorage;
  final TokenRefresher _tokenRefresher;
  final LocaleController _localeController;

  /// Set by [DioModule] after Dio is created to avoid a DI cycle.
  Dio? _dio;

  Completer<AuthTokens?>? _refreshCompleter;

  void attachDio(Dio dio) {
    _dio = dio;
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['Accept-Language'] = _acceptLanguage;
    final token = await _tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      _applyBearer(options, token);
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
      final tokens = await _refreshTokens(refreshToken);
      if (tokens == null) {
        // Refresher not wired to a backend yet — do not invent an API call
        // or clear a still-valid session; surface the original 401.
        _log('Token refresh skipped: refresher not configured');
        return handler.next(err);
      }

      await _persistTokens(tokens, refreshToken);
      _log('Token refresh succeeded');

      final response = await _retryRequest(options, tokens.accessToken);
      return handler.resolve(response);
    } on DioException catch (refreshError) {
      final refreshStatus = refreshError.response?.statusCode;
      if (refreshStatus == 401 || refreshStatus == 400) {
        _log('Token refresh failed: refresh token invalid or expired');
        await _expireSession();
        return handler.reject(_sessionExpiredException(err));
      }

      _log('Token refresh failed: network or server error');
      return handler.next(refreshError);
    } catch (_) {
      _log('Token refresh failed: unexpected error');
      await _expireSession();
      return handler.reject(_sessionExpiredException(err));
    }
  }

  /// Single-flight refresh: concurrent 401s share one refresh Future.
  Future<AuthTokens?> _refreshTokens(String refreshToken) {
    final inFlight = _refreshCompleter;
    if (inFlight != null) {
      return inFlight.future;
    }

    final completer = Completer<AuthTokens?>();
    _refreshCompleter = completer;

    Future<void>(() async {
      try {
        final tokens = await _tokenRefresher.refresh(refreshToken);
        if (!completer.isCompleted) {
          completer.complete(tokens);
        }
      } catch (error, stackTrace) {
        if (!completer.isCompleted) {
          completer.completeError(error, stackTrace);
        }
      } finally {
        _refreshCompleter = null;
      }
    });

    return completer.future;
  }

  Future<void> _persistTokens(
    AuthTokens tokens,
    String currentRefreshToken,
  ) async {
    final newRefresh = tokens.refreshToken;
    if (newRefresh != null && newRefresh.isNotEmpty) {
      await _tokenStorage.saveTokens(
        accessToken: tokens.accessToken,
        refreshToken: newRefresh,
      );
    } else {
      await _tokenStorage.saveAccessToken(tokens.accessToken);
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

    _applyBearer(options, accessToken);
    options.extra[AuthRequestExtra.retried] = true;

    return dio.fetch<dynamic>(options);
  }

  Future<void> _expireSession() async {
    await _tokenStorage.clearTokens();
    _log('Session expired');
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

  String get _acceptLanguage {
    return _localeController.resolvedLocale.languageCode;
  }

  void _applyBearer(RequestOptions options, String token) {
    options.headers['Authorization'] = 'Bearer $token';
    options.headers.remove('token');
  }

  void _log(String message) {
    if (kDebugMode) {
      developer.log(message, name: 'AuthInterceptors');
    }
  }
}
