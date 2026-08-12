import 'package:dio/dio.dart';
import 'package:flower_app/features/auth/login/data/api/auth_api_client.dart';
import 'package:injectable/injectable.dart';

@module
abstract class ApiModule {
   @lazySingleton
  AuthApiClient authApiClient(Dio dio) {
    return AuthApiClient(dio);
  }
}