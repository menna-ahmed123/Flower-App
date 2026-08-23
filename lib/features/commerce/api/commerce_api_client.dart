import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/features/commerce/data/models/categories_response.dart';
import 'package:flower_app/features/commerce/data/models/occasions_response.dart';
import 'package:flower_app/features/commerce/data/models/product_details_response_model.dart';
import 'package:flower_app/features/commerce/data/models/product_response.dart';
import 'package:retrofit/retrofit.dart';

part 'commerce_api_client.g.dart';

@RestApi(baseUrl: ApiEndpoints.baseUrl)
abstract class CommerceApiClient {
  factory CommerceApiClient(Dio dio, {String baseUrl}) = _CommerceApiClient;

  @GET(ApiEndpoints.allProducts)
  Future<ProductsResponse> getAllProducts();

  @GET(ApiEndpoints.allOccasions)
  Future<OccasionsResponse> getAllOccasions();

  @GET(ApiEndpoints.allProducts)
  Future<ProductsResponse> getProductsByOccasion(
    @Query('occasionId') String occasionId,
  );

  @GET(ApiEndpoints.productDetails)
  Future<ProductDetailsResponseModel> getProductDetails(@Path('id') String id);
  
  /// Categories ///
  @GET(ApiEndpoints.allCategories)
  Future<CategoriesResponse> getAllCategories();

  @GET(ApiEndpoints.allProducts)
  Future<ProductsResponse> getProductsByCategory(
    @Query('categoryId') String categoryId,
  );
  
}
