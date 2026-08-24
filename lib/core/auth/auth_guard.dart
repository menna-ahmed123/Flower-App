import 'package:flower_app/core/network/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'presentation/view/auth_bottom_sheet.dart';

typedef PendingAction = Future<void> Function();

@lazySingleton
class AuthGuard {
  AuthGuard(this._tokenStorage);

  final TokenStorage _tokenStorage;

  PendingAction? _pendingAction;

  Future<bool> isAuthenticated() async {
    final token = await _tokenStorage.getAccessToken();

    return token != null && token.isNotEmpty;
  }

  Future<bool> requireAuth(
    BuildContext context, {
    PendingAction? pendingAction,
  }) async {
    if (await isAuthenticated()) {
      return true;
    }

    _pendingAction = pendingAction;

    if (!context.mounted) {
      return false;
    }

    await showLoginBottomSheet(context);

    return false;
  }

  Future<bool> replayPendingAction() async {
    final action = _pendingAction;
    _pendingAction = null;

    if (action == null) {
      return false;
    }

    await action();
    return true;
  }

  void clearPendingAction() {
    _pendingAction = null;
  }
}
