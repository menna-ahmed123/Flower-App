import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/commerce/domain/entities/product_details_entity.dart';

abstract interface class CommerceRepo {
    Future<BaseResponse<ProductDetailsEntity>> getProductDetails({
    required String productId,
  });
}