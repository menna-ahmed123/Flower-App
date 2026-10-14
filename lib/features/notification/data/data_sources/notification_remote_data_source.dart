import 'package:flower_app/features/notification/data/models/update_fcm_token_request.dart';

abstract class NotificationRemoteDataSource {
  Future<void> updateFcmToken(UpdateFcmTokenRequest request);
}
