import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FcmService {
  FcmService(this._messaging);

  final FirebaseMessaging _messaging;

  Future<String?> getToken() {
    return _messaging.getToken();
  }

  Stream<String> get onTokenRefresh {
    return _messaging.onTokenRefresh;
  }
    Stream<RemoteMessage> get onMessage {
    return FirebaseMessaging.onMessage;
  }
}
