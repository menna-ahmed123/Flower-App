import 'package:json_annotation/json_annotation.dart';

import 'categories_response.dart' show Pagination;
import 'product_dto.dart';

part 'product_response.g.dart';

/// Response wrapper for GET /api/catalog/products (new API format).
/// data is now a flat List (not a paginated object), pagination is top-level.
/// { status, code, message, data: [...], pagination, errors }
@JsonSerializable()
class ProductsResponse {
  const ProductsResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
    this.pagination,
    this.errors,
  });

  @JsonKey(name: 'status', defaultValue: true)
  final bool status;

  @JsonKey(name: 'code', defaultValue: 200)
  final int code;

  @JsonKey(name: 'message', defaultValue: '')
  final String message;

  @JsonKey(name: 'data', defaultValue: [])
  final List<ProductDto> data;

  @JsonKey(name: 'pagination')
  final Pagination? pagination;

  @JsonKey(name: 'errors')
  final dynamic errors;

  factory ProductsResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductsResponseToJson(this);

  bool get isSuccess => status && (code >= 200 && code < 300);
}
