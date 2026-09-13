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
  _loadCartTests();
  _addCartTests();
  _stockQuantityTests();
  _patchQuantityTests();
  _removeCartTests();
  _raceCartTests();
}

final _rose = CartItemEntity(
  id: 'item-1',
  productId: 'product-1',
  name: 'Red Rose',
  imageUrl: 'https://example.com/rose.jpg',
  price: 100,
  quantity: 2,
  stock: 5,
);

CartEntity _cartWith(List<CartItemEntity> items) {
  return CartEntity(
    id: 'cart-1',
    items: items,
    subtotal: CartEntity.sumLines(items),
    deliveryFee: 0,
    total: CartEntity.sumLines(items),
    itemCount: CartEntity.sumQuantities(items),
  );
}

class CartViewModelCase {
  late MockCartUseCase useCase;
  late CartViewModel viewModel;

  void setUp() {
    useCase = MockCartUseCase();
    viewModel = CartViewModel(useCase);
  }

  Future<void> tearDown() => viewModel.close();
}

void _loadCartTests() {
  group('load', () {
    final vm = CartViewModelCase();
    setUp(vm.setUp);
    tearDown(vm.tearDown);
    test('loads cart successfully', () => _loadsSuccessfully(vm));
    test('shows loading on the first load', () => _showsFirstLoad(vm));
    test('does not show loading when a cart is already loaded', () {
      return _noReloadSpinner(vm);
    });
    test('emits error when load fails', () => _loadFails(vm));
    test('load error keeps previously loaded cart', () => _loadKeepsCart(vm));
    test('reset clears cart state', () => _resetClears(vm));
  });
}

Future<void> _loadsSuccessfully(CartViewModelCase vm) async {
  when(vm.useCase.getCart()).thenAnswer(
    (_) async => SuccessResponse(_cartWith([_rose])),
  );
  await vm.viewModel.doEvent(const LoadCart());
  expect(vm.viewModel.state.cartState.data?.items, [_rose]);
  expect(vm.viewModel.state.itemCount, 2);
  expect(vm.viewModel.state.cartState.isLoading, false);
}

Future<void> _showsFirstLoad(CartViewModelCase vm) async {
  when(vm.useCase.getCart()).thenAnswer((_) async {
    await Future<void>.delayed(const Duration(milliseconds: 20));
    return SuccessResponse(_cartWith([_rose]));
  });
  final pending = vm.viewModel.doEvent(const LoadCart());
  await Future<void>.delayed(Duration.zero);
  expect(vm.viewModel.state.cartState.isLoading, isTrue);
  expect(vm.viewModel.state.cartState.data, isNull);
  await pending;
  expect(vm.viewModel.state.cartState.isLoading, isFalse);
}

Future<void> _noReloadSpinner(CartViewModelCase vm) async {
  when(vm.useCase.getCart()).thenAnswer(
    (_) async => SuccessResponse(_cartWith([_rose])),
  );
  await vm.viewModel.doEvent(const LoadCart());
  when(vm.useCase.getCart()).thenAnswer((_) async {
    await Future<void>.delayed(const Duration(milliseconds: 20));
    return SuccessResponse(_cartWith([_rose]));
  });
  final pending = vm.viewModel.doEvent(const LoadCart());
  await Future<void>.delayed(Duration.zero);
  expect(vm.viewModel.state.cartState.isLoading, isFalse);
  expect(vm.viewModel.state.cartState.data?.items, [_rose]);
  await pending;
}

Future<void> _loadFails(CartViewModelCase vm) async {
  when(vm.useCase.getCart()).thenAnswer(
    (_) async => ErrorResponse(appError: BadResponseError('offline')),
  );
  await vm.viewModel.doEvent(const LoadCart());
  expect(vm.viewModel.state.cartState.errorMessage, 'offline');
  expect(vm.viewModel.state.cartState.data, isNull);
  expect(vm.viewModel.state.cartState.isLoading, isFalse);
}

Future<void> _loadKeepsCart(CartViewModelCase vm) async {
  when(vm.useCase.getCart()).thenAnswer(
    (_) async => SuccessResponse(_cartWith([_rose])),
  );
  await vm.viewModel.doEvent(const LoadCart());
  when(vm.useCase.getCart()).thenAnswer(
    (_) async => ErrorResponse(appError: BadResponseError('offline')),
  );
  await vm.viewModel.doEvent(const LoadCart());
  expect(vm.viewModel.state.cartState.data?.items, [_rose]);
  expect(vm.viewModel.state.cartState.errorMessage, 'offline');
}

