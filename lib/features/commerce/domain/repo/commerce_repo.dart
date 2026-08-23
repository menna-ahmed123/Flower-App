import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/commerce/data/models/occasion_model.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';

abstract interface class CommerceRepo {
  Future<BaseResponse<List<ProductEntity>>> getAllProducts();
/// Occasions ///
  Future<BaseResponse<List<OccasionModel>>> getAllOccasions();
  Future<BaseResponse<List<ProductEntity>>> getProductsByOccasion(
    String occasionId,
  );
}