import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/notification/domain/repo/notification_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateFcmTokenUseCase {
  UpdateFcmTokenUseCase(this._notificationRepo);

  final NotificationRepo _notificationRepo;

  Future<BaseResponse<void>> call({
    required String deviceId,
    required String fcmToken,
  }) {
    return _notificationRepo.updateFcmToken(
      deviceId: deviceId,
      fcmToken: fcmToken,
    );
  }
}
