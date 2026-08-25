import 'package:json_annotation/json_annotation.dart';
import 'package:flower_app/features/commerce/data/models/category_model.dart';

part 'categories_response.g.dart';

@JsonSerializable()
class CategoriesResponse {
  final List<CategoryModel> data;
  final int statusCode;
  final bool success;
  final String message;
  final String messageLocalized;

  const CategoriesResponse({
    required this.data,
    required this.statusCode,
    required this.success,
    required this.message,
    required this.messageLocalized,
  });

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoriesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CategoriesResponseToJson(this);
}
