import 'package:flower_app/features/commerce/data/models/occasions_response.dart';
import 'package:flower_app/features/commerce/data/models/product_response.dart';

abstract interface class CommerceRemoteDataSource {
  Future<OccasionsResponse> getAllOccasions();
  Future<ProductsResponse> getAllProducts();
  Future<ProductsResponse> getProductsByOccasion(String occasionId);
}
