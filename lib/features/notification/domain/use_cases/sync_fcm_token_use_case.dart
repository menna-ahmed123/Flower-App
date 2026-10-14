import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/core/services/fcm_token_storage.dart';
import 'package:flower_app/features/auth/login/domain/use_case/get_fcm_token_usecase.dart';
import 'package:flower_app/features/notification/domain/use_cases/get_device_id_use_case.dart';
import 'package:flower_app/features/notification/domain/use_cases/update_fcm_token_usecase.dart';
import 'package:injectable/injectable.dart';

@injectable
class SyncFcmTokenUseCase {
  SyncFcmTokenUseCase(
    this._getDeviceIdUseCase,
    this._getFcmTokenUseCase,
    this._updateFcmTokenUseCase,
    this._fcmTokenStorage,
  );

  final GetDeviceIdUseCase _getDeviceIdUseCase;
  final GetFcmTokenUseCase _getFcmTokenUseCase;
  final UpdateFcmTokenUseCase _updateFcmTokenUseCase;
  final FcmTokenStorage _fcmTokenStorage;

  Future<BaseResponse<void>> call({String? token}) async {
    final fcmToken = token ?? await _getFcmTokenUseCase();

    if (fcmToken == null || fcmToken.isEmpty) {
      return ErrorResponse<void>(
        appError: BadResponseError('FCM token is unavailable.'),
      );
    }

    final lastSyncedToken = await _fcmTokenStorage.getLastSyncedToken();

    if (fcmToken == lastSyncedToken) {
      return SuccessResponse<void>(null);
    }

    final deviceId = await _getDeviceIdUseCase();

    final result = await _updateFcmTokenUseCase(
      deviceId: deviceId,
      fcmToken: fcmToken,
    );

    if (result is SuccessResponse<void>) {
      await _fcmTokenStorage.saveLastSyncedToken(fcmToken);
    }

    return result;
  }
}
