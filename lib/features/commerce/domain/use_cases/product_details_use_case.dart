import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/commerce/domain/entities/product_details_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProductDetailsUseCase {
  final CommerceRepo commerceRepo;

  ProductDetailsUseCase( {required this.commerceRepo});

  Future<BaseResponse<ProductDetailsEntity>> call({required String productId}) {
    return commerceRepo.getProductDetails(productId: productId);
  }
}