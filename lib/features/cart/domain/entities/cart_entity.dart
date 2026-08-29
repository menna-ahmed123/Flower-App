import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  const CartItemEntity({
    required this.id,
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    this.attributes,
    this.stock,
  });

  final String id;
  final String productId;
  final String name;
  final String imageUrl;
  final String? attributes;
  final double price;
  final int quantity;
  final int? stock;

  double get lineTotal => price * quantity;

  CartItemEntity copyWith({int? quantity}) {
    return CartItemEntity(
      id: id,
      productId: productId,
      name: name,
      imageUrl: imageUrl,
      attributes: attributes,
      price: price,
      quantity: quantity ?? this.quantity,
      stock: stock,
    );
  }

  @override
  List<Object?> get props => [
        id,
        productId,
        name,
        imageUrl,
        attributes,
        price,
        quantity,
        stock,
      ];
}

class CartEntity extends Equatable {
  const CartEntity({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.itemCount,
  });

  const CartEntity.empty()
      : id = '',
        items = const [],
        subtotal = 0,
        deliveryFee = 0,
        total = 0,
        itemCount = 0;

  final String id;
  final List<CartItemEntity> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final int itemCount;

  static double sumLines(List<CartItemEntity> items) {
    return items.fold(0, (sum, item) => sum + item.lineTotal);
  }

  static int sumQuantities(List<CartItemEntity> items) {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  CartEntity copyWith({
    String? id,
    List<CartItemEntity>? items,
    double? subtotal,
    double? deliveryFee,
    double? total,
    int? itemCount,
  }) {
    return CartEntity(
      id: id ?? this.id,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      itemCount: itemCount ?? this.itemCount,
    );
  }

  CartEntity recalculated() {
    final lines = sumLines(items);
    return copyWith(
      subtotal: lines,
      total: lines + deliveryFee,
      itemCount: sumQuantities(items),
    );
  }

  @override
  List<Object?> get props => [id, items, subtotal, deliveryFee, total, itemCount];
}
