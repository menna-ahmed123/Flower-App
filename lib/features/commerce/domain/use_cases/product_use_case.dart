import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class ProductUseCase {
  final CommerceRepo commerceRepo;
  ProductUseCase(this.commerceRepo);
  Future<BaseResponse<List<ProductEntity>>> call() {
    return commerceRepo.getAllProducts();
  }
}
