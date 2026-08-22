
import 'package:flower_app/features/commerce/data/models/product_response.dart';
abstract interface class CommerceRemoteDataSource {
  Future<ProductsResponse> getAllProducts();
}