Future<void> _resetClears(CartViewModelCase vm) async {
  when(vm.useCase.getCart()).thenAnswer(
    (_) async => SuccessResponse(_cartWith([_rose])),
  );
  await vm.viewModel.doEvent(const LoadCart());
  await vm.viewModel.doEvent(const ResetCart());
  expect(vm.viewModel.state.cartState.data, isNull);
  expect(vm.viewModel.state.itemCount, 0);
  expect(vm.viewModel.state.cartState.errorMessage, isEmpty);
}

void _addCartTests() {
  group('add', () {
    final vm = CartViewModelCase();
    setUp(vm.setUp);
    tearDown(vm.tearDown);
    test('add to cart updates count and rolls back on failure', () {
      return _addRollsBack(vm);
    });
    test('add to cart increments badge immediately', () => _addIncrements(vm));
    test('add to cart success emits the server cart', () => _addEmitsServer(vm));
    test('add to cart success with empty items keeps optimistic count', () {
      return _addKeepsOptimistic(vm);
    });
  });
}

Future<void> _addRollsBack(CartViewModelCase vm) async {
  when(vm.useCase.addItem(productId: 'product-1', quantity: 1)).thenAnswer(
    (_) async => ErrorResponse(appError: BadResponseError('failed')),
  );
  await vm.viewModel.doEvent(const AddCartItemEvent(productId: 'product-1'));
  expect(vm.viewModel.state.itemCount, 0);
  expect(vm.viewModel.state.cartState.errorMessage, 'failed');
}

Future<void> _addIncrements(CartViewModelCase vm) async {
  when(vm.useCase.addItem(productId: 'product-1', quantity: 1)).thenAnswer(
    (_) async {
      await Future<void>.delayed(const Duration(milliseconds: 20));
      return const SuccessResponse(CartEntity.empty());
    },
  );
  final pending = vm.viewModel.doEvent(
    const AddCartItemEvent(productId: 'product-1'),
  );
  await Future<void>.delayed(Duration.zero);
  expect(vm.viewModel.state.itemCount, 1);
  await pending;
}

Future<void> _addEmitsServer(CartViewModelCase vm) async {
  final server = _cartWith([_rose]);
  when(vm.useCase.addItem(productId: 'product-1', quantity: 1)).thenAnswer(
    (_) async => SuccessResponse(server),
  );
  await vm.viewModel.doEvent(const AddCartItemEvent(productId: 'product-1'));
  expect(vm.viewModel.state.cartState.data, server);
  expect(vm.viewModel.state.cartState.errorMessage, isEmpty);
}

Future<void> _addKeepsOptimistic(CartViewModelCase vm) async {
  when(vm.useCase.addItem(productId: 'product-1', quantity: 1)).thenAnswer(
    (_) async => const SuccessResponse(CartEntity.empty()),
  );
  await vm.viewModel.doEvent(const AddCartItemEvent(productId: 'product-1'));
  expect(vm.viewModel.state.itemCount, 1);
  expect(vm.viewModel.state.cartState.errorMessage, isEmpty);
}

void _stockQuantityTests() {
  group('quantity stock', () {
    final vm = CartViewModelCase();
    setUp(vm.setUp);
    tearDown(vm.tearDown);
    test('does not increment quantity above stock', () => _blocksOverStock(vm));
    test('decrement to zero removes the line', () => _decrementRemoves(vm));
    test('change quantity for an unknown item is a no-op', () {
      return _unknownQuantityNoOp(vm);
    });
  });
}

void _patchQuantityTests() {
  group('quantity patch', () {
    final vm = CartViewModelCase();
    setUp(vm.setUp);
    tearDown(vm.tearDown);
    test('quantity patch failure rolls back the previous quantity', () {
      return _quantityPatchRollsBack(vm);
    });
    test('rapid quantity changes send one settled patch', () {
      return _rapidQuantityPatch(vm);
    });
    test('quantity increment success emits the server cart', () {
      return _quantityIncrementSuccess(vm);
    });
  });
}

Future<void> _blocksOverStock(CartViewModelCase vm) async {
  when(vm.useCase.getCart()).thenAnswer(
    (_) async => SuccessResponse(_cartWith([_rose.copyWith(quantity: 5)])),
  );
  await vm.viewModel.doEvent(const LoadCart());
  vm.viewModel.doEvent(const ChangeCartItemQuantity(itemId: 'item-1', delta: 1));
  expect(vm.viewModel.state.cartState.data?.items.first.quantity, 5);
  verifyNever(
    vm.useCase.updateItem(itemId: anyNamed('itemId'), quantity: anyNamed('quantity')),
  );
}

