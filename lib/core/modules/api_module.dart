import 'package:dio/dio.dart';
import 'package:flower_app/features/auth/login/data/api/auth_api_client.dart';
import 'package:flower_app/features/auth/forget_password/api/client/forget_password_api_client.dart';
import 'package:flower_app/features/auth/register/data/api/register_api_client.dart';
import 'package:injectable/injectable.dart';

@module
abstract class ApiModule {
  @singleton
  ForgetPasswordApiClient provideForgetPasswordApiClient(Dio dio) {
    return ForgetPasswordApiClient(dio);
  }

  AuthApiClient authApiClient(Dio dio) {
    return AuthApiClient(dio);
  }

  RegisterApiClient registerApiClient(Dio dio) {
    return RegisterApiClient(dio);
  }
}
