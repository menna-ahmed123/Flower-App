import 'package:flower_app/features/commerce/data/models/categories_response.dart';
import 'package:flower_app/features/commerce/data/models/occasions_response.dart';
import 'package:flower_app/features/commerce/data/models/product_details_response_model.dart';
import 'package:flower_app/features/commerce/data/models/product_response.dart';

abstract interface class CommerceRemoteDataSource {
  Future<ProductsResponse> getProducts({
    String? occasionId,
    String? categoryId,
  });

  /// Occasions ///
  Future<OccasionsResponse> getAllOccasions();

  Future<ProductDetailsResponseModel> getProductDetails(String productId);

  /// Categories ///
  Future<CategoriesResponse> getAllCategories();
}
