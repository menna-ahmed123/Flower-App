import 'package:json_annotation/json_annotation.dart';

part 'session_item_response.g.dart';

@JsonSerializable()
class SessionItemResponse {
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "deviceName")
  final String? deviceName;
  @JsonKey(name: "lastActiveAt")
  final String? lastActiveAt;
  @JsonKey(name: "approximateLocationOrIp")
  final String? approximateLocationOrIp;
  @JsonKey(name: "expiresAt")
  final String? expiresAt;

  SessionItemResponse({
    this.id,
    this.deviceName,
    this.lastActiveAt,
    this.approximateLocationOrIp,
    this.expiresAt,
  });

  factory SessionItemResponse.fromJson(Map<String, dynamic> json) {
    return _$SessionItemResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SessionItemResponseToJson(this);
  }
}