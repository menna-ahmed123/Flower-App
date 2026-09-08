import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';
import 'package:flower_app/features/commerce/domain/use_cases/product_use_case.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class SearchUseCase {
  SearchUseCase(this.productUseCase);

  final ProductUseCase productUseCase;

  Future<BaseResponse<List<ProductEntity>>> call({
    required String query,
  }) {
    return productUseCase(search: query);
  }
}