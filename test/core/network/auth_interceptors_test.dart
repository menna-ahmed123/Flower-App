import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/core/network/auth_interceptors.dart';
import 'package:flower_app/core/network/token_refresher.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_token_storage.dart';

void main() {
  late FakeTokenStorage storage;
  late _ScriptedRefresher refresher;
  late AuthInterceptors interceptor;
  late Dio dio;

  setUp(() {
    storage = FakeTokenStorage()
      ..accessToken = 'old-access'
      ..refreshToken = 'refresh-1';
    refresher = _ScriptedRefresher();
    interceptor = AuthInterceptors(storage, refresher);
    dio = Dio(BaseOptions(baseUrl: 'http://test'));
    dio.httpClientAdapter = _ScriptedAdapter();
    interceptor.attachDio(dio);
    dio.interceptors.add(interceptor);
  });

  test('401 refreshes once, stores the new token, and retries the request', () async {
    refresher.tokens = const AuthTokens(
      accessToken: 'new-access',
      refreshToken: 'refresh-2',
    );

    final response = await dio.get<Map<String, dynamic>>('/secure');

    expect(response.statusCode, 200);
    expect(response.data, {'ok': true});
    expect(refresher.calls, 1);
    expect(storage.accessToken, 'new-access');
    expect(storage.refreshToken, 'refresh-2');
  });

  test('concurrent 401s share a single refresh call', () async {
    refresher.tokens = const AuthTokens(accessToken: 'new-access');
    refresher.delay = const Duration(milliseconds: 40);

    final results = await Future.wait([
      dio.get<Map<String, dynamic>>('/secure'),
      dio.get<Map<String, dynamic>>('/secure'),
    ]);

    expect(results.map((r) => r.statusCode), [200, 200]);
    expect(refresher.calls, 1);
  });

  test('invalid refresh token clears storage and surfaces ForceLogin', () async {
    refresher.error = DioException(
      requestOptions: RequestOptions(path: '/refresh'),
      response: Response(
        requestOptions: RequestOptions(path: '/refresh'),
        statusCode: 401,
      ),
      type: DioExceptionType.badResponse,
    );

    try {
      await dio.get<void>('/secure');
      fail('expected DioException');
    } on DioException catch (error) {
      expect(error.error, isA<ForceLogin>());
    }

    expect(storage.accessToken, isNull);
    expect(storage.refreshToken, isNull);
    expect(storage.clearCount, 1);
  });

  test('unconfigured refresher leaves the session and original 401', () async {
    refresher.tokens = null;

    try {
      await dio.get<void>('/secure');
      fail('expected DioException');
    } on DioException catch (error) {
      expect(error.response?.statusCode, 401);
      expect(error.error, isNot(isA<ForceLogin>()));
    }

    expect(storage.accessToken, 'old-access');
    expect(storage.refreshToken, 'refresh-1');
    expect(storage.clearCount, 0);
  });
}

class _ScriptedRefresher implements TokenRefresher {
  AuthTokens? tokens;
  Object? error;
  Duration delay = Duration.zero;
  int calls = 0;

  @override
  Future<AuthTokens?> refresh(String refreshToken) async {
    calls++;
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    final failure = error;
    if (failure != null) {
      throw failure;
    }
    return tokens;
  }
}

class _ScriptedAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (options.extra[AuthRequestExtra.retried] == true) {
      return ResponseBody.fromString(
        jsonEncode({'ok': true}),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }
    return ResponseBody.fromString('unauthorized', 401);
  }

  @override
  void close({bool force = false}) {}
}
