import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class AuthInterceptors implements Interceptor {
  final SharedPreferences sharedPreferences;
  AuthInterceptors(this.sharedPreferences);
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    return handler.next(err);
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = sharedPreferences.getString("USER_TOKEN");
    log("TOKEN = $token");
    if (token != null && token.isNotEmpty) {
      options.headers['token'] = token;
    }
    log("REQUEST HEADERS = ${options.headers}");
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