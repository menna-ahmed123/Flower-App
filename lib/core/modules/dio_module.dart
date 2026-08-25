import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/core/network/auth_interceptors.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@module
abstract class DioModule {
  @singleton
  Dio provideDio(AuthInterceptors authInterceptors) {

    final dio = Dio(_createBaseOptions());

    _configureInterceptors(dio, authInterceptors);
    _addDebugLogger(dio);

    return dio;
  }

  BaseOptions _createBaseOptions() {
    return BaseOptions(
      baseUrl: ApiEndpoints.resolvedBaseUrl,
      receiveTimeout: const Duration(seconds: 60),
      connectTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      headers: const {'Content-Type': 'application/json'},
    );
  }

  void _configureInterceptors(Dio dio, AuthInterceptors authInterceptors) {
    dio.interceptors.add(authInterceptors);
    authInterceptors.attachDio(dio);
  }

  void _addDebugLogger(Dio dio) {
    if (!kDebugMode) {
      return;
    }

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }
}
