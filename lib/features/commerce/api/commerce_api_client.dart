import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/features/commerce/data/models/product_details_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'commerce_api_client.g.dart';


@RestApi(baseUrl: ApiEndpoints.baseUrl)
abstract class CommerceApiClient {
  factory CommerceApiClient(Dio dio, {String baseUrl}) = _CommerceApiClient;

  @GET(ApiEndpoints.productDetails)
  Future<ProductDetailsResponseModel> getProductDetails(@Path("id") String id);
}
