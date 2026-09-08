import 'package:injectable/injectable.dart';
import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/commerce/domain/entities/category_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';

@injectable
class CategoryUseCase {
  final CommerceRepo _commerceRepo;

  CategoryUseCase(this._commerceRepo);

  Future<BaseResponse<List<CategoryEntity>>> call() {
    return _commerceRepo.getAllCategories();
  }
}
