import 'package:dio/dio.dart';
import 'package:flower_app/features/auth/register/api/dio_register_api.dart';
import 'package:injectable/injectable.dart';

@module
abstract class ApiModule {
  @lazySingleton
  DioRegisterApi provideDioRegisterApi(Dio dio) => DioRegisterApi(dio);
}
