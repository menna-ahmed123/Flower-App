import 'package:json_annotation/json_annotation.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderModel {
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "orderNumber")
  final String? orderNumber;
  @JsonKey(name: "createdAt")
  final String? createdAt;
  @JsonKey(name: "itemCount")
  final int? itemCount;
  @JsonKey(name: "firstItemThumbnailUrl")
  final String? firstItemThumbnailUrl;
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "total")
  final double? total;
  @JsonKey(name: "paymentStatus")
  final String? paymentStatus;

  OrderModel({
    this.id,
    this.orderNumber,
    this.createdAt,
    this.itemCount,
    this.firstItemThumbnailUrl,
    this.status,
    this.total,
    this.paymentStatus,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return _$OrderModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$OrderModelToJson(this);
  }
}



