import 'package:json_annotation/json_annotation.dart';
import 'package:flower_app/features/commerce/data/models/product_dto.dart';

part 'product_response.g.dart';

@JsonSerializable()
class ProductsResponse {
  final ProductsDataDto data;
  final int statusCode;
  final bool success;
  final String message;
  final String messageLocalized;

  const ProductsResponse({
    required this.data,
    required this.statusCode,
    required this.success,
    required this.message,
    required this.messageLocalized,
  });

  factory ProductsResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductsResponseToJson(this);
}

@JsonSerializable()
class ProductsDataDto {
  final int page;
  final int pageSize;
  final int totalCount;
  final List<ProductDto> items;

  const ProductsDataDto({
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.items,
  });

  factory ProductsDataDto.fromJson(Map<String, dynamic> json) =>
      _$ProductsDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductsDataDtoToJson(this);
}
