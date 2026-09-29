import 'package:json_annotation/json_annotation.dart';

import 'occasion_model.dart';
import 'categories_response.dart' show Pagination;

part 'occasions_response.g.dart';

/// Response wrapper for GET /api/catalog/occasions (new API format).
/// { status, code, message, data: [...], pagination, errors }
@JsonSerializable()
class OccasionsResponse {
  OccasionsResponse({
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
  final List<OccasionModel> data;

  @JsonKey(name: 'pagination')
  final Pagination? pagination;

  @JsonKey(name: 'errors')
  final dynamic errors;

  factory OccasionsResponse.fromJson(Map<String, dynamic> json) =>
      _$OccasionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OccasionsResponseToJson(this);

  bool get isSuccess => status && (code >= 200 && code < 300);
}