Future<void> _decrementRemoves(CartViewModelCase vm) async {
  when(vm.useCase.getCart()).thenAnswer(
    (_) async => SuccessResponse(_cartWith([_rose.copyWith(quantity: 1)])),
  );
  when(vm.useCase.removeItem(itemId: 'item-1')).thenAnswer(
    (_) async => const SuccessResponse(true),
  );
  await vm.viewModel.doEvent(const LoadCart());
  await vm.viewModel.doEvent(
    const ChangeCartItemQuantity(itemId: 'item-1', delta: -1),
  );
  expect(vm.viewModel.state.cartState.data?.items, isEmpty);
  verify(vm.useCase.removeItem(itemId: 'item-1')).called(1);
}

Future<void> _quantityPatchRollsBack(CartViewModelCase vm) async {
  when(vm.useCase.getCart()).thenAnswer(
    (_) async => SuccessResponse(_cartWith([_rose])),
  );
  when(vm.useCase.updateItem(itemId: 'item-1', quantity: 3)).thenAnswer(
    (_) async => ErrorResponse(appError: BadResponseError('failed')),
  );
  await vm.viewModel.doEvent(const LoadCart());
  await vm.viewModel.doEvent(
    const ChangeCartItemQuantity(itemId: 'item-1', delta: 1),
  );
  await Future<void>.delayed(const Duration(milliseconds: 450));
  expect(vm.viewModel.state.cartState.data?.items.first.quantity, 2);
  expect(vm.viewModel.state.cartState.errorMessage, 'failed');
}

Future<void> _rapidQuantityPatch(CartViewModelCase vm) async {
  when(vm.useCase.getCart()).thenAnswer(
    (_) async => SuccessResponse(_cartWith([_rose])),
  );
  when(vm.useCase.updateItem(itemId: 'item-1', quantity: 5)).thenAnswer(
    (_) async => SuccessResponse(_cartWith([_rose.copyWith(quantity: 5)])),
  );
  await vm.viewModel.doEvent(const LoadCart());
  vm.viewModel.doEvent(const ChangeCartItemQuantity(itemId: 'item-1', delta: 1));
  vm.viewModel.doEvent(const ChangeCartItemQuantity(itemId: 'item-1', delta: 1));
  vm.viewModel.doEvent(const ChangeCartItemQuantity(itemId: 'item-1', delta: 1));
  await Future<void>.delayed(const Duration(milliseconds: 450));
  verify(vm.useCase.updateItem(itemId: 'item-1', quantity: 5)).called(1);
  expect(vm.viewModel.state.cartState.data?.items.first.quantity, 5);
}

Future<void> _unknownQuantityNoOp(CartViewModelCase vm) async {
  await vm.viewModel.doEvent(
    const ChangeCartItemQuantity(itemId: 'missing', delta: 1),
  );
  verifyNever(
    vm.useCase.updateItem(
      itemId: anyNamed('itemId'),
      quantity: anyNamed('quantity'),
    ),
  );
  expect(vm.viewModel.state.cartState.data, isNull);
}

Future<void> _quantityIncrementSuccess(CartViewModelCase vm) async {
  when(vm.useCase.getCart()).thenAnswer(
    (_) async => SuccessResponse(_cartWith([_rose])),
  );
  when(vm.useCase.updateItem(itemId: 'item-1', quantity: 3)).thenAnswer(
    (_) async => SuccessResponse(_cartWith([_rose.copyWith(quantity: 3)])),
  );
  await vm.viewModel.doEvent(const LoadCart());
  await vm.viewModel.doEvent(
    const ChangeCartItemQuantity(itemId: 'item-1', delta: 1),
  );
  await Future<void>.delayed(const Duration(milliseconds: 450));
  expect(vm.viewModel.state.cartState.data?.items.first.quantity, 3);
  expect(vm.viewModel.state.cartState.errorMessage, isEmpty);
}

void _removeCartTests() {
  group('remove', () {
    final vm = CartViewModelCase();
    setUp(vm.setUp);
    tearDown(vm.tearDown);
    test('remove failure restores the previous line', () => _removeRestores(vm));
    test('remove when cart is empty is a no-op', () => _removeEmptyNoOp(vm));
    test('remove success keeps the line removed', () => _removeSuccess(vm));
  });
}

