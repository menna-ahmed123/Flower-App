import 'package:flower_app/core/auth/data/repos/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../features/auth/login/data/repo/auth_repo_impl_test.mocks.dart';

void main() {
  late MockTokenStorage tokenStorage;
  late AuthRepositoryImpl authRepository;

  setUp(() {
    tokenStorage = MockTokenStorage();
    authRepository = AuthRepositoryImpl(tokenStorage);
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
}
