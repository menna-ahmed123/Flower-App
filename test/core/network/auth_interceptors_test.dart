import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/core/network/auth_interceptors.dart';
import 'package:flower_app/core/network/token_refresh_coordinator.dart';
import 'package:flower_app/core/network/token_refresher.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_token_storage.dart';

/// A [TokenRefresher] that either returns fixed tokens or throws a fixed
/// error every time it's called — enough control for these tests without
/// needing a real HTTP call.
class _FakeTokenRefresher implements TokenRefresher {
  _FakeTokenRefresher({this.tokens, this.error});

  final AuthTokens? tokens;
  final Object? error;
  int callCount = 0;

  @override
  Future<AuthTokens?> refresh(String refreshToken) async {
    callCount++;
    final err = error;
    if (err != null) throw err;
    return tokens;
  }
}

/// A scripted [HttpClientAdapter]: returns one canned response per call,
/// in order, and records every request it saw so tests can assert on
/// headers, order, and count — all without touching the real network.
class _ScriptedHttpAdapter implements HttpClientAdapter {
  _ScriptedHttpAdapter(this._responses);

  final List<int> _responses;
  int callCount = 0;

  /// Snapshots of each request's headers, taken *at the moment of the
  /// call*. [AuthInterceptors] reuses the same mutable [RequestOptions]
  /// object for the retried request, so storing the object itself would
  /// let a later mutation (the retry's new header) retroactively change
  /// what this list shows for the *original* request too.
  final List<Map<String, dynamic>> requestHeaders = [];

  @override
  Future<ResponseBody> fetch(
      RequestOptions options,
      Stream<List<int>>? requestStream,
      Future<void>? cancelFuture,
      ) async {
    requestHeaders.add(Map<String, dynamic>.from(options.headers));
    final index = callCount.clamp(0, _responses.length - 1);
    callCount++;
    return ResponseBody.fromString('{}', _responses[index]);
  }

  @override
  void close({bool force = false}) {}
}

DioException _refreshDioError(int statusCode) {
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

  /// Builds a real [Dio] instance with [AuthInterceptors] attached, using
  /// a scripted adapter instead of real network calls, so the interceptor
  /// runs through Dio's actual request/response/error pipeline.
  ({Dio dio, _ScriptedHttpAdapter adapter, _FakeTokenRefresher refresher})
  buildDio({
    required List<int> responses,
    AuthTokens? refreshedTokens,
    Object? refreshError,
  }) {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    final adapter = _ScriptedHttpAdapter(responses);
    dio.httpClientAdapter = adapter;

    final refresher = _FakeTokenRefresher(
      tokens: refreshedTokens,
      error: refreshError,
    );
    final coordinator = TokenRefreshCoordinator(tokenStorage, refresher);
    final interceptor = AuthInterceptors(tokenStorage, coordinator);
    interceptor.attachDio(dio);
    dio.interceptors.add(interceptor);

    return (dio: dio, adapter: adapter, refresher: refresher);
  }

  group('onRequest', () {
    test('attaches the current access token as a Bearer header', () async {
      final built = buildDio(responses: [200]);

      await built.dio.get<dynamic>('/protected');

      expect(
        built.adapter.requestHeaders.single['Authorization'],
        'Bearer old-access',
      );
    });
  });

  group('successful reactive refresh', () {
    test('refreshes once and retries the original request', () async {
      final built = buildDio(
        responses: [401, 200],
        refreshedTokens: const AuthTokens(
          accessToken: 'new-access',
          refreshToken: 'new-refresh',
          expiresIn: 900,
        ),
      );

      final response = await built.dio.get<dynamic>('/protected');

      expect(response.statusCode, 200);
      expect(built.refresher.callCount, 1);
      expect(built.adapter.requestHeaders, hasLength(2));
      expect(
        built.adapter.requestHeaders[0]['Authorization'],
        'Bearer old-access',
      );
      expect(
        built.adapter.requestHeaders[1]['Authorization'],
        'Bearer new-access',
      );
      expect(tokenStorage.accessToken, 'new-access');
    });
  });

  group('no refresh token available', () {
    test('propagates the original 401 without calling the refresher', () async {
      tokenStorage.refreshToken = null;
      final built = buildDio(responses: [401]);

      await expectLater(
        built.dio.get<dynamic>('/protected'),
        throwsA(
          isA<DioException>().having(
                (e) => e.response?.statusCode,
            'statusCode',
            401,
          ),
        ),
      );
      expect(built.refresher.callCount, 0);
      expect(built.adapter.requestHeaders, hasLength(1));
    });
  });

  group('backend reports failure without a transport error', () {
    test('propagates the original 401 (refresher returned null)', () async {
      final built = buildDio(responses: [401], refreshedTokens: null);

      await expectLater(
        built.dio.get<dynamic>('/protected'),
        throwsA(
          isA<DioException>().having(
                (e) => e.response?.statusCode,
            'statusCode',
            401,
          ),
        ),
      );
      expect(built.refresher.callCount, 1);
      expect(built.adapter.requestHeaders, hasLength(1));
      // Session should NOT be cleared — the original token might still
      // be valid; this was just an inconclusive refresh attempt.
      expect(tokenStorage.clearCount, 0);
    });
  });

  group('refresh token confirmed invalid (401/400 on the refresh call)', () {
    test('rejects with ForceLogin and clears the session', () async {
      final built = buildDio(
        responses: [401],
        refreshError: _refreshDioError(401),
      );

      await expectLater(
        built.dio.get<dynamic>('/protected'),
        throwsA(
          isA<DioException>().having(
                (e) => e.error,
            'error',
            isA<ForceLogin>(),
          ),
        ),
      );
      expect(tokenStorage.clearCount, 1);
      expect(built.adapter.requestHeaders, hasLength(1), reason: 'no retry');
    });
  });

  group('transient network/server error during refresh', () {
    test('propagates the original 401 without clearing the session', () async {
      final built = buildDio(
        responses: [401],
        refreshError: _refreshDioError(500),
      );

      await expectLater(
        built.dio.get<dynamic>('/protected'),
        throwsA(
          isA<DioException>().having(
                (e) => e.response?.statusCode,
            'statusCode',
            401,
          ),
        ),
      );
      expect(tokenStorage.clearCount, 0);
    });
  });

  group('already retried once', () {
    test('does not attempt a second refresh if the retry also 401s', () async {
      final built = buildDio(
        responses: [401, 401],
        refreshedTokens: const AuthTokens(
          accessToken: 'new-access',
          expiresIn: 900,
        ),
      );

      await expectLater(
        built.dio.get<dynamic>('/protected'),
        throwsA(
          isA<DioException>().having(
                (e) => e.response?.statusCode,
            'statusCode',
            401,
          ),
        ),
      );
      // Only one refresh attempt total, even though the retried request
      // also came back 401 — the `retried` flag prevents a second one.
      expect(built.refresher.callCount, 1);
      expect(built.adapter.requestHeaders, hasLength(2));
    });
  });
}