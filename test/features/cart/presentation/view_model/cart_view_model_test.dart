import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flower_app/features/cart/domain/use_cases/cart_use_case.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_event.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'cart_view_model_test.mocks.dart';

@GenerateMocks([CartUseCase])
void main() {
  provideDummy<BaseResponse<CartEntity>>(
    const SuccessResponse<CartEntity>(CartEntity.empty()),
  );
  provideDummy<BaseResponse<bool>>(const SuccessResponse<bool>(true));

  late MockCartUseCase cartUseCase;
  late CartViewModel viewModel;

  final rose = CartItemEntity(
    id: 'item-1',
    productId: 'product-1',
    name: 'Red Rose',
    imageUrl: 'https://example.com/rose.jpg',
    price: 100,
    quantity: 2,
    stock: 5,
  );

  CartEntity cartWith(List<CartItemEntity> items) {
    return CartEntity(
      id: 'cart-1',
      items: items,
      subtotal: CartEntity.sumLines(items),
      deliveryFee: 0,
      total: CartEntity.sumLines(items),
      itemCount: CartEntity.sumQuantities(items),
    );
  }

  setUp(() {
    cartUseCase = MockCartUseCase();
    viewModel = CartViewModel(cartUseCase);
  });

  tearDown(() async {
    await viewModel.close();
  });

  test('loads cart successfully', () async {
    when(cartUseCase.getCart()).thenAnswer(
      (_) async => SuccessResponse(cartWith([rose])),
    );

    await viewModel.doEvent(LoadCart());

    expect(viewModel.state.cartState.data?.items, [rose]);
    expect(viewModel.state.itemCount, 2);
    expect(viewModel.state.cartState.isLoading, false);
  });

  test('add to cart updates count and rolls back on failure', () async {
    when(cartUseCase.addItem(productId: 'product-1', quantity: 1)).thenAnswer(
      (_) async => ErrorResponse(appError: BadResponseError('failed')),
    );

    await viewModel.doEvent(AddCartItemEvent(productId: 'product-1'));

    expect(viewModel.state.itemCount, 0);
    expect(viewModel.state.cartState.errorMessage, 'failed');
  });

  test('add to cart increments badge immediately', () async {
    when(cartUseCase.addItem(productId: 'product-1', quantity: 1)).thenAnswer(
      (_) async {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        return const SuccessResponse(CartEntity.empty());
      },
    );

    final pending = viewModel.doEvent(AddCartItemEvent(productId: 'product-1'));
    await Future<void>.delayed(Duration.zero);
    expect(viewModel.state.itemCount, 1);
    await pending;
  });

  test('does not increment quantity above stock', () async {
    when(cartUseCase.getCart()).thenAnswer(
      (_) async => SuccessResponse(cartWith([rose.copyWith(quantity: 5)])),
    );
    await viewModel.doEvent(LoadCart());

    viewModel.doEvent(ChangeCartItemQuantity(itemId: 'item-1', delta: 1));

    expect(viewModel.state.cartState.data?.items.first.quantity, 5);
    verifyNever(
      cartUseCase.updateItem(itemId: anyNamed('itemId'), quantity: anyNamed('quantity')),
    );
  });

  test('decrement to zero removes the line', () async {
    when(cartUseCase.getCart()).thenAnswer(
      (_) async => SuccessResponse(cartWith([rose.copyWith(quantity: 1)])),
    );
    when(cartUseCase.removeItem(itemId: 'item-1')).thenAnswer(
      (_) async => const SuccessResponse(true),
    );
    await viewModel.doEvent(LoadCart());

    await viewModel.doEvent(ChangeCartItemQuantity(itemId: 'item-1', delta: -1));

    expect(viewModel.state.cartState.data?.items, isEmpty);
    verify(cartUseCase.removeItem(itemId: 'item-1')).called(1);
  });

  test('remove failure restores the previous line', () async {
    when(cartUseCase.getCart()).thenAnswer(
      (_) async => SuccessResponse(cartWith([rose])),
    );
    when(cartUseCase.removeItem(itemId: 'item-1')).thenAnswer(
      (_) async => ErrorResponse(appError: BadResponseError('failed')),
    );
    await viewModel.doEvent(LoadCart());

    await viewModel.doEvent(RemoveCartItemEvent(itemId: 'item-1'));

    expect(viewModel.state.cartState.data?.items, [rose]);
    expect(viewModel.state.cartState.errorMessage, 'failed');
  });

  test('quantity patch failure rolls back the previous quantity', () async {
    when(cartUseCase.getCart()).thenAnswer(
      (_) async => SuccessResponse(cartWith([rose])),
    );
    when(cartUseCase.updateItem(itemId: 'item-1', quantity: 3)).thenAnswer(
      (_) async => ErrorResponse(appError: BadResponseError('failed')),
    );
    await viewModel.doEvent(LoadCart());

    await viewModel.doEvent(ChangeCartItemQuantity(itemId: 'item-1', delta: 1));
    await Future<void>.delayed(const Duration(milliseconds: 450));

    expect(viewModel.state.cartState.data?.items.first.quantity, 2);
    expect(viewModel.state.cartState.errorMessage, 'failed');
  });

  test('rapid quantity changes send one settled patch', () async {
    when(cartUseCase.getCart()).thenAnswer(
      (_) async => SuccessResponse(cartWith([rose])),
    );
    when(
      cartUseCase.updateItem(itemId: 'item-1', quantity: 5),
    ).thenAnswer((_) async => SuccessResponse(cartWith([rose.copyWith(quantity: 5)])));
    await viewModel.doEvent(LoadCart());

    viewModel.doEvent(ChangeCartItemQuantity(itemId: 'item-1', delta: 1));
    viewModel.doEvent(ChangeCartItemQuantity(itemId: 'item-1', delta: 1));
    viewModel.doEvent(ChangeCartItemQuantity(itemId: 'item-1', delta: 1));
    await Future<void>.delayed(const Duration(milliseconds: 450));

    verify(cartUseCase.updateItem(itemId: 'item-1', quantity: 5)).called(1);
    expect(viewModel.state.cartState.data?.items.first.quantity, 5);
  });
}
