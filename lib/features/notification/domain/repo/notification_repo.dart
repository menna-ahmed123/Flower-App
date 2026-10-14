import 'package:flower_app/core/base/base_response.dart';

abstract interface class NotificationRepo {
  Future<String> getDeviceId();

  Future<String?> getFcmToken();

  Future<BaseResponse<void>> updateFcmToken({
    required String deviceId,
    required String fcmToken,
  });
}
