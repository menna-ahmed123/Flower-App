import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/commerce/data/models/product_details_response_model.dart';

abstract interface class CommerceRemoteDataSource {
  Future<BaseResponse<ProductDetailsResponseModel>> getProductDetails({
    required String productId,
  });
}
