import 'package:flower_app/features/sessions/data/models/response/session_item_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'session_response.g.dart';

@JsonSerializable()
class SessionResponse {
  @JsonKey(name: "data")
  final List<SessionItemResponse>? data;
  @JsonKey(name: "statusCode")
  final int? statusCode;
  @JsonKey(name: "success")
  final bool? success;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "messageLocalized")
  final String? messageLocalized;

  SessionResponse({
    this.data,
    this.statusCode,
    this.success,
    this.message,
    this.messageLocalized,
  });

  factory SessionResponse.fromJson(Map<String, dynamic> json) {
    return _$SessionResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SessionResponseToJson(this);
  }
}