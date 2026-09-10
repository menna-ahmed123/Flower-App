import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/utils/pagination/pagination_controller.dart';
import 'package:flower_app/features/commerce/domain/entities/category_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/category_sort_by.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';
import 'package:flower_app/features/commerce/domain/use_cases/category_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_cases/product_use_case.dart';
import 'package:flower_app/features/commerce/presentation/category/view_model/category_event.dart';
import 'package:flower_app/features/commerce/presentation/category/view_model/category_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class CategoryViewModel extends Cubit<CategoryState> {
  CategoryViewModel(this.categoryUseCase, this.productUseCase)
    : super(const CategoryState()) {
    productsPaginationController = PaginationController<ProductEntity>(
      pageSize: 20,
      fetchPage: _fetchProductsPage,
    );
  }

  final CategoryUseCase categoryUseCase;
  final ProductUseCase productUseCase;

  late final PaginationController<ProductEntity> productsPaginationController;

  Future<void> onEvent(CategoryEvent event) async {
    switch (event) {
      case LoadCategories():
        await _loadCategories();

      case SelectCategoryTab():
        await _loadProductsByCategory(event.categoryId, event.tab);

      case SortProducts():
        await _sortProducts(event.sortBy);
    }
  }

  Future<void> _loadCategories() async {
    emit(
      state.copyWith(
        categoriesState: state.categoriesState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );

    final response = await categoryUseCase();

    switch (response) {
      case SuccessResponse<List<CategoryEntity>>():
        final data = response.data;
        final firstCategory = data.isNotEmpty ? data.first : null;

        emit(
          state.copyWith(
            categoriesState: state.categoriesState.copyWith(
              isLoading: false,
              data: data,
              errorMessage: '',
            ),
            selectedTab: firstCategory?.name ?? '',
            selectedCategoryId: firstCategory?.id ?? '',
            selectedSortBy: null,
          ),
        );

        if (firstCategory != null) {
          productsPaginationController.reset();
        }

      case ErrorResponse<List<CategoryEntity>>():
        emit(
          state.copyWith(
            categoriesState: state.categoriesState.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
    }
  }

  Future<void> _loadProductsByCategory(String categoryId, String tab) async {
    if (categoryId.isEmpty) {
      return;
    }

    // Reset pagination for the new category.
    productsPaginationController.reset();

    emit(
      state.copyWith(
        selectedTab: tab,
        selectedCategoryId: categoryId,
        selectedSortBy: null,
      ),
    );
  }

  Future<void> _sortProducts(CategorySortBy sortBy) async {
    final categoryId = state.selectedCategoryId;

    if (categoryId.isEmpty) {
      return;
    }

    // Reset pagination when sorting changes.
    productsPaginationController.reset();

    emit(state.copyWith(selectedSortBy: sortBy));
  }

  Future<List<ProductEntity>> _fetchProductsPage(int page, int pageSize) async {
    final response = await productUseCase(
      page: page,
      pageSize: pageSize,
      categoryId: state.selectedCategoryId,
      sortBy: state.selectedSortBy,
    );

    switch (response) {
      case SuccessResponse<List<ProductEntity>>():
        return response.data;

      case ErrorResponse<List<ProductEntity>>():
        throw Exception(response.errorMessage);
    }
  }

  @override
  Future<void> close() {
    productsPaginationController.dispose();
    return super.close();
  }
}