Future<void> _removeRestores(CartViewModelCase vm) async {
  when(vm.useCase.getCart()).thenAnswer(
    (_) async => SuccessResponse(_cartWith([_rose])),
  );
  when(vm.useCase.removeItem(itemId: 'item-1')).thenAnswer(
    (_) async => ErrorResponse(appError: BadResponseError('failed')),
  );
  await vm.viewModel.doEvent(const LoadCart());
  await vm.viewModel.doEvent(const RemoveCartItemEvent(itemId: 'item-1'));
  expect(vm.viewModel.state.cartState.data?.items, [_rose]);
  expect(vm.viewModel.state.cartState.errorMessage, 'failed');
}

Future<void> _removeEmptyNoOp(CartViewModelCase vm) async {
  await vm.viewModel.doEvent(const RemoveCartItemEvent(itemId: 'item-1'));
  verifyNever(vm.useCase.removeItem(itemId: anyNamed('itemId')));
}

Future<void> _removeSuccess(CartViewModelCase vm) async {
  when(vm.useCase.getCart()).thenAnswer(
    (_) async => SuccessResponse(_cartWith([_rose])),
  );
  when(vm.useCase.removeItem(itemId: 'item-1')).thenAnswer(
    (_) async => const SuccessResponse(true),
  );
  await vm.viewModel.doEvent(const LoadCart());
  await vm.viewModel.doEvent(const RemoveCartItemEvent(itemId: 'item-1'));
  expect(vm.viewModel.state.cartState.data?.items, isEmpty);
  expect(vm.viewModel.state.cartState.errorMessage, isEmpty);
}

void _raceCartTests() {
  group('races', () {
    final vm = CartViewModelCase();
    setUp(vm.setUp);
    tearDown(vm.tearDown);
    test('ignores a stale load after reset', () => _ignoresStaleLoad(vm));
    test('ignores load result while a mutation is pending', () {
      return _ignoresLoadDuringMutation(vm);
    });
    test('ignores load result while quantity debounce is pending', () {
      return _ignoresLoadDuringDebounce(vm);
    });
  });
}

Future<void> _ignoresStaleLoad(CartViewModelCase vm) async {
  when(vm.useCase.getCart()).thenAnswer((_) async {
    await Future<void>.delayed(const Duration(milliseconds: 40));
    return SuccessResponse(_cartWith([_rose]));
  });
  final pending = vm.viewModel.doEvent(const LoadCart());
  await Future<void>.delayed(Duration.zero);
  await vm.viewModel.doEvent(const ResetCart());
  await pending;
  expect(vm.viewModel.state.cartState.data, isNull);
}

Future<void> _ignoresLoadDuringMutation(CartViewModelCase vm) async {
  when(vm.useCase.getCart()).thenAnswer((_) async {
    await Future<void>.delayed(const Duration(milliseconds: 40));
    return SuccessResponse(_cartWith([_rose.copyWith(quantity: 9)]));
  });
  when(vm.useCase.addItem(productId: 'product-1', quantity: 1)).thenAnswer(
    (_) async {
      await Future<void>.delayed(const Duration(milliseconds: 80));
      return SuccessResponse(_cartWith([_rose]));
    },
  );
  final load = vm.viewModel.doEvent(const LoadCart());
  await Future<void>.delayed(const Duration(milliseconds: 10));
  final add = vm.viewModel.doEvent(const AddCartItemEvent(productId: 'product-1'));
  await load;
  expect(vm.viewModel.state.cartState.data?.items, isEmpty);
  expect(vm.viewModel.state.itemCount, 1);
  await add;
  expect(vm.viewModel.state.cartState.data?.items, [_rose]);
}

Future<void> _ignoresLoadDuringDebounce(CartViewModelCase vm) async {
  when(vm.useCase.getCart()).thenAnswer(
    (_) async => SuccessResponse(_cartWith([_rose])),
  );
  await vm.viewModel.doEvent(const LoadCart());
  when(vm.useCase.getCart()).thenAnswer((_) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return SuccessResponse(_cartWith([_rose.copyWith(quantity: 9)]));
  });
  when(vm.useCase.updateItem(itemId: 'item-1', quantity: 3)).thenAnswer(
    (_) async => SuccessResponse(_cartWith([_rose.copyWith(quantity: 3)])),
  );
  final load = vm.viewModel.doEvent(const LoadCart());
  vm.viewModel.doEvent(const ChangeCartItemQuantity(itemId: 'item-1', delta: 1));
  await load;
  expect(vm.viewModel.state.cartState.data?.items.first.quantity, 3);
  await Future<void>.delayed(const Duration(milliseconds: 450));
  verify(vm.useCase.updateItem(itemId: 'item-1', quantity: 3)).called(1);
}
