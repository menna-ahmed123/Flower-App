import 'package:json_annotation/json_annotation.dart';

import 'categories_response.dart' show Pagination;
import 'product_details_model.dart';

part 'product_details_response_model.g.dart';

/// Response wrapper for GET /api/catalog/products/{id} (new API format).
/// { status, code, message, data: {...}, pagination, errors }
@JsonSerializable()
class ProductDetailsResponseModel {
  const ProductDetailsResponseModel({
    this.status,
    this.code,
    this.message,
    this.data,
    this.pagination,
    this.errors,
  });

  @JsonKey(name: 'status')
  final bool? status;

  @JsonKey(name: 'code')
  final int? code;

  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'data')
  final ProductDetailsModel? data;

  @JsonKey(name: 'pagination')
  final Pagination? pagination;

  @JsonKey(name: 'errors')
  final dynamic errors;

  factory ProductDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDetailsResponseModelToJson(this);

  bool get isSuccess =>
      (status ?? false) && ((code ?? 0) >= 200 && (code ?? 0) < 300);
}
