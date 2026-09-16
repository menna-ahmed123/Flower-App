import 'package:flower_app/core/network/token_refresh_coordinator.dart';
import 'package:flower_app/core/network/token_refresh_scheduler.dart';
import 'package:flower_app/core/network/token_refresher.dart';

import 'fake_token_storage.dart';

/// No-op [TokenRefreshScheduler] for widget/unit tests that need an
/// [AuthCubit] but don't care about proactive token refresh.
///
/// [start] and [stop] are overridden to do nothing, so tests never touch
/// real storage, timers, or [WidgetsBinding].
class NoopTokenRefreshScheduler extends TokenRefreshScheduler {
  NoopTokenRefreshScheduler()
      : super(
    FakeTokenStorage(),
    TokenRefreshCoordinator(FakeTokenStorage(), _NoopTokenRefresher()),
  );

  @override
  Future<void> start() async {}

  @override
  void stop() {}
}

class _NoopTokenRefresher implements TokenRefresher {
  @override
  Future<AuthTokens?> refresh(String refreshToken) async => null;
}