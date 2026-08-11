import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthInterceptors implements Interceptor {

  final FlutterSecureStorage secureStorage;
  AuthInterceptors(this.secureStorage);
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    return handler.next(err);
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await secureStorage.read(key: 'USER_TOKEN');   
     if (token != null && token.isNotEmpty) {
      options.headers['token'] = token;
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    return handler.next(response);
  }
}
//send token and request//