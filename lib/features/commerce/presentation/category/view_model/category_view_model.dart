import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/commerce/domain/entities/category_entity.dart';
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
    : super(const CategoryState());

  final CategoryUseCase categoryUseCase;
  final ProductUseCase productUseCase;

  void onEvent(CategoryEvent event) {
    switch (event) {
      case LoadCategories():
        _loadCategories();
      case SelectCategoryTab():
        _loadProductsByCategory(event.categoryId, event.tab);
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
          ),
        );

        if (firstCategory != null) {
          await _loadProductsByCategory(firstCategory.id, firstCategory.name);
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
    emit(
      state.copyWith(
        selectedTab: tab,
        productsState: state.productsState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );

    final response = await productUseCase.getProductsByCategory(categoryId);

    switch (response) {
      case SuccessResponse<List<ProductEntity>>():
        emit(
          state.copyWith(
            productsState: state.productsState.copyWith(
              isLoading: false,
              data: response.data,
              errorMessage: '',
            ),
          ),
        );
      case ErrorResponse<List<ProductEntity>>():
        emit(
          state.copyWith(
            productsState: state.productsState.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
    }
  }
}
