import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/core/constants/api_query_params.dart';
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
  Future<ProductsResponse> getProducts({
    @Query(ApiQueryParams.occasionId) String? occasionId,
    @Query(ApiQueryParams.categoryId) String? categoryId,
  });

  @GET(ApiEndpoints.allOccasions)
  Future<OccasionsResponse> getAllOccasions();

  @GET(ApiEndpoints.productDetails)
  Future<ProductDetailsResponseModel> getProductDetails(@Path(ApiQueryParams.id) String id);

  /// Categories ///
  @GET(ApiEndpoints.allCategories)
  Future<CategoriesResponse> getAllCategories();
}
