import 'package:dio/dio.dart';
import 'package:flower_app/features/auth/forget_password/api/client/forget_password_api_client.dart';
import 'package:flower_app/features/auth/login/data/api/auth_api_client.dart';
import 'package:flower_app/features/auth/register/data/api/register_api_client.dart';
import 'package:flower_app/features/cart/api/cart_api_client.dart';
import 'package:flower_app/features/commerce/api/commerce_api_client.dart';
import 'package:injectable/injectable.dart';

@module
abstract class ApiModule {
  @singleton
  ForgetPasswordApiClient provideForgetPasswordApiClient(Dio dio) =>
      ForgetPasswordApiClient(dio);

  @singleton
  AuthApiClient provideAuthApiClient(Dio dio) => AuthApiClient(dio);

  @singleton
  RegisterApiClient provideRegisterApiClient(Dio dio) => RegisterApiClient(dio);

  @singleton
  CommerceApiClient provideCommerceApiClient(Dio dio) => CommerceApiClient(dio);

  @singleton
  CartApiClient provideCartApiClient(Dio dio) => CartApiClient(dio);
}
