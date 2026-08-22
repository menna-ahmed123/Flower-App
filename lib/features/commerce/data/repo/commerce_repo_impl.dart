import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/commerce/data/data_sources/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/data/models/product_details_response_model.dart';
import 'package:flower_app/features/commerce/domain/entities/product_details_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';
@Injectable(as: CommerceRepo)
class CommerceRepoImpl implements CommerceRepo {
  final CommerceRemoteDataSource commerceRemoteDataSource;

  CommerceRepoImpl(this.commerceRemoteDataSource);

  @override
  Future<BaseResponse<ProductDetailsEntity>> getProductDetails({
    required String productId,
  }) async {
    final response = await commerceRemoteDataSource.getProductDetails(
      productId: productId,
    );

    switch (response) {
      case SuccessResponse<ProductDetailsResponseModel>():
        final entity = response.data.data!.toDomain();
        return SuccessResponse<ProductDetailsEntity>(entity);

      case ErrorResponse<ProductDetailsResponseModel>():
        return ErrorResponse<ProductDetailsEntity>(appError: response.appError);
    }
  }
}
