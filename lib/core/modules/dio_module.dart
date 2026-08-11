import 'package:dio/dio.dart';
import 'package:flower_app/core/network/auth_interceptors.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@module
abstract class DioModule {
  @singleton
  Dio provideDio(AuthInterceptors authInterceptors) {
    final dio = Dio();

    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 60),
      connectTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
    );

    dio.interceptors.add(authInterceptors);
    authInterceptors.attachDio(dio);

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          // Do not log request headers — they may contain the access token.
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

    return dio;
  }
}
