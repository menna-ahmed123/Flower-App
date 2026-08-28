import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/commerce/data/models/occasion_model.dart';
import 'package:flower_app/features/commerce/domain/entities/category_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/home_layout_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/product_details_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';

abstract interface class CommerceRepo {
  Future<BaseResponse<HomeLayoutEntity>> getHomeLayout({String? storeId});

  Future<BaseResponse<List<ProductEntity>>> getProducts({
    String? occasionId,
    String? categoryId,
  });

  Future<BaseResponse<List<OccasionModel>>> getAllOccasions();

  Future<BaseResponse<ProductDetailsEntity>> getProductDetails({
    required String productId,
  });

  Future<BaseResponse<List<CategoryEntity>>> getAllCategories();

  Future<BaseResponse<List<ProductEntity>>> searchProducts({
    required String query,
    String? storeId,
  });
}
