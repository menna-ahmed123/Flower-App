import 'package:dio/dio.dart';
import 'package:flower_app/core/network/auth_interceptors.dart';
import 'package:flower_app/core/network/token_refresher.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_token_storage.dart';

void main() {
  test('attaches Authorization Bearer header from stored access token', () async {
    final storage = FakeTokenStorage()..accessToken = 'access-token';
    final interceptor = AuthInterceptors(storage, UnconfiguredTokenRefresher());
    final dio = Dio()
      ..interceptors.add(interceptor)
      ..httpClientAdapter = _HeaderCapturingAdapter();

    try {
      await dio.get<void>('/users/me/addresses');
    } on _CapturedHeaders catch (captured) {
      expect(captured.headers['Authorization'], 'Bearer access-token');
      expect(captured.headers.containsKey('token'), isFalse);
      return;
    }

    fail('Expected the adapter to capture request headers');
  });
}

class _HeaderCapturingAdapter implements HttpClientAdapter {
  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) {
    throw _CapturedHeaders(options.headers);
  }
}

class _CapturedHeaders implements Exception {
  _CapturedHeaders(this.headers);

  final Map<String, dynamic> headers;
}
