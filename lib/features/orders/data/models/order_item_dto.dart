import 'package:flower_app/features/orders/domain/entities/order_item_entity.dart';

// Provisional shape: the customer order-item schema is not documented, but field names mirror the
// sibling Cart/CartLine schema (name, imageUrl, unitPrice, quantity), which IS documented in the OpenAPI spec.
class OrderItemDto {
  final String productName;
  final String imageUrl;
  final int quantity;
  final double unitPrice;

  OrderItemDto({
    this.productName = '',
    this.imageUrl = '',
    this.quantity = 0,
    this.unitPrice = 0,
  });

  factory OrderItemDto.fromJson(Map<String, dynamic> json) {
    final nameValue = [
      json['name'],
      json['productName'],
    ].firstWhere((value) => value != null && value.toString().trim().isNotEmpty, orElse: () => '');

    final imageValue = [
      json['imageUrl'],
      json['image'],
      json['productImage'],
    ].firstWhere((value) => value != null && value.toString().trim().isNotEmpty, orElse: () => '');

    return OrderItemDto(
      productName: nameValue.toString(),
      imageUrl: imageValue.toString(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0,
    );
  }

  OrderItemEntity toDomain() {
    return OrderItemEntity(
      productName: productName,
      imageUrl: imageUrl,
      quantity: quantity,
      unitPrice: unitPrice,
    );
  }
}
