import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flower_app/core/network/token_refresh_coordinator.dart';
import 'package:flower_app/core/network/token_refresh_scheduler.dart';
import 'package:flower_app/core/network/token_refresher.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_token_storage.dart';

/// A [TokenRefresher] whose responses are scripted call-by-call. Throwing
/// on an unscripted extra call catches bugs (an unexpected retry) loudly
/// instead of silently reusing the last response.
class _ScriptedTokenRefresher implements TokenRefresher {
  _ScriptedTokenRefresher(this._script);

  final List<Future<AuthTokens?> Function(String refreshToken)> _script;
  int callCount = 0;

  @override
  Future<AuthTokens?> refresh(String refreshToken) {
    final index = callCount;
    callCount++;
    if (index >= _script.length) {
      throw StateError(
        'Unexpected extra call to refresh() (call #${index + 1})',
      );
    }
    return _script[index](refreshToken);
  }
}

DioException _dioError(int statusCode) {
  final options = RequestOptions(path: '/identity/auth/refresh');
  return DioException(
    requestOptions: options,
    response: Response(requestOptions: options, statusCode: statusCode),
    type: DioExceptionType.badResponse,
  );
}

/// Short durations so tests run in milliseconds instead of waiting 30
/// real seconds for every scheduled refresh.
const _safetyMargin = Duration(milliseconds: 40);
const _retryDelay = Duration(milliseconds: 40);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeTokenStorage tokenStorage;

  setUp(() {
    tokenStorage = FakeTokenStorage()
      ..accessToken = 'old-access'
      ..refreshToken = 'old-refresh';
  });

  TokenRefreshScheduler buildScheduler(_ScriptedTokenRefresher refresher) {
    final coordinator = TokenRefreshCoordinator(tokenStorage, refresher);
    return TokenRefreshScheduler.withDurations(
      tokenStorage,
      coordinator,
      safetyMargin: _safetyMargin,
      retryDelay: _retryDelay,
    );
  }

  group('no known expiry', () {
    test('schedules nothing and never calls the refresher', () async {
      tokenStorage.accessTokenExpiry = null;
      final refresher = _ScriptedTokenRefresher([]);
      final scheduler = buildScheduler(refresher);

      await scheduler.start();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(refresher.callCount, 0);
    });
  });

  group('expiry already in the past', () {
    test('refreshes immediately instead of scheduling a timer', () async {
      tokenStorage.accessTokenExpiry = DateTime.now().toUtc().subtract(
        const Duration(seconds: 1),
      );
      final refresher = _ScriptedTokenRefresher([
            (_) async => const AuthTokens(accessToken: 'new', expiresIn: 900),
      ]);
      final scheduler = buildScheduler(refresher);

      await scheduler.start();
      // start() awaits the first _scheduleFromStorage(), which itself
      // awaits _refreshNow() when the expiry has passed, so no extra
      // delay should be needed here — but a tiny one keeps this robust.
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(refresher.callCount, 1);
      expect(tokenStorage.accessToken, 'new');
    });
  });

  group('expiry in the near future', () {
    test('schedules a refresh around safetyMargin before expiry', () async {
      tokenStorage.accessTokenExpiry = DateTime.now().toUtc().add(
        _safetyMargin + const Duration(milliseconds: 30),
      );
      final refresher = _ScriptedTokenRefresher([
            (_) async => const AuthTokens(accessToken: 'new', expiresIn: 900),
      ]);
      final scheduler = buildScheduler(refresher);

      await scheduler.start();

      // Too early: the timer shouldn't have fired yet.
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(refresher.callCount, 0);

      // Past the scheduled time now.
      await Future<void>.delayed(const Duration(milliseconds: 60));
      expect(refresher.callCount, 1);
      expect(tokenStorage.accessToken, 'new');
    });
  });

  group('successful refresh', () {
    test('reschedules itself using the new expiry', () async {
      tokenStorage.accessTokenExpiry = DateTime.now().toUtc().subtract(
        const Duration(seconds: 1),
      );
      final refresher = _ScriptedTokenRefresher([
            (_) async => const AuthTokens(accessToken: 'first', expiresIn: 900),
      ]);
      final scheduler = buildScheduler(refresher);

      await scheduler.start();
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(refresher.callCount, 1);
      // A new expiry ~900s out should now be stored, proving
      // _scheduleFromStorage ran again after the successful refresh.
      expect(
        tokenStorage.accessTokenExpiry!.isAfter(
          DateTime.now().toUtc().add(const Duration(seconds: 800)),
        ),
        isTrue,
      );
    });
  });

  group('refresh token confirmed invalid (401/400)', () {
    test('stops scheduling further attempts', () async {
      tokenStorage.accessTokenExpiry = DateTime.now().toUtc().subtract(
        const Duration(seconds: 1),
      );
      final refresher = _ScriptedTokenRefresher([
            (_) async => throw _dioError(401),
      ]);
      final scheduler = buildScheduler(refresher);

      await scheduler.start();
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(refresher.callCount, 1);
      expect(tokenStorage.clearCount, 1);

      // Wait well past where a retry or reschedule would have fired if
      // the scheduler hadn't stopped itself.
      await Future<void>.delayed(const Duration(milliseconds: 150));
      expect(refresher.callCount, 1);
    });
  });

  group('transient network/server error', () {
    test('retries after retryDelay and eventually succeeds', () async {
      tokenStorage.accessTokenExpiry = DateTime.now().toUtc().subtract(
        const Duration(seconds: 1),
      );
      final refresher = _ScriptedTokenRefresher([
            (_) async => throw _dioError(500),
            (_) async => const AuthTokens(accessToken: 'new', expiresIn: 900),
      ]);
      final scheduler = buildScheduler(refresher);

      await scheduler.start();
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(refresher.callCount, 1, reason: 'first attempt failed');
      expect(tokenStorage.accessToken, 'old-access', reason: 'not saved yet');

      await Future<void>.delayed(const Duration(milliseconds: 60));
      expect(refresher.callCount, 2, reason: 'retry should have fired');
      expect(tokenStorage.accessToken, 'new');
    });
  });

  group('stop()', () {
    test('cancels a pending scheduled refresh', () async {
      tokenStorage.accessTokenExpiry = DateTime.now().toUtc().add(
        _safetyMargin + const Duration(milliseconds: 30),
      );
      final refresher = _ScriptedTokenRefresher([
            (_) async => const AuthTokens(accessToken: 'new', expiresIn: 900),
      ]);
      final scheduler = buildScheduler(refresher);

      await scheduler.start();
      scheduler.stop();

      // Wait past when the (now-cancelled) timer would have fired.
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(refresher.callCount, 0);
    });
  });

  group('didChangeAppLifecycleState', () {
    test('resumed re-checks storage and catches a missed expiry', () async {
      // Far-future expiry: start() schedules a timer that will NOT fire
      // during this test.
      tokenStorage.accessTokenExpiry = DateTime.now().toUtc().add(
        const Duration(minutes: 10),
      );
      final refresher = _ScriptedTokenRefresher([
            (_) async => const AuthTokens(accessToken: 'new', expiresIn: 900),
      ]);
      final scheduler = buildScheduler(refresher);
      await scheduler.start();

      // Simulate time having passed while the app was suspended: the
      // stored expiry is now in the past, but the original far-future
      // timer hasn't fired (and won't, in this test).
      tokenStorage.accessTokenExpiry = DateTime.now().toUtc().subtract(
        const Duration(seconds: 1),
      );

      scheduler.didChangeAppLifecycleState(AppLifecycleState.resumed);
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(refresher.callCount, 1);
      expect(tokenStorage.accessToken, 'new');
    });

    test('non-resumed states are ignored', () async {
      tokenStorage.accessTokenExpiry = DateTime.now().toUtc().subtract(
        const Duration(seconds: 1),
      );
      final refresher = _ScriptedTokenRefresher([]);
      final scheduler = buildScheduler(refresher);
      // Not started: _active is false, so even a resumed event should
      // be ignored, but we also check a non-resumed state explicitly.
      scheduler.didChangeAppLifecycleState(AppLifecycleState.paused);

      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(refresher.callCount, 0);
    });
  });
}