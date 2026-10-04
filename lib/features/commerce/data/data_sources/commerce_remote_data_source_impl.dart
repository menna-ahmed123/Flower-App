import 'package:flower_app/features/commerce/api/commerce_api_client.dart';
import 'package:flower_app/features/commerce/data/data_sources/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/data/models/categories_response.dart';
import 'package:flower_app/features/commerce/data/models/occasions_response.dart';
import 'package:flower_app/features/commerce/data/models/home_layout_response.dart';
import 'package:flower_app/features/commerce/data/models/product_details_response_model.dart';
import 'package:flower_app/features/commerce/data/models/product_response.dart';
import 'package:flower_app/features/commerce/domain/entities/category_sort_by.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CommerceRemoteDataSource)
class CommerceRemoteDataSourceImpl implements CommerceRemoteDataSource {
  CommerceRemoteDataSourceImpl(this.commerceApiClient);

  final CommerceApiClient commerceApiClient;

  // ---------------------------------------------------------------------------
  // Home Layout
  // New API already embeds items inside each section's payload —
  // no secondary API calls needed.
  // ---------------------------------------------------------------------------
  @override
  Future<HomeLayoutResponse> getHomeLayout() {
    // ignore: avoid_print
    print('📡 getHomeLayout called — baseUrl: ${commerceApiClient.hashCode}');
    return commerceApiClient.getHomeLayout();
  }

  // ---------------------------------------------------------------------------
  // Products
  // ---------------------------------------------------------------------------
  @override
  Future<ProductsResponse> getProducts({
    int? page,
    int? pageSize,
    String? occasionId,
    String? categoryId,
    CategorySortBy? sortBy,
  }) {
    return commerceApiClient.getProducts(
      page: page?.toString(),
      pageSize: pageSize?.toString(),
      occasionId: occasionId,
      categoryId: categoryId,
      sort: sortBy?.apiValue,
    );
  }

  @override
  Future<ProductsResponse> searchProducts({
    required String query,
    int? page,
    int? pageSize,
    CategorySortBy? sortBy,
  }) {
    return commerceApiClient.searchProducts(
      query: query,
      page: page?.toString(),
      pageSize: pageSize?.toString(),
      sort: sortBy?.apiValue,
    );
  }

  // ---------------------------------------------------------------------------
  // Categories & Occasions
  // ---------------------------------------------------------------------------
  @override
  Future<CategoriesResponse> getAllCategories() {
    return commerceApiClient.getAllCategories();
  }

  @override
  Future<OccasionsResponse> getAllOccasions() {
    return commerceApiClient.getAllOccasions();
  }

  // ---------------------------------------------------------------------------
  // Product Details
  // ---------------------------------------------------------------------------
  @override
  Future<ProductDetailsResponseModel> getProductDetails(String productId) {
    return commerceApiClient.getProductDetails(productId);
  }
}
