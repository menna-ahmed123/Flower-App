import 'package:flower_app/core/auth/domain/repos/auth_repository.dart';
import 'package:flower_app/core/auth/presentation/view_model/auth_cubit.dart';
import 'package:flower_app/core/auth/presentation/view_model/auth_event.dart';
import 'package:flower_app/core/auth/presentation/view_model/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_cubit_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository authRepository;
  late AuthCubit authCubit;

  setUp(() {
    authRepository = MockAuthRepository();
    authCubit = AuthCubit(authRepository);
  });

  tearDown(() async {
    await authCubit.close();
  });

  group('AuthCheckRequested', () {
    test('should emit authenticated when user is authenticated', () async {
      when(
        authRepository.isAuthenticated(),
      ).thenAnswer((_) async => true);

      await authCubit.doEvent(
        const AuthCheckRequested(),
      );

      expect(authCubit.state.isAuthenticated, true);
      verify(authRepository.isAuthenticated()).called(1);
    });

    test('should emit unauthenticated when user is not authenticated',
            () async {
          when(
            authRepository.isAuthenticated(),
          ).thenAnswer((_) async => false);

          await authCubit.doEvent(
            const AuthCheckRequested(),
          );

          expect(authCubit.state.isAuthenticated, false);
          verify(authRepository.isAuthenticated()).called(1);
        });
  });

  group('AuthGuestRequested', () {
    test('should continue as guest', () async {
      await authCubit.doEvent(
        const AuthGuestRequested(),
      );

      expect(authCubit.state.isAuthenticated, false);
    });
  });

  group('AuthLogoutRequested', () {
    test('should logout and emit unauthenticated', () async {
      when(
        authRepository.logout(),
      ).thenAnswer((_) async {
        return null;
      });

      await authCubit.doEvent(
        const AuthLogoutRequested(),
      );

      verify(authRepository.logout()).called(1);
      expect(authCubit.state.isAuthenticated, false);
      expect(authCubit.state.requiresAuthentication, false);
    });
  });

  group('AuthAuthenticationRequired', () {
    test('should require authentication and store pending action', () async {
      var actionExecuted = false;

      Future<void> pendingAction() async {
        actionExecuted = true;
      }

      await authCubit.doEvent(
        AuthAuthenticationRequired(
          pendingAction: pendingAction,
        ),
      );

      expect(authCubit.state.requiresAuthentication, true);
      expect(actionExecuted, false);
    });

    test('should require authentication without pending action', () async {
      await authCubit.doEvent(
        const AuthAuthenticationRequired(),
      );

      expect(authCubit.state.requiresAuthentication, true);
    });
  });

  group('AuthLoginSucceeded', () {
    test('should authenticate and replay pending action after login',
            () async {
          when(
            authRepository.isAuthenticated(),
          ).thenAnswer((_) async => true);

          var actionExecuted = false;

          Future<void> pendingAction() async {
            actionExecuted = true;
          }

          await authCubit.doEvent(
            AuthAuthenticationRequired(
              pendingAction: pendingAction,
            ),
          );

          await authCubit.doEvent(
            const AuthLoginSucceeded(),
          );

          expect(authCubit.state.isAuthenticated, true);
          expect(authCubit.state.requiresAuthentication, false);
          expect(actionExecuted, true);

          verify(authRepository.isAuthenticated()).called(1);
        });

    test('should not replay pending action when authentication fails',
            () async {
          when(
            authRepository.isAuthenticated(),
          ).thenAnswer((_) async => false);

          var actionExecuted = false;

          Future<void> pendingAction() async {
            actionExecuted = true;
          }

          await authCubit.doEvent(
            AuthAuthenticationRequired(
              pendingAction: pendingAction,
            ),
          );

          await authCubit.doEvent(
            const AuthLoginSucceeded(),
          );

          expect(authCubit.state.isAuthenticated, false);
          expect(authCubit.state.requiresAuthentication, true);
          expect(actionExecuted, false);

          verify(authRepository.isAuthenticated()).called(1);
        });
  });

  group('replayPendingAction', () {
    test('should execute pending action', () async {
      var actionExecuted = false;

      Future<void> pendingAction() async {
        actionExecuted = true;
      }

      await authCubit.doEvent(
        AuthAuthenticationRequired(
          pendingAction: pendingAction,
        ),
      );

      await authCubit.replayPendingAction();

      expect(actionExecuted, true);
    });

    test('should clear pending action after replay', () async {
      var executionCount = 0;

      Future<void> pendingAction() async {
        executionCount++;
      }

      await authCubit.doEvent(
        AuthAuthenticationRequired(
          pendingAction: pendingAction,
        ),
      );

      await authCubit.replayPendingAction();
      await authCubit.replayPendingAction();

      expect(executionCount, 1);
    });

    test('should do nothing when there is no pending action', () async {
      await authCubit.replayPendingAction();

      expect(authCubit.state.isAuthenticated, false);
    });
  });

  group('clearPendingAction', () {
    test('should prevent pending action from being replayed', () async {
      var actionExecuted = false;

      Future<void> pendingAction() async {
        actionExecuted = true;
      }

      await authCubit.doEvent(
        AuthAuthenticationRequired(
          pendingAction: pendingAction,
        ),
      );

      authCubit.clearPendingAction();

      await authCubit.replayPendingAction();

      expect(actionExecuted, false);
    });
  });
}