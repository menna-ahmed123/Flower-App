import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/features/auth/register/data/models/register_operation_dto.dart';
import 'package:flower_app/features/auth/register/data/models/register_request_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'dio_register_api.g.dart';

@RestApi()
abstract class DioRegisterApi {
  factory DioRegisterApi(Dio dio, {String baseUrl}) = _DioRegisterApi;

  @POST(ApiEndpoints.register)
  Future<HttpResponse<RegisterOperationDto>> register(
    @Body() RegisterRequestDto request,
  );
}

@module
abstract class DioRegisterApiModule {
  @lazySingleton
  DioRegisterApi dioRegisterApi(Dio dio) => DioRegisterApi(dio);
}
