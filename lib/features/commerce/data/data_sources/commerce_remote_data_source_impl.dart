import 'package:flower_app/features/commerce/api/commerce_api_client.dart';
import 'package:flower_app/features/commerce/data/data_sources/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/data/models/categories_response.dart';
import 'package:flower_app/features/commerce/data/models/occasions_response.dart';
import 'package:injectable/injectable.dart';
import 'package:flower_app/features/commerce/data/models/product_details_response_model.dart';
import 'package:flower_app/features/commerce/data/models/product_response.dart';

@Injectable(as: CommerceRemoteDataSource, env: ['dev', 'prod'])
class CommerceRemoteDataSourceImpl implements CommerceRemoteDataSource {
  final CommerceApiClient _commerceApiClient;

  CommerceRemoteDataSourceImpl(this._commerceApiClient);

  @override
  Future<ProductsResponse> getAllProducts() {
    return _commerceApiClient.getAllProducts();
  }

  @override
  Future<CategoriesResponse> getAllCategories() {
    return _commerceApiClient.getAllCategories();
  }

  @override
  Future<ProductsResponse> getProductsByCategory(String categoryId) {
    return _commerceApiClient.getProductsByCategory(categoryId);
  }

  @override
  Future<OccasionsResponse> getAllOccasions() {
    return _commerceApiClient.getAllOccasions();
  }

  @override
  Future<ProductsResponse> getProductsByOccasion(String occasionId) {
    return _commerceApiClient.getProductsByOccasion(occasionId);
  }

  @override
  Future<ProductDetailsResponseModel> getProductDetails(String productId) {
    return _commerceApiClient.getProductDetails(productId);
  }
}
