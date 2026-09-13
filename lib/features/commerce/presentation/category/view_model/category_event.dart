import 'package:flower_app/features/commerce/domain/entities/category_sort_by.dart';

sealed class CategoryEvent {
  const CategoryEvent();
}

class LoadCategories extends CategoryEvent {
  const LoadCategories();
}

class SelectCategoryTab extends CategoryEvent {
  final String categoryId;
  final String tab;

  const SelectCategoryTab({required this.categoryId, required this.tab});
}

class SortProducts extends CategoryEvent {
  final CategorySortBy sortBy;

  const SortProducts(this.sortBy);
}
