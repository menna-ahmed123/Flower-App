import 'package:json_annotation/json_annotation.dart';

part 'delivery_confirmation_model.g.dart';

@JsonSerializable()
class DeliveryConfirmationModel {
  @JsonKey(name: "orderId")
  final String? orderId;
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "confirmedAt")
  final String? confirmedAt;

  const DeliveryConfirmationModel({
    this.orderId,
    this.status,
    this.confirmedAt,
  });

  factory DeliveryConfirmationModel.fromJson(Map<String, dynamic> json) {
    return _$DeliveryConfirmationModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DeliveryConfirmationModelToJson(this);
  }
}
