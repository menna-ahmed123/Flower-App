import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';

abstract interface class CommerceRepo {
  Future<BaseResponse<List<ProductEntity>>>getAllProducts();
  
}