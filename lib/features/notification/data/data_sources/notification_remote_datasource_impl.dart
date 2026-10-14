import 'package:flower_app/features/notification/api/notification_api_client.dart';
import 'package:flower_app/features/notification/data/data_sources/notification_remote_data_source.dart';
import 'package:flower_app/features/notification/data/models/update_fcm_token_request.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: NotificationRemoteDataSource)
class NotificationRemoteDatasourceImpl implements NotificationRemoteDataSource {
  final NotificationApiClient _apiClient;

  NotificationRemoteDatasourceImpl(this._apiClient);

  @override
  Future<void> updateFcmToken(UpdateFcmTokenRequest request) {
    return _apiClient.updateFcmToken(request);
  }
}
