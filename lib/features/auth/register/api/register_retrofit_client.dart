import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/features/auth/register/data/models/register_operation_dto.dart';
import 'package:flower_app/features/auth/register/data/models/register_request_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'register_retrofit_client.g.dart';

@RestApi()
abstract class RegisterRetrofitClient {
  factory RegisterRetrofitClient(Dio dio, {String baseUrl}) =
      _RegisterRetrofitClient;

  @POST(ApiEndpoints.register)
  Future<HttpResponse<RegisterOperationDto>> register(
    @Body() RegisterRequestDto request,
  );
}
