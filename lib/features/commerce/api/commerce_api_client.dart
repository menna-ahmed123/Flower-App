import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/features/commerce/data/models/catalog_items_response.dart';
import 'package:flower_app/features/commerce/data/models/home_layout_response.dart';
import 'package:retrofit/retrofit.dart';

part 'commerce_api_client.g.dart';

@RestApi()
abstract class CommerceApiClient {
  factory CommerceApiClient(Dio dio, {String baseUrl}) = _CommerceApiClient;

  @GET(ApiEndpoints.home)
  Future<HomeLayoutResponse> getHomeLayout({@Query('storeId') String? storeId});

  @GET(ApiEndpoints.allCategories)
  Future<CatalogItemsResponse> getCategories();

  @GET(ApiEndpoints.allOccasions)
  Future<CatalogItemsResponse> getOccasions();

  @GET(ApiEndpoints.allProducts)
  Future<CatalogItemsResponse> getProducts({
    @Query('page') int? page,
    @Query('pageSize') int? pageSize,
  });
}
