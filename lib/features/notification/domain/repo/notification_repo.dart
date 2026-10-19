import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/enums/notification_permission_status.dart';

abstract interface class NotificationRepo {
  Stream<String> get fcmTokenRefreshStream;

  Future<NotificationPermissionStatus> handlePermission();

  Future<BaseResponse<void>> updateFcmToken({
    required String deviceId,
    required String fcmToken,
  });

  Future<BaseResponse<void>> syncFcmToken({
    String? token,
  });

  Future<BaseResponse<void>> updateNotificationStatus({
    required bool enabled,
  });
}
