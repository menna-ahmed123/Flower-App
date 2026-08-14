import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/core/network/auth_interceptors.dart';
import 'package:flower_app/features/auth/register/api/dio_register_api.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@module
abstract class DioModule {
  @singleton
  Dio provideDio(AuthInterceptors authInterceptors) {
    final dio = Dio(_createBaseOptions());
    _attachInterceptors(dio, authInterceptors);
    return dio;
  }

  @lazySingleton
  DioRegisterApi provideDioRegisterApi(Dio dio) => DioRegisterApi(dio);
}

BaseOptions _createBaseOptions() {
  return BaseOptions(
    baseUrl: ApiEndpoints.baseUrl,
    receiveTimeout: const Duration(seconds: 60),
    connectTimeout: const Duration(seconds: 60),
    sendTimeout: const Duration(seconds: 60),
    headers: const {'Content-Type': 'application/json'},
  );
}

void _attachInterceptors(Dio dio, AuthInterceptors authInterceptors) {
  dio.interceptors.add(authInterceptors);
  authInterceptors.attachDio(dio);
  if (kDebugMode) {
    dio.interceptors.add(_createPrettyLogger());
  }
}

PrettyDioLogger _createPrettyLogger() {
  return PrettyDioLogger(
    requestHeader: false,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    error: true,
    compact: true,
    maxWidth: 90,
  );
}
