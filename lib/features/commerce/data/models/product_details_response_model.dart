import 'package:json_annotation/json_annotation.dart';

import 'product_details_model.dart';

part 'product_details_response_model.g.dart';

@JsonSerializable()
class ProductDetailsResponseModel {
  @JsonKey(name: 'data')
  final ProductDetailsModel? data;

  @JsonKey(name: 'statusCode')
  final int? statusCode;

  @JsonKey(name: 'success')
  final bool? success;

  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'messageLocalized')
  final String? messageLocalized;

  const ProductDetailsResponseModel({
    this.data,
    this.statusCode,
    this.success,
    this.message,
    this.messageLocalized,
  });

  factory ProductDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return _$ProductDetailsResponseModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ProductDetailsResponseModelToJson(this);
  }
}
