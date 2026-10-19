import 'package:flower_app/features/notification/data/models/update_fcm_token_request.dart';
import 'package:flower_app/features/notification/data/models/update_notification_status_request.dart';

abstract interface class NotificationRemoteDataSource {
  Future<void> updateFcmToken(UpdateFcmTokenRequest request);

  Future<void> updateNotificationStatus(
    String deviceId,
    UpdateNotificationStatusRequest request,
  );
}
