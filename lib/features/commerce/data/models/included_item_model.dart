import 'package:flower_app/features/commerce/domain/entities/included_item_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'included_item_model.g.dart';

@JsonSerializable()
class IncludedItemModel {
  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'quantity')
  final int? quantity;

  const IncludedItemModel({this.name, this.quantity});

  factory IncludedItemModel.fromJson(Map<String, dynamic> json) {
    return _$IncludedItemModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$IncludedItemModelToJson(this);
  }

  IncludedItemEntity toDomain() {
    return IncludedItemEntity(name: name, quantity: quantity);
  }
}
