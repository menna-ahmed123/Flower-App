import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/features/commerce/data/models/occasions_response.dart';
import 'package:flower_app/features/commerce/data/models/product_response.dart';
import 'package:retrofit/retrofit.dart';

part 'commerce_api_client.g.dart';

@RestApi()
abstract class CommerceApiClient {
  factory CommerceApiClient(Dio dio, {String baseUrl}) =
      _CommerceApiClient;
// All products  best Seller //
  @GET(ApiEndpoints.allProducts)
  Future<ProductsResponse> getAllProducts();

/// Occasions ///
  @GET(ApiEndpoints.allOccasions)
  Future<OccasionsResponse> getAllOccasions();
  
  @GET(ApiEndpoints.allProducts)
Future<ProductsResponse> getProductsByOccasion(
  @Query('occasionId') String occasionId,
);
}