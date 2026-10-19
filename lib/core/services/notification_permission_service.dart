
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flower_app/core/enums/notification_permission_status.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@lazySingleton
class NotificationPermissionService {
  NotificationPermissionService(this._messaging);

  final FirebaseMessaging _messaging;

  Future<NotificationPermissionStatus> requestPermission() async {
    final settings = await _messaging.requestPermission();

    return _mapPermissionStatus(settings.authorizationStatus);
  }

  Future<NotificationPermissionStatus> getPermissionStatus() async {
    final settings = await _messaging.getNotificationSettings();

    return _mapPermissionStatus(settings.authorizationStatus);
  }

  Future<bool> openSettings() {
    return openAppSettings();
  }

  NotificationPermissionStatus _mapPermissionStatus(
    AuthorizationStatus status,
  ) {
    switch (status) {
      case AuthorizationStatus.authorized:
      case AuthorizationStatus.provisional:
        return NotificationPermissionStatus.granted;

      case AuthorizationStatus.denied:
      case AuthorizationStatus.deniedPermanently:
        return NotificationPermissionStatus.denied;

      case AuthorizationStatus.notDetermined:
        return NotificationPermissionStatus.notDetermined;
    }
  }
}