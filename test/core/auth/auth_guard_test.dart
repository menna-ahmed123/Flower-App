import 'package:flower_app/core/auth/auth_guard.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../features/auth/login/data/repo/auth_repo_impl_test.mocks.dart';

void main() {
  late MockTokenStorage tokenStorage;
  late AuthGuard authGuard;

  setUp(() {
    tokenStorage = MockTokenStorage();
    authGuard = AuthGuard(tokenStorage);
  });

  group('isAuthenticated', () {
    test('should return true when access token exists', () async {
      when(tokenStorage.getAccessToken()).thenAnswer((_) async => 'fake-token');

      final result = await authGuard.isAuthenticated();

      expect(result, true);
    });

    test('should return false when access token is empty', () async {
      when(tokenStorage.getAccessToken()).thenAnswer((_) async => '');

      final result = await authGuard.isAuthenticated();

      expect(result, false);
    });

    test('should return false when access token is null', () async {
      when(tokenStorage.getAccessToken()).thenAnswer((_) async => null);

      final result = await authGuard.isAuthenticated();

      expect(result, false);
    });
  });

  group('replayPendingAction', () {
    test('should return false when there is no pending action', () async {
      final result = await authGuard.replayPendingAction();

      expect(result, false);
    });
  });
}
