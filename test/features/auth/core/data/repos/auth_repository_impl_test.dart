import 'package:flower_app/core/network/token_refresh_coordinator.dart';
import 'package:flower_app/core/network/token_refresh_scheduler.dart';
import 'package:flower_app/core/network/token_refresher.dart';
import 'package:flower_app/features/auth/core/data/repos/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../features/auth/login/data/repo/auth_repo_impl_test.mocks.dart';

/// Fake scheduler that records calls instead of touching real timers or
/// [WidgetsBinding] — we only need to verify [AuthRepositoryImpl]
/// delegates to it correctly, not exercise the scheduler's own logic
/// (that's covered separately).
class _FakeTokenRefreshScheduler extends TokenRefreshScheduler {
  _FakeTokenRefreshScheduler(super.tokenStorage, super.coordinator);

  int startCount = 0;
  int stopCount = 0;

  @override
  Future<void> start() async {
    startCount++;
  }

  @override
  void stop() {
    stopCount++;
  }
}

class _FakeTokenRefresher implements TokenRefresher {
  @override
  Future<AuthTokens?> refresh(String refreshToken) async => null;
}

void main() {
  late MockTokenStorage tokenStorage;
  late _FakeTokenRefreshScheduler scheduler;
  late TokenRefreshCoordinator coordinator;
  late AuthRepositoryImpl authRepository;

  setUp(() {
    tokenStorage = MockTokenStorage();
    coordinator = TokenRefreshCoordinator(tokenStorage, _FakeTokenRefresher());
    scheduler = _FakeTokenRefreshScheduler(tokenStorage, coordinator);
    authRepository = AuthRepositoryImpl(tokenStorage, scheduler, coordinator);
  });

  group('isAuthenticated', () {
    test('should return true when access token exists', () async {
      when(tokenStorage.getAccessToken()).thenAnswer((_) async => 'fake-token');

      final result = await authRepository.isAuthenticated();

      expect(result, true);
      verify(tokenStorage.getAccessToken()).called(1);
    });

    test('should return false when access token does not exist', () async {
      when(tokenStorage.getAccessToken()).thenAnswer((_) async => null);

      final result = await authRepository.isAuthenticated();

      expect(result, false);
      verify(tokenStorage.getAccessToken()).called(1);
    });

    test('should return false when access token is empty', () async {
      when(tokenStorage.getAccessToken()).thenAnswer((_) async => '');

      final result = await authRepository.isAuthenticated();

      expect(result, false);
      verify(tokenStorage.getAccessToken()).called(1);
    });
  });

  group('logout', () {
    test('should clear tokens', () async {
      when(tokenStorage.clearTokens()).thenAnswer((_) async {});

      await authRepository.logout();

      verify(tokenStorage.clearTokens()).called(1);
    });
  });

  group('startSessionRefresh / stopSessionRefresh', () {
    test('delegates to the scheduler', () async {
      await authRepository.startSessionRefresh();
      authRepository.stopSessionRefresh();

      expect(scheduler.startCount, 1);
      expect(scheduler.stopCount, 1);
    });
  });

  group('sessionExpired', () {
    test('exposes the coordinator\'s stream as-is', () {
      expect(authRepository.sessionExpired, same(coordinator.sessionExpired));
    });
  });
}