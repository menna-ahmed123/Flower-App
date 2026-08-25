sealed class CategoryEvent {}

class LoadCategories extends CategoryEvent {}

class SelectCategoryTab extends CategoryEvent {
  final String categoryId;
  final String tab;

  SelectCategoryTab({required this.categoryId, required this.tab});
}
