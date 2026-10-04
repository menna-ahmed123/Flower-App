import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/features/commerce/data/models/categories_response.dart';
import 'package:flower_app/features/commerce/data/models/occasions_response.dart';
import 'package:flower_app/features/commerce/data/models/product_details_response_model.dart';
import 'package:flower_app/features/commerce/data/models/product_response.dart';
import 'package:flower_app/features/commerce/data/models/home_layout_response.dart';
import 'package:retrofit/retrofit.dart';

part 'commerce_api_client.g.dart';

@RestApi()
abstract class CommerceApiClient {
  factory CommerceApiClient(Dio dio, {String baseUrl}) = _CommerceApiClient;

  /// GET api/catalog/home/layout
  /// Returns layout sections with items already embedded in each payload.
  @GET(ApiEndpoints.home)
  Future<HomeLayoutResponse> getHomeLayout();

  /// GET api/catalog/categories
  @GET(ApiEndpoints.allCategories)
  Future<CategoriesResponse> getAllCategories();

  /// GET api/catalog/occasions
  @GET(ApiEndpoints.allOccasions)
  Future<OccasionsResponse> getAllOccasions();

  /// GET api/catalog/products
  /// sort param is a string e.g. "PriceHighToLow", "PriceLowToHigh"
  @GET(ApiEndpoints.allProducts)
  Future<ProductsResponse> getProducts({
    @Query('Page') String? page,
    @Query('PageSize') String? pageSize,
    @Query('occasionId') String? occasionId,
    @Query('categoryId') String? categoryId,
    @Query('sort') String? sort,
  });

  /// GET api/catalog/products/{Product-id}
  @GET(ApiEndpoints.productDetails)
  Future<ProductDetailsResponseModel> getProductDetails(
    @Path('Product-id') String id,
  );

  /// GET api/catalog/products/search?q=Rose&sort=...&Page=1&PageSize=20
  @GET(ApiEndpoints.searchProducts)
  Future<ProductsResponse> searchProducts({
    @Query('q') String? query,
    @Query('sort') String? sort,
    @Query('Page') String? page,
    @Query('PageSize') String? pageSize,
  });
}
