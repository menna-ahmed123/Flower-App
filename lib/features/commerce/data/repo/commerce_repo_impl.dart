import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/commerce/data/data_sources/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/data/models/occasion_model.dart';
import 'package:flower_app/features/commerce/domain/entities/category_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/product_details_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CommerceRepo)
class CommerceRepoImpl implements CommerceRepo {
  final CommerceRemoteDataSource commerceRemoteDataSource;
  final SafeCall safeCall;

  CommerceRepoImpl(this.commerceRemoteDataSource, this.safeCall);

  ///// Products //////

  @override
  Future<BaseResponse<List<ProductEntity>>> getProducts({
    String? occasionId,
    String? categoryId,
  }) {
    return safeCall.safeApiCall(() async {
      final response = await commerceRemoteDataSource.getProducts(
        occasionId: occasionId,
        categoryId: categoryId,
      );

      return response.data.items.map((product) => product.toDomain()).toList();
    });
  }

  ///// Categories //////

  @override
  Future<BaseResponse<List<CategoryEntity>>> getAllCategories() {
    return safeCall.safeApiCall(() async {
      final response = await commerceRemoteDataSource.getAllCategories();

      return response.data.map((category) => category.toEntity()).toList();
    });
  }

  ///// Occasions //////

  @override
  Future<BaseResponse<List<OccasionModel>>> getAllOccasions() {
    return safeCall.safeApiCall(() async {
      final response = await commerceRemoteDataSource.getAllOccasions();

      return response.data;
    });
  }

  ///// Product Details //////

  @override
  Future<BaseResponse<ProductDetailsEntity>> getProductDetails({
    required String productId,
  }) {
    return safeCall.safeApiCall(() async {
      final response = await commerceRemoteDataSource.getProductDetails(
        productId,
      );

      final data = response.data;

      if (data == null) {
        throw Exception('Product details data is null');
      }

      return data.toDomain();
    });
  }
}
