import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flower_app/core/network/token_refresher.dart';
import 'package:flower_app/core/network/token_storage.dart';
import 'package:injectable/injectable.dart';

/// Thrown by [TokenRefreshCoordinator.refresh] when the backend confirms
/// the refresh token itself is invalid or expired (HTTP 401/400 on the
/// refresh call). The session is already cleared by the time this is
/// thrown — callers should surface a "please log in again" experience.
class SessionExpiredException implements Exception {
  const SessionExpiredException();
}

/// Single source of truth for performing a token refresh and persisting
/// the result.
///
/// Both the reactive path (401 from a normal request, see
/// [AuthInterceptors]) and the proactive path (see [TokenRefreshScheduler])
/// call [refresh]. Concurrent callers share one in-flight HTTP call
/// (single-flight), so a reactive 401 firing at the same moment as a
/// scheduled proactive refresh never triggers two refresh calls.
@lazySingleton
class TokenRefreshCoordinator {
  TokenRefreshCoordinator(this._tokenStorage, this._tokenRefresher);

  final TokenStorage _tokenStorage;
  final TokenRefresher _tokenRefresher;

  Completer<AuthTokens?>? _inFlight;

  final _sessionExpiredController = StreamController<void>.broadcast();

  /// Fires whenever [refresh] confirms the refresh token itself is
  /// invalid/expired (the same moment [SessionExpiredException] is
  /// thrown). Listen to this to react globally — e.g. navigate to the
  /// login screen — without every caller of [refresh] needing to check
  /// for [SessionExpiredException] itself.
  Stream<void> get sessionExpired => _sessionExpiredController.stream;

  /// Reads the current refresh token from storage, exchanges it for new
  /// tokens, and persists them.
  ///
  /// Returns `null` when there's no refresh token to use, or the backend
  /// reported failure without a transport-level error (nothing to do,
  /// caller should surface the original error).
  /// Throws [SessionExpiredException] when the refresh token itself is
  /// invalid/expired (already cleared from storage).
  /// Rethrows [DioException] for transient network/server errors so
  /// callers can retry later instead of treating it as session-ending.
  Future<AuthTokens?> refresh() {
    final existing = _inFlight;
    if (existing != null) {
      return existing.future;
    }

    final completer = Completer<AuthTokens?>();
    _inFlight = completer;
    // Fire-and-forget: _run reports its outcome through `completer`
    // (including errors), so nothing is lost by not awaiting it here.
    // ignore: discarded_futures
    _run(completer);
    return completer.future;
  }

  Future<void> _run(Completer<AuthTokens?> completer) async {
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        completer.complete(null);
        return;
      }

      final tokens = await _tokenRefresher.refresh(refreshToken);
      if (tokens == null) {
        completer.complete(null);
        return;
      }

      await _persist(tokens);
      completer.complete(tokens);
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      if (status == 401 || status == 400) {
        await _tokenStorage.clearTokens();
        _sessionExpiredController.add(null);
        completer.completeError(const SessionExpiredException());
      } else {
        completer.completeError(error, error.stackTrace);
      }
    } catch (error, stackTrace) {
      completer.completeError(error, stackTrace);
    } finally {
      _inFlight = null;
    }
  }

  Future<void> _persist(AuthTokens tokens) async {
    final newRefresh = tokens.refreshToken;
    if (newRefresh != null && newRefresh.isNotEmpty) {
      await _tokenStorage.saveTokens(
        accessToken: tokens.accessToken,
        refreshToken: newRefresh,
        expiresIn: tokens.expiresIn,
      );
    } else {
      await _tokenStorage.saveAccessToken(
        tokens.accessToken,
        expiresIn: tokens.expiresIn,
      );
    }
  }
}