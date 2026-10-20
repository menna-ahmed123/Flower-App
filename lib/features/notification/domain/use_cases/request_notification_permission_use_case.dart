import 'package:flower_app/core/enums/notification_permission_status.dart';
import 'package:injectable/injectable.dart';
import 'package:flower_app/core/services/notification_permission_service.dart';

@injectable
class RequestNotificationPermissionUseCase {
  RequestNotificationPermissionUseCase(this._notificationPermissionService);

  final NotificationPermissionService _notificationPermissionService;

  Future<NotificationPermissionStatus> call() {
    return _notificationPermissionService.requestPermission();
  }
}
