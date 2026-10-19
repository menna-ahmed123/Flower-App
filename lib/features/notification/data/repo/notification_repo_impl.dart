import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/core/services/device_id_service.dart';
import 'package:flower_app/core/services/fcm_service.dart';
import 'package:flower_app/core/services/fcm_token_storage.dart';
import 'package:flower_app/features/notification/data/data_sources/notification_remote_data_source.dart';
import 'package:flower_app/features/notification/data/models/update_fcm_token_request.dart';
import 'package:flower_app/features/notification/data/models/update_notification_status_request.dart';
import 'package:flower_app/core/enums/notification_permission_status.dart';
import 'package:flower_app/core/services/notification_permission_service.dart';
import 'package:flower_app/features/notification/domain/repo/notification_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: NotificationRepo)
class NotificationRepoImpl implements NotificationRepo {
  NotificationRepoImpl(
    this._deviceIdService,
    this._fcmService,
    this._remoteDataSource,
    this._safeCall,
    this._fcmTokenStorage,
    this._notificationPermissionService,
  );

  final DeviceIdService _deviceIdService;
  final FcmService _fcmService;
  final NotificationRemoteDataSource _remoteDataSource;
  final SafeCall _safeCall;
  final FcmTokenStorage _fcmTokenStorage;
  final NotificationPermissionService _notificationPermissionService;

  @override
  Stream<String> get fcmTokenRefreshStream {
    return _fcmService.onTokenRefresh;
  }

  @override
  Future<BaseResponse<void>> updateFcmToken({
    required String deviceId,
    required String fcmToken,
  }) async {
    final request = UpdateFcmTokenRequest(
      deviceId: deviceId,
      fcmToken: fcmToken,
    );

    return _safeCall.safeApiCall<void>(
      () => _remoteDataSource.updateFcmToken(request),
    );
  }

  @override
  Future<BaseResponse<void>> syncFcmToken({
    String? token,
  }) async {
    final fcmToken = token ?? await _fcmService.getToken();

    if (fcmToken == null || fcmToken.isEmpty) {
      return ErrorResponse<void>(
        appError: BadResponseError('FCM token is unavailable.'),
      );
    }

    final lastSyncedToken =
        await _fcmTokenStorage.getLastSyncedToken();

    if (fcmToken == lastSyncedToken) {
      return SuccessResponse<void>(null);
    }

    final deviceId = await _deviceIdService.getDeviceId();

    final result = await _safeCall.safeApiCall<void>(
      () => _remoteDataSource.updateFcmToken(
        UpdateFcmTokenRequest(
          deviceId: deviceId,
          fcmToken: fcmToken,
        ),
      ),
    );

    if (result is SuccessResponse<void>) {
      await _fcmTokenStorage.saveLastSyncedToken(fcmToken);
    }

    return result;
  }

  @override
  Future<BaseResponse<void>> updateNotificationStatus({
    required bool enabled,
  }) async {
    final deviceId = await _deviceIdService.getDeviceId();

    final request = UpdateNotificationStatusRequest(
      enabled: enabled,
    );

    return _safeCall.safeApiCall<void>(
      () => _remoteDataSource.updateNotificationStatus(
        deviceId,
        request,
      ),
    );
  }

  @override
  Future<NotificationPermissionStatus> handlePermission() async {
    final status = await _notificationPermissionService.getPermissionStatus();
    if (status == NotificationPermissionStatus.notDetermined) {
      await _notificationPermissionService.requestPermission();
      return status;
    }
    return status;
  }
}

