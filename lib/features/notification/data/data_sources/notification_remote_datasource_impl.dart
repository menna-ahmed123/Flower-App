import 'package:flower_app/features/notification/api/notification_api_client.dart';
import 'package:flower_app/features/notification/data/data_sources/notification_remote_data_source.dart';
import 'package:flower_app/features/notification/data/models/update_fcm_token_request.dart';
import 'package:flower_app/features/notification/data/models/update_notification_status_request.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: NotificationRemoteDataSource)
class NotificationRemoteDatasourceImpl implements NotificationRemoteDataSource {
  NotificationRemoteDatasourceImpl(this._apiClient);

  final NotificationApiClient _apiClient;

  @override
  Future<void> updateFcmToken(UpdateFcmTokenRequest request) {
    return _apiClient.updateFcmToken(request);
  }

  @override
  Future<void> updateNotificationStatus(
    String deviceId,
    UpdateNotificationStatusRequest request,
  ) {
    return _apiClient.updateNotificationStatus(deviceId, request);
  }
}
