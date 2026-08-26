import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/commerce/domain/entities/category_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';

class CategoryState extends Equatable {
  final BaseState<List<CategoryEntity>> categoriesState;
  final BaseState<List<ProductEntity>> productsState;
  final String selectedTab;

  const CategoryState({
    this.categoriesState = const BaseState(),
    this.productsState = const BaseState(),
    this.selectedTab = '',
  });

  CategoryState copyWith({
    BaseState<List<CategoryEntity>>? categoriesState,
    BaseState<List<ProductEntity>>? productsState,
    String? selectedTab,
  }) {
    return CategoryState(
      categoriesState: categoriesState ?? this.categoriesState,
      productsState: productsState ?? this.productsState,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }

  @override
  List<Object?> get props => [categoriesState, productsState, selectedTab];
}
