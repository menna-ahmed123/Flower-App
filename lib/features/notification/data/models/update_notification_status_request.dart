import 'package:json_annotation/json_annotation.dart';

part 'update_notification_status_request.g.dart';

@JsonSerializable()
class UpdateNotificationStatusRequest {
  final bool enabled;

  const UpdateNotificationStatusRequest({required this.enabled});

  factory UpdateNotificationStatusRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateNotificationStatusRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UpdateNotificationStatusRequestToJson(this);
}
