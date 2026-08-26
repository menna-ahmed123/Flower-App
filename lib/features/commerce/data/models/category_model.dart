import 'package:json_annotation/json_annotation.dart';
import 'package:flower_app/features/commerce/domain/entities/category_entity.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  final String id;
  final String name;
  final String? imageUrl;
  final String? deepLink;

  const CategoryModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.deepLink,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  CategoryEntity toEntity() {
    return CategoryEntity(id: id, name: name);
  }
}
