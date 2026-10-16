import 'package:injectable/injectable.dart';
import 'package:flower_app/core/services/notification_permission_service.dart';

@injectable
class RequestNotificationPermissionUseCase {
  RequestNotificationPermissionUseCase(this._notificationPermissionService);

  final NotificationPermissionService _notificationPermissionService;

  Future<bool> call() {
    return _notificationPermissionService.requestPermission();
  }
}
