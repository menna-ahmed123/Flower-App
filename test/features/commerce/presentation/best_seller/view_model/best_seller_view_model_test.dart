import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';
import 'package:flower_app/features/commerce/domain/use_cases/product_use_case.dart';
import 'package:flower_app/features/commerce/presentation/best_seller/view_model/best_seller_event.dart';
import 'package:flower_app/features/commerce/presentation/best_seller/view_model/best_seller_state.dart';
import 'package:flower_app/features/commerce/presentation/best_seller/view_model/best_seller_view_model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'best_seller_view_model_test.mocks.dart';

@GenerateMocks([ProductUseCase])
void main() {
  late MockProductUseCase productUseCase;

  final dummyProducts = [
    const ProductEntity(
      id: '1',
      name: 'Red Rose Bouquet',
      imageUrl: 'https://example.com/rose.jpg',
      price: 25.0,
      discountedPrice: 20.0,
      discountPercent: 20.0,
      inStock: true,
    ),
    const ProductEntity(
      id: '2',
      name: 'White Lily Bunch',
      imageUrl: 'https://example.com/lily.jpg',
      price: 22.5,
      discountedPrice: 22.5,
      discountPercent: 0.0,
      inStock: false,
    ),
  ];

  setUp(() {
    productUseCase = MockProductUseCase();
  });

  group('BestSellerViewModel', () {
    blocTest<BestSellerViewModel, BestSellerState>(
      'emits loading then success state when products load successfully',
      setUp: () {
        when(productUseCase.call())
            .thenAnswer((_) async => SuccessResponse(dummyProducts));
      },
      build: () => BestSellerViewModel(productUseCase),
      act: (viewModel) => viewModel.doEvent(BestSeller()),
      expect: () => [
          const BestSellerState(
            bestSellState: BaseState<List<ProductEntity>>(
              isLoading: true,
              errorMessage: '',
            ),
          ),
          BestSellerState(
            bestSellState: BaseState<List<ProductEntity>>(
              isLoading: false,
              errorMessage: '',
              data: dummyProducts,
            ),
          ),
      ],
    );

    blocTest<BestSellerViewModel, BestSellerState>(
      'emits loading then error state when products load fails',
      setUp: () {
        when(productUseCase.call()).thenAnswer(
          (_) async => ErrorResponse<List<ProductEntity>>(
            appError: BadResponseError('No Found Page'),
          ),
        );
      },
      build: () => BestSellerViewModel(productUseCase),
      act: (viewModel) => viewModel.doEvent(BestSeller()),
      expect: () => [
          const BestSellerState(
            bestSellState: BaseState<List<ProductEntity>>(
              isLoading: true,
              errorMessage: '',
            ),
          ),
          BestSellerState(
            bestSellState: BaseState<List<ProductEntity>>(
              isLoading: false,
              errorMessage: 'No Found Page',
            ),
          ),
      ],
    );
  });
}