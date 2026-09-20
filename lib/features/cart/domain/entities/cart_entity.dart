import 'package:equatable/equatable.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';

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
    this.priceChanged = false,
    this.outOfStock = false,
  });

  final String id;
  final String productId;
  final String name;
  final String imageUrl;
  final String? attributes;
  final double price;
  final int quantity;
  final int? stock;
  final bool priceChanged;
  final bool outOfStock;

  double get lineTotal => price * quantity;

  CartItemEntity copyWith({int? quantity, int? stock}) {
    return CartItemEntity(
      id: id,
      productId: productId,
      name: name,
      imageUrl: imageUrl,
      attributes: attributes,
      price: price,
      quantity: quantity ?? this.quantity,
      stock: stock ?? this.stock,
      priceChanged: priceChanged,
      outOfStock: outOfStock,
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
    priceChanged,
    outOfStock,
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
    this.discount = 0,
    this.hasChanges = false,
    this.pricingUnavailable = false,
    this.deliveryAddress,
    this.paymentMethods = const [],
  });

  const CartEntity.empty()
    : id = '',
      items = const [],
      subtotal = 0,
      deliveryFee = 0,
      discount = 0,
      total = 0,
      itemCount = 0,
      hasChanges = false,
      pricingUnavailable = false,
      deliveryAddress = null,
      paymentMethods = const [];

  final String id;
  final List<CartItemEntity> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final int itemCount;
  final bool hasChanges;
  final bool pricingUnavailable;
  final AddressEntity? deliveryAddress;
  final List<PaymentMethodEntity> paymentMethods;

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
    double? discount,
    double? total,
    int? itemCount,
    bool? hasChanges,
    bool? pricingUnavailable,
    AddressEntity? deliveryAddress,
    List<PaymentMethodEntity>? paymentMethods,
  }) {
    return CartEntity(
      id: id ?? this.id,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      itemCount: itemCount ?? this.itemCount,
      hasChanges: hasChanges ?? this.hasChanges,
      pricingUnavailable: pricingUnavailable ?? this.pricingUnavailable,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      paymentMethods: paymentMethods ?? this.paymentMethods,
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
  List<Object?> get props => [
    id,
    items,
    subtotal,
    deliveryFee,
    discount,
    total,
    itemCount,
    hasChanges,
    pricingUnavailable,
    deliveryAddress,
    paymentMethods,
  ];
}

class PaymentMethodEntity extends Equatable {
  const PaymentMethodEntity({required this.name, required this.value});

  final String name;
  final int value;

  @override
  List<Object?> get props => [name, value];
}

class CheckoutGiftEntity extends Equatable {
  const CheckoutGiftEntity({
    required this.recipientName,
    required this.phone,
    required this.addressLine,
    required this.city,
    required this.area,
    this.lat,
    this.lng,
    this.message,
  });

  final String recipientName;
  final String phone;
  final String addressLine;
  final String city;
  final String area;
  final double? lat;
  final double? lng;
  final String? message;

  @override
  List<Object?> get props => [
    recipientName,
    phone,
    addressLine,
    city,
    area,
    lat,
    lng,
    message,
  ];
}

class OrderEntity extends Equatable {
  const OrderEntity({
    this.orderId = '',
    this.orderNumber = '',
    this.status,
    this.paymentMethod = 1,
    this.paymentStatus = 0,
    this.paymentRequired,
    this.sessionUrl,
    this.successUrl,
    this.cancelUrl,
    this.subtotal = 0,
    this.deliveryFee = 0,
    this.discount = 0,
    this.total = 0,
  });

  final String orderId;
  final String orderNumber;
  final int? status;
  final int paymentMethod;
  final int paymentStatus;
  final bool? paymentRequired;
  final String? sessionUrl;
  final String? successUrl;
  final String? cancelUrl;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;

  @override
  List<Object?> get props => [
    orderId,
    orderNumber,
    status,
    paymentMethod,
    paymentStatus,
    paymentRequired,
    sessionUrl,
    successUrl,
    cancelUrl,
    subtotal,
    deliveryFee,
    discount,
    total,
  ];
}
