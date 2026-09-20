sealed class CartEvent {
  const CartEvent();
}

class LoadCart extends CartEvent {
  const LoadCart();
}

class ResetCart extends CartEvent {
  const ResetCart();
}

class ClearCart extends CartEvent {
  const ClearCart();
}

class AddCartItemEvent extends CartEvent {
  const AddCartItemEvent({required this.productId, this.quantity = 1});

  final String productId;
  final int quantity;
}

class ChangeCartItemQuantity extends CartEvent {
  const ChangeCartItemQuantity({required this.itemId, required this.delta});

  final String itemId;
  final int delta;
}

class RemoveCartItemEvent extends CartEvent {
  const RemoveCartItemEvent({required this.itemId});

  final String itemId;
}
