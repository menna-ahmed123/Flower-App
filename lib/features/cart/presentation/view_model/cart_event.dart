sealed class CartEvent {}

class LoadCart extends CartEvent {}

class ResetCart extends CartEvent {}

class AddCartItemEvent extends CartEvent {
  AddCartItemEvent({required this.productId, this.quantity = 1});

  final String productId;
  final int quantity;
}

class ChangeCartItemQuantity extends CartEvent {
  ChangeCartItemQuantity({required this.itemId, required this.delta});

  final String itemId;
  final int delta;
}

class RemoveCartItemEvent extends CartEvent {
  RemoveCartItemEvent({required this.itemId});

  final String itemId;
}
