import 'package:flower_app/core/enums/notification_permission_status.dart';
import 'package:flower_app/features/notification/domain/repo/notification_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class HandleNotificationPermissionUseCase {
  HandleNotificationPermissionUseCase(this._notificationRepo);

  final NotificationRepo _notificationRepo;

  Future<NotificationPermissionStatus> call() {
    return _notificationRepo.handlePermission();
  }
}
