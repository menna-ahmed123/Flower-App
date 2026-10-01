import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flower_app/core/network/token_refresh_coordinator.dart';
import 'package:flower_app/core/network/token_refresher.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_token_storage.dart';

/// A [TokenRefresher] whose responses are scripted call-by-call, so tests
/// can assert exactly how many times it was invoked and with what result.
class _ScriptedTokenRefresher implements TokenRefresher {
  _ScriptedTokenRefresher(this._script);

  final List<Future<AuthTokens?> Function(String refreshToken)> _script;
  int callCount = 0;
  final List<String> refreshTokensReceived = [];

  @override
  Future<AuthTokens?> refresh(String refreshToken) {
    refreshTokensReceived.add(refreshToken);
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

void main() {
  late FakeTokenStorage tokenStorage;

  setUp(() {
    tokenStorage = FakeTokenStorage()
      ..accessToken = 'old-access'
      ..refreshToken = 'old-refresh';
  });

  group('no refresh token available', () {
    test('returns null and never calls the refresher', () async {
      tokenStorage.refreshToken = null;
      final refresher = _ScriptedTokenRefresher([]);
      final coordinator = TokenRefreshCoordinator(tokenStorage, refresher);

      final result = await coordinator.refresh();

      expect(result, isNull);
      expect(refresher.callCount, 0);
    });
  });

  group('successful refresh', () {
    test('persists the new tokens (including expiry) and returns them', () async {
      final refresher = _ScriptedTokenRefresher([
            (_) async => const AuthTokens(
          accessToken: 'new-access',
          refreshToken: 'new-refresh',
          expiresIn: 900,
        ),
      ]);
      final coordinator = TokenRefreshCoordinator(tokenStorage, refresher);

      final result = await coordinator.refresh();

      expect(result?.accessToken, 'new-access');
      expect(tokenStorage.accessToken, 'new-access');
      expect(tokenStorage.refreshToken, 'new-refresh');
      expect(tokenStorage.accessTokenExpiry, isNotNull);
      expect(refresher.refreshTokensReceived, ['old-refresh']);
    });

    test(
      'keeps the existing refresh token when the backend omits one',
          () async {
        final refresher = _ScriptedTokenRefresher([
              (_) async => const AuthTokens(accessToken: 'new-access', expiresIn: 900),
        ]);
        final coordinator = TokenRefreshCoordinator(tokenStorage, refresher);

        await coordinator.refresh();

        expect(tokenStorage.accessToken, 'new-access');
        expect(tokenStorage.refreshToken, 'old-refresh');
      },
    );
  });

  group('backend reports failure without a transport error', () {
    test('returns null and does not clear the session', () async {
      final refresher = _ScriptedTokenRefresher([(_) async => null]);
      final coordinator = TokenRefreshCoordinator(tokenStorage, refresher);

      final result = await coordinator.refresh();

      expect(result, isNull);
      expect(tokenStorage.clearCount, 0);
      expect(tokenStorage.accessToken, 'old-access');
    });
  });

  group('invalid refresh token (401/400 from the refresh call)', () {
    test('clears the session and throws SessionExpiredException on 401', () async {
      final refresher = _ScriptedTokenRefresher([
            (_) async => throw _dioError(401),
      ]);
      final coordinator = TokenRefreshCoordinator(tokenStorage, refresher);

      await expectLater(
        coordinator.refresh(),
        throwsA(isA<SessionExpiredException>()),
      );
      expect(tokenStorage.clearCount, 1);
      expect(tokenStorage.accessToken, isNull);
      expect(tokenStorage.refreshToken, isNull);
    });

    test('also treats 400 as an invalid refresh token', () async {
      final refresher = _ScriptedTokenRefresher([
            (_) async => throw _dioError(400),
      ]);
      final coordinator = TokenRefreshCoordinator(tokenStorage, refresher);

      await expectLater(
        coordinator.refresh(),
        throwsA(isA<SessionExpiredException>()),
      );
      expect(tokenStorage.clearCount, 1);
    });
  });

  group('transient network/server error', () {
    test('rethrows the DioException without clearing the session', () async {
      final refresher = _ScriptedTokenRefresher([
            (_) async => throw _dioError(500),
      ]);
      final coordinator = TokenRefreshCoordinator(tokenStorage, refresher);

      await expectLater(coordinator.refresh(), throwsA(isA<DioException>()));
      expect(tokenStorage.clearCount, 0);
      expect(tokenStorage.accessToken, 'old-access');
      expect(tokenStorage.refreshToken, 'old-refresh');
    });
  });

  group('single-flight de-duplication', () {
    test('concurrent calls share one in-flight refresh', () async {
      final completer = Completer<AuthTokens?>();
      final refresher = _ScriptedTokenRefresher([(_) => completer.future]);
      final coordinator = TokenRefreshCoordinator(tokenStorage, refresher);

      final first = coordinator.refresh();
      final second = coordinator.refresh();

      completer.complete(
        const AuthTokens(accessToken: 'new-access', expiresIn: 900),
      );

      final results = await Future.wait([first, second]);

      expect(refresher.callCount, 1, reason: 'only one HTTP call should fire');
      expect(results[0]?.accessToken, 'new-access');
      expect(results[1]?.accessToken, 'new-access');
    });

    test('a call after completion triggers a fresh refresh', () async {
      final refresher = _ScriptedTokenRefresher([
            (_) async => const AuthTokens(accessToken: 'first', expiresIn: 900),
            (_) async => const AuthTokens(accessToken: 'second', expiresIn: 900),
      ]);
      final coordinator = TokenRefreshCoordinator(tokenStorage, refresher);

      final first = await coordinator.refresh();
      final second = await coordinator.refresh();

      expect(first?.accessToken, 'first');
      expect(second?.accessToken, 'second');
      expect(refresher.callCount, 2);
    });
  });
}