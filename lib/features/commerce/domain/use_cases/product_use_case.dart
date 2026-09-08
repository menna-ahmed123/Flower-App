import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/commerce/domain/entities/category_sort_by.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class ProductUseCase {
  final CommerceRepo commerceRepo;

  ProductUseCase(this.commerceRepo);

  Future<BaseResponse<List<ProductEntity>>> call({
    int? page,
    int? pageSize,
    String? occasionId,
    String? categoryId,
    String? search,
    CategorySortBy? sortBy,
  }) {
    return commerceRepo.getProducts(
      page: page,
      pageSize: pageSize,
      occasionId: occasionId,
      categoryId: categoryId,
      search: search,
      sortBy: sortBy,
    );
  }
}
