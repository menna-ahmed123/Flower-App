import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/notification/domain/repo/notification_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateNotificationStatusUseCase {
  UpdateNotificationStatusUseCase(this._notificationRepo);

  final NotificationRepo _notificationRepo;

  Future<BaseResponse<void>> call({
    required bool enabled,
  }) {
    return _notificationRepo.updateNotificationStatus(
      enabled: enabled,
    );
  }
}
