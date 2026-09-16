import 'package:equatable/equatable.dart';

class OrderItemEntity extends Equatable {
  final String productName;
  final String imageUrl;
  final int quantity;
  final double unitPrice;

  const OrderItemEntity({
    this.productName = '',
    this.imageUrl = '',
    this.quantity = 0,
    this.unitPrice = 0,
  });

  @override
  List<Object?> get props => [productName, imageUrl, quantity, unitPrice];
}
