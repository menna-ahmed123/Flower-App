import 'package:json_annotation/json_annotation.dart';
import 'package:flower_app/features/commerce/domain/entities/category_entity.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "iconUrl")
  final String? iconUrl;
  @JsonKey(name: "displayOrder")
  final int? displayOrder;
  @JsonKey(name: "isDeleted")
  final bool? isDeleted;
  @JsonKey(name: "createdAt")
  final String? createdAt;
  @JsonKey(name: "updatedAt")
  final String? updatedAt;
  @JsonKey(name: "lastChangedBy")
  final String? lastChangedBy;

  CategoryModel({
    this.id,
    this.name,
    this.iconUrl,
    this.displayOrder,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.lastChangedBy,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return _$CategoryModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CategoryModelToJson(this);
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      iconUrl: iconUrl,
      displayOrder: displayOrder,
      isDeleted: isDeleted,
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastChangedBy: lastChangedBy,
    );
  }
}
