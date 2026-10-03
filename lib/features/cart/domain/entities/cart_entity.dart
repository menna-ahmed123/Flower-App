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
    this.isServiceable = true,
    this.estimatedDeliveryAt,
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
      paymentMethods = const [],
      isServiceable = true,
      estimatedDeliveryAt = null;

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
  final bool isServiceable;
  final String? estimatedDeliveryAt;

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
    bool? isServiceable,
    String? estimatedDeliveryAt,
    bool updateEstimatedDeliveryAt = false,
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
      isServiceable: isServiceable ?? this.isServiceable,
      estimatedDeliveryAt: updateEstimatedDeliveryAt
          ? estimatedDeliveryAt
          : (estimatedDeliveryAt ?? this.estimatedDeliveryAt),
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
    isServiceable,
    estimatedDeliveryAt,
  ];
}

class PaymentMethodEntity extends Equatable {
  const PaymentMethodEntity({
    required this.name,
    required this.apiMethod,
    this.gateway,
  });

  final String name;
  final String apiMethod;
  final String? gateway;

  @override
  List<Object?> get props => [name, apiMethod, gateway];
}

class DeliveryEstimateEntity extends Equatable {
  const DeliveryEstimateEntity({
    this.subtotal,
    this.deliveryFee,
    this.total,
    this.estimatedDeliveryAt,
    this.isServiceable,
    this.hasData = false,
    this.includesDeliveryAt = false,
  });

  final double? subtotal;
  final double? deliveryFee;
  final double? total;
  final String? estimatedDeliveryAt;
  final bool? isServiceable;
  final bool hasData;
  final bool includesDeliveryAt;

  @override
  List<Object?> get props => [
    subtotal,
    deliveryFee,
    total,
    estimatedDeliveryAt,
    isServiceable,
    hasData,
    includesDeliveryAt,
  ];
}

class PaymentCheckoutEntity extends Equatable {
  const PaymentCheckoutEntity({
    this.checkoutUrl = '',
    this.stripeSessionId = '',
    this.paymentAttemptId = '',
  });

  final String checkoutUrl;
  final String stripeSessionId;
  final String paymentAttemptId;

  @override
  List<Object?> get props => [checkoutUrl, stripeSessionId, paymentAttemptId];
}

class OrderEntity extends Equatable {
  const OrderEntity({
    this.orderId = '',
    this.orderNumber = '',
    this.status,
    this.paymentMethod = '',
    this.paymentStatus = '',
    this.subtotal = 0,
    this.deliveryFee = 0,
    this.total = 0,
  });

  final String orderId;
  final String orderNumber;
  final String? status;
  final String paymentMethod;
  final String paymentStatus;
  final double subtotal;
  final double deliveryFee;
  final double total;

  @override
  List<Object?> get props => [
    orderId,
    orderNumber,
    status,
    paymentMethod,
    paymentStatus,
    subtotal,
    deliveryFee,
    total,
  ];
}
