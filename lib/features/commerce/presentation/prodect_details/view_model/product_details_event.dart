abstract class ProductDetailsEvent {
  const ProductDetailsEvent();
}

class GetProductDetailsEvent extends ProductDetailsEvent {
  final String productId;

  const GetProductDetailsEvent({required this.productId});
}
