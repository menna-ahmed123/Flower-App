import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:flower_app/core/services/fcm_service.dart';
import 'package:flower_app/features/notification/domain/use_cases/sync_fcm_token_use_case.dart';

@lazySingleton
class FcmTokenSyncListener {
  FcmTokenSyncListener(this._fcmService, this._syncFcmTokenUseCase);

  final FcmService _fcmService;
  final SyncFcmTokenUseCase _syncFcmTokenUseCase;

  StreamSubscription<String>? _subscription;

  void start() {
    if (_subscription != null) return;

    _subscription = _fcmService.onTokenRefresh.listen((newToken) {
      _syncFcmTokenUseCase(token: newToken);
    });
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}
