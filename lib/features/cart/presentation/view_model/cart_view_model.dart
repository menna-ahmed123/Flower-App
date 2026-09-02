import 'dart:async';

import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flower_app/features/cart/domain/use_cases/cart_use_case.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_event.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CartViewModel extends Cubit<CartState> {
  CartViewModel(this._cartUseCase) : super(const CartState());

  final CartUseCase _cartUseCase;
  final Map<String, Timer> _quantityTimers = {};
  final Map<String, CartItemEntity> _quantitySnapshots = {};
  int _pendingMutations = 0;
  int _loadGeneration = 0;

  static const _quantityDebounce = Duration(milliseconds: 400);

  Future<void> doEvent(CartEvent event) async {
    switch (event) {
      case LoadCart():
        await _loadCart();
      case ResetCart():
        _reset();
      case AddCartItemEvent():
        await _addItem(event.productId, event.quantity);
      case ChangeCartItemQuantity():
        await _changeQuantity(event.itemId, event.delta);
      case RemoveCartItemEvent():
        await _removeItem(event.itemId);
    }
  }

  Future<void> _loadCart() async {
    final generation = ++_loadGeneration;
    if (state.cartState.data == null) _emitLoading();
    final response = await _cartUseCase.getCart();
    if (generation != _loadGeneration || _pendingMutations > 0) return;
    if (_quantityTimers.isNotEmpty) return;
    _applyLoadResponse(response);
  }

  Future<void> _addItem(String productId, int quantity) async {
    final previous = _currentCart();
    _emitCart(_optimisticAdd(previous, quantity));
    _pendingMutations++;
    final response = await _cartUseCase.addItem(
      productId: productId,
      quantity: quantity,
    );
    _pendingMutations--;
    _applyMutationResponse(response, previous);
  }

  Future<void> _changeQuantity(String itemId, int delta) async {
    final item = _findItem(itemId);
    if (item == null) return;
    final next = item.quantity + delta;
    if (delta > 0 && item.stock != null && next > item.stock!) return;
    if (next <= 0) {
      await _removeItem(itemId);
      return;
    }
    _scheduleQuantityCommit(itemId, next);
  }

  Future<void> _removeItem(String itemId) async {
    _quantityTimers.remove(itemId)?.cancel();
    _quantitySnapshots.remove(itemId);
    final previous = _currentCart();
    if (previous == null) return;
    _emitCart(previous.copyWith(items: previous.items.where((item) {
      return item.id != itemId;
    }).toList()).recalculated());
    _pendingMutations++;
    final response = await _cartUseCase.removeItem(itemId: itemId);
    _pendingMutations--;
    _applyRemoveResponse(response, previous);
  }

  void _scheduleQuantityCommit(String itemId, int next) {
    final item = _findItem(itemId);
    if (item == null) return;
    _quantitySnapshots.putIfAbsent(itemId, () => item);
    _applyLocalQuantity(itemId, next);
    _quantityTimers[itemId]?.cancel();
    _quantityTimers[itemId] = Timer(_quantityDebounce, () {
      _commitQuantity(itemId);
    });
  }

  Future<void> _commitQuantity(String itemId) async {
    _quantityTimers.remove(itemId);
    final snapshot = _quantitySnapshots.remove(itemId);
    final current = _findItem(itemId);
    if (snapshot == null || current == null) return;
    if (current.quantity == snapshot.quantity) return;
    _pendingMutations++;
    final response = await _cartUseCase.updateItem(
      itemId: itemId,
      quantity: current.quantity,
    );
    _pendingMutations--;
    _applyMutationResponse(response, _rollbackQuantity(snapshot));
  }

  CartEntity _optimisticAdd(CartEntity? previous, int quantity) {
    final cart = previous ?? const CartEntity.empty();
    return cart.copyWith(itemCount: cart.itemCount + quantity);
  }

  CartEntity _rollbackQuantity(CartItemEntity snapshot) {
    final cart = _currentCart() ?? const CartEntity.empty();
    return cart.copyWith(items: [
      for (final item in cart.items)
        if (item.id == snapshot.id) snapshot else item,
    ]).recalculated();
  }

  void _applyLocalQuantity(String itemId, int quantity) {
    final cart = _currentCart();
    if (cart == null) return;
    _emitCart(cart.copyWith(items: [
      for (final item in cart.items)
        if (item.id == itemId) item.copyWith(quantity: quantity) else item,
    ]).recalculated());
  }

  void _applyLoadResponse(BaseResponse<CartEntity> response) {
    switch (response) {
      case SuccessResponse<CartEntity>():
        _emitCart(response.data, isLoading: false);
      case ErrorResponse<CartEntity>():
        _emitError(response.errorMessage, keepData: true);
    }
  }

  void _applyMutationResponse(
    BaseResponse<CartEntity> response,
    CartEntity? previous,
  ) {
    switch (response) {
      case SuccessResponse<CartEntity>():
        if (_pendingMutations == 0 && _quantityTimers.isEmpty) {
          if (response.data.items.isNotEmpty) _emitCart(response.data);
        }
      case ErrorResponse<CartEntity>():
        _emitError(response.errorMessage, cart: previous);
    }
  }

  void _applyRemoveResponse(BaseResponse<bool> response, CartEntity previous) {
    switch (response) {
      case SuccessResponse<bool>():
        return;
      case ErrorResponse<bool>():
        _emitError(response.errorMessage, cart: previous);
    }
  }

  CartEntity? _currentCart() => state.cartState.data;

  CartItemEntity? _findItem(String itemId) {
    final items = _currentCart()?.items ?? const [];
    for (final item in items) {
      if (item.id == itemId) return item;
    }
    return null;
  }

  void _emitLoading() {
    emit(
      state.copyWith(
        cartState: state.cartState.copyWith(isLoading: true, errorMessage: ''),
      ),
    );
  }

  void _emitCart(CartEntity cart, {bool isLoading = false}) {
    emit(
      state.copyWith(
        cartState: state.cartState.copyWith(
          isLoading: isLoading,
          errorMessage: '',
          data: cart,
        ),
      ),
    );
  }

  void _emitError(String message, {CartEntity? cart, bool keepData = false}) {
    emit(
      state.copyWith(
        cartState: BaseState(
          isLoading: false,
          errorMessage: message,
          data: cart ?? (keepData ? state.cartState.data : null),
        ),
      ),
    );
  }

  void _reset() {
    _loadGeneration++;
    _pendingMutations = 0;
    _cancelQuantityTimers();
    emit(const CartState());
  }

  void _cancelQuantityTimers() {
    for (final timer in _quantityTimers.values) {
      timer.cancel();
    }
    _quantityTimers.clear();
    _quantitySnapshots.clear();
  }

  @override
  Future<void> close() {
    _cancelQuantityTimers();
    return super.close();
  }
}
