import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/core/services/fcm_service.dart';
import 'package:flower_app/core/services/device_id_service.dart';
import 'package:flower_app/features/notification/data/data_sources/notification_remote_data_source.dart';
import 'package:flower_app/features/notification/data/models/update_fcm_token_request.dart';
import 'package:flower_app/features/notification/domain/repo/notification_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: NotificationRepo)
class NotificationRepoImpl implements NotificationRepo {
  NotificationRepoImpl(
    this._deviceIdService,
    this._fcmService,
    this._remoteDataSource,
    this._safeCall,
  );

  final DeviceIdService _deviceIdService;
  final FcmService _fcmService;
  final NotificationRemoteDataSource _remoteDataSource;
  final SafeCall _safeCall;

  @override
  Future<String> getDeviceId() {
    return _deviceIdService.getDeviceId();
  }

  @override
  Future<String?> getFcmToken() {
    return _fcmService.getToken();
  }

  @override
  Future<BaseResponse<void>> updateFcmToken({
    required String deviceId,
    required String fcmToken,
  }) {
    final request = UpdateFcmTokenRequest(
      deviceId: deviceId,
      fcmToken: fcmToken,
    );

    return _safeCall.safeApiCall<void>(
      () => _remoteDataSource.updateFcmToken(request),
    );
  }
}
