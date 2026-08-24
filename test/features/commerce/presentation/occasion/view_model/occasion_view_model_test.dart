import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/commerce/data/models/occasion_model.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';
import 'package:flower_app/features/commerce/domain/use_cases/occasion_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_cases/product_use_case.dart';
import 'package:flower_app/features/commerce/presentation/occasion/view_model/occasion_event.dart';
import 'package:flower_app/features/commerce/presentation/occasion/view_model/occasion_state.dart';
import 'package:flower_app/features/commerce/presentation/occasion/view_model/occasion_view_model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'occasion_view_model_test.mocks.dart';

@GenerateMocks([OccasionUseCase, ProductUseCase])
void main() {
  final occasions = [
    OccasionModel(
      id: 'occasion-1',
      name: 'Birthday',
      imageUrl: 'https://example.com/birthday.jpg',
      sortOrder: 1,
    ),
  ];
  final products = [
    const ProductEntity(
      id: 'product-1',
      name: 'Rose Bouquet',
      imageUrl: 'https://example.com/rose.jpg',
      price: 25,
      discountedPrice: 20,
      discountPercent: 20,
      inStock: true,
    ),
  ];

  blocTest<OccasionViewModel, OccasionState>(
    'emits loading and success states when occasions load successfully',
    build: () {
      final occasionUseCase = MockOccasionUseCase();
      final productUseCase = MockProductUseCase();
      when(
        occasionUseCase.call(),
      ).thenAnswer((_) async => SuccessResponse(occasions));
      when(
        productUseCase.getProductsByOccasion('occasion-1'),
      ).thenAnswer((_) async => SuccessResponse(products));
      return OccasionViewModel(occasionUseCase, productUseCase);
    },
    act: (viewModel) async {
      viewModel.onEvent(LoadOccasions());
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
    },
    expect: () {
      return [
        const OccasionState(
          occasionsState: BaseState(isLoading: true, errorMessage: ''),
        ),
        OccasionState(
          occasionsState: BaseState(
            isLoading: false,
            errorMessage: '',
            data: occasions,
          ),
          selectedTab: 'Birthday',
        ),
        OccasionState(
          occasionsState: BaseState(
            isLoading: false,
            errorMessage: '',
            data: occasions,
          ),
          productsState: const BaseState(isLoading: true, errorMessage: ''),
          selectedTab: 'Birthday',
        ),
        OccasionState(
          occasionsState: BaseState(
            isLoading: false,
            errorMessage: '',
            data: occasions,
          ),
          productsState: BaseState(
            isLoading: false,
            errorMessage: '',
            data: products,
          ),
          selectedTab: 'Birthday',
        ),
      ];
    },
  );

  blocTest<OccasionViewModel, OccasionState>(
    'emits an error state when loading occasions fails',
    build: () {
      final occasionUseCase = MockOccasionUseCase();
      when(occasionUseCase.call()).thenAnswer(
        (_) async => ErrorResponse<List<OccasionModel>>(
          appError: BadResponseError('No occasions found'),
        ),
      );
      return OccasionViewModel(occasionUseCase, MockProductUseCase());
    },
    act: (viewModel) async {
      viewModel.onEvent(LoadOccasions());
      await Future<void>.delayed(Duration.zero);
    },
    expect: () => [
      const OccasionState(
        occasionsState: BaseState(isLoading: true, errorMessage: ''),
      ),
      const OccasionState(
        occasionsState: BaseState(
          isLoading: false,
          errorMessage: 'No occasions found',
        ),
      ),
    ],
  );
}
