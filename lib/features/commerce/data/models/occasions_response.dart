import 'package:json_annotation/json_annotation.dart';
import 'occasion_model.dart';

part 'occasions_response.g.dart';

@JsonSerializable()
class OccasionsResponse {
  final List<OccasionModel> data;
  final int statusCode;
  final bool success;
  final String message;
  final String messageLocalized;

  OccasionsResponse({
    required this.data,
    required this.statusCode,
    required this.success,
    required this.message,
    required this.messageLocalized,
  });

  factory OccasionsResponse.fromJson(Map<String, dynamic> json) =>
      _$OccasionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OccasionsResponseToJson(this);
}