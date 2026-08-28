import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchUseCase {
  SearchUseCase(this.commerceRepo);

  final CommerceRepo commerceRepo;

  Future<BaseResponse<List<ProductEntity>>> call({
    required String query,
    String? storeId,
  }) {
    return commerceRepo.searchProducts(query: query, storeId: storeId);
  }
}
