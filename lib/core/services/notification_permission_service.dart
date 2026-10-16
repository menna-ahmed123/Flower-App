import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@lazySingleton
class NotificationPermissionService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission();

    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  Future<bool> isPermissionGranted() async {
    final settings = await _messaging.getNotificationSettings();

    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  Future<bool> openSettings() {
    return openAppSettings();
  }
}
