import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/commerce/domain/entities/category_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';
import 'package:flower_app/features/commerce/domain/use_cases/category_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_cases/product_use_case.dart';
import 'package:flower_app/features/commerce/presentation/category/view_model/category_event.dart';
import 'package:flower_app/features/commerce/presentation/category/view_model/category_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'category_view_model_test.mocks.dart';

@GenerateMocks([CategoryUseCase, ProductUseCase])
void main() {
  late MockCategoryUseCase categoryUseCase;
  late MockProductUseCase productUseCase;
  late CategoryViewModel categoryViewModel;

  setUp(() {
    categoryUseCase = MockCategoryUseCase();
    productUseCase = MockProductUseCase();

    categoryViewModel = CategoryViewModel(categoryUseCase, productUseCase);
  });

  group('LoadCategories', () {
    test('should load categories successfully', () async {
      // Arrange
      final categories = [const CategoryEntity(id: '1', name: 'Flowers')];

      when(categoryUseCase.call()).thenAnswer(
        (_) async => SuccessResponse<List<CategoryEntity>>(categories),
      );

      when(
        productUseCase.getProductsByCategory('1'),
      ).thenAnswer((_) async => SuccessResponse<List<ProductEntity>>([]));

      // Act
      await categoryViewModel.onEvent(LoadCategories());

      // Assert
      expect(categoryViewModel.state.categoriesState.data, categories);

      expect(categoryViewModel.state.selectedTab, 'Flowers');

      verify(categoryUseCase.call()).called(1);

      verify(productUseCase.getProductsByCategory('1')).called(1);
    });
  });

  group('SelectCategoryTab', () {
    test('should load products when category tab is selected', () async {
      // Arrange
      const categoryId = '1';
      const tab = 'Flowers';

      final products = <ProductEntity>[];

      when(
        productUseCase.getProductsByCategory(categoryId),
      ).thenAnswer((_) async => SuccessResponse<List<ProductEntity>>(products));

      // Act
      await categoryViewModel.onEvent(
        SelectCategoryTab(categoryId: categoryId, tab: tab),
      );

      // Assert
      expect(categoryViewModel.state.productsState.data, products);

      expect(categoryViewModel.state.selectedTab, tab);

      verify(productUseCase.getProductsByCategory(categoryId)).called(1);
    });
  });
}
