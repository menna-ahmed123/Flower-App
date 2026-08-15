import 'package:dio/dio.dart';
import 'package:flower_app/features/forget_password/api/client/forget_password_api_client.dart';
import 'package:injectable/injectable.dart';

@module
abstract class ApiModule {
  @singleton
  ForgetPasswordApiClient provideForgetPasswordApiClient(Dio dio) {
    return ForgetPasswordApiClient(dio);
  }
}
