import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class SearchUseCase {
  SearchUseCase(this.productRepo);

  final CommerceRepo productRepo;

  Future<BaseResponse<List<ProductEntity>>> call({
    required String query,
  }) async {
    final normalizedQuery = query.trim().toLowerCase();

    final response = await productRepo.searchProducts(query: normalizedQuery);

    switch (response) {
      case SuccessResponse<List<ProductEntity>>():
        final products = response.data.where((product) {
          return product.name.toLowerCase().contains(normalizedQuery);
        }).toList();

        return SuccessResponse<List<ProductEntity>>(products);

      case ErrorResponse<List<ProductEntity>>():
        return response;
    }
  }
}
