import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/notification/domain/repo/notification_repo.dart';
import 'package:flower_app/features/notification/domain/use_cases/get_device_id_use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateNotificationStatusUseCase {
  UpdateNotificationStatusUseCase(
    this._getDeviceIdUseCase,
    this._notificationRepo,
  );

  final GetDeviceIdUseCase _getDeviceIdUseCase;
  final NotificationRepo _notificationRepo;

  Future<BaseResponse<void>> call({required bool enabled}) async {
    final deviceId = await _getDeviceIdUseCase();

    return _notificationRepo.updateNotificationStatus(
      deviceId: deviceId,
      enabled: enabled,
    );
  }
}
