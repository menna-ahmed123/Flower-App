import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/api_exception.dart';
import 'package:flower_app/core/errors/error_parser.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/commerce/data/data_sources/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/data/models/occasion_model.dart';
import 'package:flower_app/features/commerce/domain/entities/category_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/home_layout_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/product_details_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CommerceRepo)
class CommerceRepoImpl implements CommerceRepo {
  CommerceRepoImpl(this.commerceRemoteDataSource, this.safeCall);

  final CommerceRemoteDataSource commerceRemoteDataSource;
  final SafeCall safeCall;

  @override
  Future<BaseResponse<HomeLayoutEntity>> getHomeLayout({String? storeId}) {
    return safeCall.safeApiCall(() async {
      final response = await commerceRemoteDataSource.getHomeLayout(
        storeId: storeId,
      );
      if (!response.isSuccess) {
        throw ApiException(
          message: response.message.isNotEmpty
              ? response.message
              : statusCodeToMessage(response.statusCode),
          statusCode: response.statusCode,
        );
      }
      return response.toDomain();
    });
  }

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

  @override
  Future<BaseResponse<List<CategoryEntity>>> getAllCategories() {
    return safeCall.safeApiCall(() async {
      final response = await commerceRemoteDataSource.getAllCategories();
      return response.data.map((category) => category.toEntity()).toList();
    });
  }

  @override
  Future<BaseResponse<List<OccasionModel>>> getAllOccasions() {
    return safeCall.safeApiCall(() async {
      final response = await commerceRemoteDataSource.getAllOccasions();
      return response.data;
    });
  }

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
  @override
  Future<BaseResponse<List<ProductEntity>>> searchProducts({
    required String query,
    String? storeId,
  }) {
    return safeCall.safeApiCall(() async {
      final response = await commerceRemoteDataSource.searchProducts(
        query: query,
        storeId: storeId,
      );

      return response.data.items
          .map((product) => product.toDomain())
          .toList();
    });
  }
}
