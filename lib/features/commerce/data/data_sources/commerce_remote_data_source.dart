import 'package:flower_app/features/commerce/data/models/occasions_response.dart';
import 'package:flower_app/features/commerce/data/models/product_response.dart';

abstract interface class CommerceRemoteDataSource {
    Future<ProductsResponse> getAllProducts();
/// Occasions ///
  Future<OccasionsResponse> getAllOccasions();
  Future<ProductsResponse> getProductsByOccasion(String occasionId);
}
