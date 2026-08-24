import 'package:flower_app/core/auth/presentation/view_model/auth_cubit.dart';
import 'package:flower_app/core/auth/presentation/view_model/auth_event.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../features/auth/login/data/repo/auth_repo_impl_test.mocks.dart';

void main() {
  group('AuthCubit', () {
    late MockTokenStorage tokenStorage;
    late AuthCubit authCubit;

    setUp(() {
      tokenStorage = MockTokenStorage();
      authCubit = AuthCubit(tokenStorage);
    });

    test('should emit authenticated when access token exists', () async {
      when(tokenStorage.getAccessToken()).thenAnswer((_) async => 'fake-token');

      await authCubit.doEvent(const AuthCheckRequested());

      expect(authCubit.state.authState.data, true);
    });

    test(
      'should emit unauthenticated when access token does not exist',
      () async {
        when(tokenStorage.getAccessToken()).thenAnswer((_) async => null);

        await authCubit.doEvent(const AuthCheckRequested());

        expect(authCubit.state.authState.data, false);
      },
    );

    test('should emit unauthenticated when access token is empty', () async {
      when(tokenStorage.getAccessToken()).thenAnswer((_) async => '');

      await authCubit.doEvent(const AuthCheckRequested());

      expect(authCubit.state.authState.data, false);
    });

    test('should clear token when logout is requested', () async {
      when(tokenStorage.clearTokens()).thenAnswer((_) async {});

      await authCubit.doEvent(const AuthLogoutRequested());

      verify(tokenStorage.clearTokens()).called(1);
    });

    test('should emit unauthenticated when logout is requested', () async {
      when(tokenStorage.clearTokens()).thenAnswer((_) async {});

      await authCubit.doEvent(const AuthLogoutRequested());

      expect(authCubit.state.authState.data, false);
    });
  });
}
