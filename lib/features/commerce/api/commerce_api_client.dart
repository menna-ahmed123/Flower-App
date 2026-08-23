import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/features/commerce/data/models/home_layout_response.dart';
import 'package:retrofit/retrofit.dart';

part 'commerce_api_client.g.dart';

@RestApi(baseUrl: ApiEndpoints.baseUrl)
abstract class CommerceApiClient {
  factory CommerceApiClient(Dio dio, {String baseUrl}) = _CommerceApiClient;

  @GET(ApiEndpoints.home)
  Future<HomeLayoutResponse> getHomeLayout({@Query('storeId') String? storeId});
}
