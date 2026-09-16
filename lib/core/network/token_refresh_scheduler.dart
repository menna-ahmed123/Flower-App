import 'dart:async';
import 'dart:developer' as developer;

import 'package:flower_app/core/network/token_refresh_coordinator.dart';
import 'package:flower_app/core/network/token_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

/// Schedules a proactive token refresh shortly before the access token
/// expires, so most requests never hit a 401 in the first place.
///
/// This is a complement to, not a replacement for, the reactive 401 flow
/// in [AuthInterceptors] — if the app was killed/suspended past the
/// scheduled time (timers don't fire while suspended on iOS/Android), the
/// reactive flow still catches it on the next real request.
@lazySingleton
class TokenRefreshScheduler with WidgetsBindingObserver {
  TokenRefreshScheduler(this._tokenStorage, this._coordinator);

  final TokenStorage _tokenStorage;
  final TokenRefreshCoordinator _coordinator;

  /// Refresh this long before the actual expiry, to leave room for the
  /// network round-trip and clock differences between client and server.
  static const _safetyMargin = Duration(seconds: 30);

  /// Backoff before retrying after a transient (network/server) failure,
  /// so a temporary outage doesn't silently give up on proactive refresh
  /// for the rest of the session.
  static const _retryDelay = Duration(seconds: 30);

  Timer? _timer;
  bool _active = false;
  bool _observing = false;

  /// Call once the user is known to be authenticated: right after a
  /// successful login, or on app start when [TokenStorage] already has a
  /// valid session.
  Future<void> start() async {
    _active = true;
    if (!_observing) {
      WidgetsBinding.instance.addObserver(this);
      _observing = true;
    }
    await _scheduleFromStorage();
  }

  /// Call on logout (or whenever the session ends) to stop scheduling
  /// further refreshes.
  void stop() {
    _active = false;
    _timer?.cancel();
    _timer = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_active || state != AppLifecycleState.resumed) {
      return;
    }
    // Timers don't run while the app is suspended, so the scheduled
    // refresh may have been missed — re-check as soon as we're back.
    // ignore: discarded_futures
    _scheduleFromStorage();
  }

  Future<void> _scheduleFromStorage() async {
    if (!_active) return;
    _timer?.cancel();

    final expiry = await _tokenStorage.getAccessTokenExpiry();
    if (expiry == null) {
      // No known expiry (e.g. backend didn't return expiresIn this time)
      // — nothing to schedule; the reactive 401 flow still covers it.
      _log('Nothing scheduled: no known expiry');
      return;
    }

    final fireAt = expiry.subtract(_safetyMargin);
    final delay = fireAt.difference(DateTime.now().toUtc());

    if (delay.isNegative) {
      await _refreshNow();
      return;
    }

    _log('Scheduled proactive refresh in ${delay.inSeconds}s');
    _timer = Timer(delay, () {
      // ignore: discarded_futures
      _refreshNow();
    });
  }

  Future<void> _refreshNow() async {
    if (!_active) return;

    try {
      _log('Proactive refresh started');
      final tokens = await _coordinator.refresh();
      if (tokens == null) {
        _log('Proactive refresh skipped: no tokens returned');
        return;
      }

      _log('Proactive refresh succeeded');
      await _scheduleFromStorage();
    } on SessionExpiredException {
      // Refresh token is confirmed invalid/expired (already cleared from
      // storage by the coordinator). Don't retry — whichever screen is
      // active will pick this up next time it checks auth state or makes
      // a request that 401s.
      _log('Proactive refresh failed: refresh token invalid or expired');
      stop();
    } catch (_) {
      // Network/server hiccup — retry shortly rather than silently
      // relying on the next real request to 401 first.
      _log('Proactive refresh failed: retrying in ${_retryDelay.inSeconds}s');
      _timer = Timer(_retryDelay, () {
        // ignore: discarded_futures
        _refreshNow();
      });
    }
  }

  void _log(String message) {
    if (kDebugMode) {
      developer.log(message, name: 'TokenRefreshScheduler');
    }
  }
}