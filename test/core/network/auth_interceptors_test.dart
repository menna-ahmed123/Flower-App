import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/core/localization/locale_storage.dart';
import 'package:flower_app/core/network/auth_interceptors.dart';
import 'package:flower_app/core/network/token_refresher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_token_storage.dart';

void main() {
  test('attaches Authorization Bearer header from stored access token', () async {
    final storage = FakeTokenStorage()..accessToken = 'access-token';
    final interceptor = AuthInterceptors(storage, _FakeTokenRefresher());
    final dio = Dio()
      ..interceptors.add(interceptor)
      ..httpClientAdapter = _HeaderCapturingAdapter();

    try {
      await dio.get<void>('/users/me/addresses');
    } on DioException catch (e) {
      final captured = e.error;
      expect(captured, isA<_CapturedHeaders>());
      final headers = (captured as _CapturedHeaders).headers;
      expect(headers['Authorization'], 'Bearer access-token');
      expect(headers.containsKey('token'), isFalse);
      return;
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

class MemoryLocaleStorage implements LocaleStorage {
  @override
  Future<Locale?> readLocale() async => null;

  @override
  Future<void> saveLocale(Locale locale) async {}

  @override
  Future<void> clearLocale() async {}
}

class ScriptedRefresher implements TokenRefresher {
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

class ScriptedAdapter implements HttpClientAdapter {
  final capturedHeaders = <Map<String, dynamic>>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    capturedHeaders.add(Map<String, dynamic>.from(options.headers));
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

class _CapturedHeaders implements Exception {
  _CapturedHeaders(this.headers);

  final Map<String, dynamic> headers;
}

/// No-op [TokenRefresher] for tests that only check header attachment.
class _FakeTokenRefresher implements TokenRefresher {
  @override
  Future<AuthTokens?> refresh(String refreshToken) async => null;
}
