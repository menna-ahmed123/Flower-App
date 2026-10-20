import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flower_app/core/services/fcm_service.dart';
import 'package:flower_app/core/services/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NotificationManager {
  NotificationManager(this._fcmService, this._localNotificationService);

  final FcmService _fcmService;
  final LocalNotificationService _localNotificationService;

  StreamSubscription<RemoteMessage>? _messageSubscription;

  Future<void> initialize() async {
    await _localNotificationService.initialize();

    _messageSubscription ??= _fcmService.onMessage.listen(
      _showForegroundNotification,
    );
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;

    final title = notification?.title;
    final body = notification?.body;

    if (title == null && body == null) return;

    await _localNotificationService.showNotification(
      title: title ?? '',
      body: body ?? '',
    );
  }

  Future<void> dispose() async {
    await _messageSubscription?.cancel();
    _messageSubscription = null;
  }
}
