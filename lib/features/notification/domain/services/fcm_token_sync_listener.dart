import 'dart:async';

import 'package:flower_app/features/auth/core/auth_status.dart';
import 'package:flower_app/features/notification/domain/repo/notification_repo.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FcmTokenSyncListener {
  FcmTokenSyncListener(this._authStatus, this._notificationRepo);

  final AuthStatus _authStatus;
  final NotificationRepo _notificationRepo;

  StreamSubscription<bool>? _authSubscription;
  StreamSubscription<String>? _tokenSubscription;

  void start() {
    if (_authSubscription != null) return;

    _authSubscription = _authStatus.authStatusStream.listen((isAuthenticated) {
      if (isAuthenticated) {
        _startTokenListening();
      } else {
        unawaited(_stopTokenListening());
      }
    });
  }

  void _startTokenListening() {
    if (_tokenSubscription != null) return;

    _tokenSubscription = _notificationRepo.fcmTokenRefreshStream.listen((
      newToken,
    ) {
      unawaited(_notificationRepo.syncFcmToken(token: newToken));
    });
  }

  Future<void> _stopTokenListening() async {
    await _tokenSubscription?.cancel();
    _tokenSubscription = null;
  }

  Future<void> stop() async {
    await _authSubscription?.cancel();
    _authSubscription = null;

    await _stopTokenListening();
  }
}
