import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/features/auth/register/data/models/register_request.dart';
import 'package:flower_app/features/auth/register/data/models/register_response.dart';
import 'package:retrofit/retrofit.dart';

part 'register_api_client.g.dart';

@RestApi(baseUrl: ApiEndpoints.baseUrl)
abstract class RegisterApiClient {
  factory RegisterApiClient(Dio dio, {String baseUrl}) = _RegisterApiClient;

  @POST(ApiEndpoints.register)
  Future<RegisterResponse> register(@Body() RegisterRequest request);
}
