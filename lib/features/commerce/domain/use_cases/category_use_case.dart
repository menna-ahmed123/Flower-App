import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/commerce/domain/entities/category_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class CategoryUseCase {
  final CommerceRepo repo;

  CategoryUseCase(this.repo);

  Future<BaseResponse<List<CategoryEntity>>> call() {
    return repo.getAllCategories();
  }
}
