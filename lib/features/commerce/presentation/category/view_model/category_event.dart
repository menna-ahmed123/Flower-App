import 'package:flower_app/features/commerce/domain/entities/category_sort_by.dart';

sealed class CategoryEvent {}

class LoadCategories extends CategoryEvent {}

class SelectCategoryTab extends CategoryEvent {
  final String categoryId;
  final String tab;

  SelectCategoryTab({required this.categoryId, required this.tab});
}

class SortProducts extends CategoryEvent {
  final CategorySortBy sortBy;

  SortProducts(this.sortBy);
}
