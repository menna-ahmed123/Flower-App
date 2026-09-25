import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/sessions/domain/entities/session_entity.dart';
import 'package:flower_app/features/sessions/domain/usecases/get_sessions_use_case.dart';
import 'package:flower_app/features/sessions/domain/usecases/revoke_session_use_case.dart';
import 'package:flower_app/features/sessions/presentation/view_model/session_event.dart';
import 'package:flower_app/features/sessions/presentation/view_model/session_state.dart';
import 'package:flower_app/features/sessions/presentation/view_model/session_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'session_view_model_test.mocks.dart';

@GenerateMocks([
  GetSessionsUseCase,
  RevokeSessionUseCase,
])
void main() {
  provideDummy<BaseResponse<List<SessionEntity>>>(
    const SuccessResponse<List<SessionEntity>>([]),
  );

  provideDummy<BaseResponse<bool>>(
    const SuccessResponse<bool>(true),
  );

  late MockGetSessionsUseCase getSessionsUseCase;
  late MockRevokeSessionUseCase revokeSessionUseCase;
  late SessionsViewModel sessionsViewModel;

  setUp(() {
    getSessionsUseCase = MockGetSessionsUseCase();
    revokeSessionUseCase = MockRevokeSessionUseCase();

    sessionsViewModel = SessionsViewModel(
      getSessionsUseCase,
      revokeSessionUseCase,
    );
  });

  tearDown(() async {
    await sessionsViewModel.close();
  });

  final sessions = [
    SessionEntity(
      id: '1',
      deviceName: 'Chrome',
      lastActiveAt: '2026-09-24T10:00:00Z',
      approximateLocationOrIp: '192.168.1.1',
      expiresAt: '2026-10-24T10:00:00Z',
    ),
    SessionEntity(
      id: '2',
      deviceName: 'Android',
      lastActiveAt: '2026-09-24T11:00:00Z',
      approximateLocationOrIp: '192.168.1.2',
      expiresAt: '2026-10-24T11:00:00Z',
    ),
  ];

  group('LoadSessions', () {
    test('should load sessions successfully', () async {
      // Arrange
      when(getSessionsUseCase.call()).thenAnswer(
            (_) async => SuccessResponse<List<SessionEntity>>(
          sessions,
        ),
      );

      final future = expectLater(
        sessionsViewModel.stream,
        emitsInOrder([
          // Loading
          isA<SessionsState>().having(
                (state) => state.sessionsState.isLoading,
            'isLoading',
            true,
          ),

          // Success
          isA<SessionsState>()
              .having(
                (state) => state.sessionsState.isLoading,
            'isLoading',
            false,
          )
              .having(
                (state) => state.sessionsState.data,
            'sessions',
            sessions,
          )
              .having(
                (state) => state.sessionsState.errorMessage,
            'errorMessage',
            isEmpty,
          ),
        ]),
      );

      // Act
      await sessionsViewModel.onEvent(LoadSessions());

      await future;

      // Assert
      verify(getSessionsUseCase.call()).called(1);
    });

    test('should emit error when loading sessions fails', () async {
      // Arrange
      const errorMessage = 'Failed to load sessions';

      when(getSessionsUseCase.call()).thenAnswer(
            (_) async => ErrorResponse<List<SessionEntity>>(
          appError: BadResponseError(errorMessage),
        ),
      );

      final future = expectLater(
        sessionsViewModel.stream,
        emitsInOrder([
          // Loading
          isA<SessionsState>().having(
                (state) => state.sessionsState.isLoading,
            'isLoading',
            true,
          ),

          // Error
          isA<SessionsState>()
              .having(
                (state) => state.sessionsState.isLoading,
            'isLoading',
            false,
          )
              .having(
                (state) => state.sessionsState.errorMessage,
            'errorMessage',
            errorMessage,
          ),
        ]),
      );

      // Act
      await sessionsViewModel.onEvent(LoadSessions());

      await future;

      // Assert
      verify(getSessionsUseCase.call()).called(1);
    });
  });

  group('RevokeSession', () {
    test('should revoke session and remove it from the list', () async {
      // Arrange
      const sessionId = '1';

      when(getSessionsUseCase.call()).thenAnswer(
            (_) async => SuccessResponse<List<SessionEntity>>(
          sessions,
        ),
      );

      when(
        revokeSessionUseCase.call(
          sessionId: sessionId,
        ),
      ).thenAnswer(
            (_) async => const SuccessResponse<bool>(true),
      );

      await sessionsViewModel.onEvent(LoadSessions());

      final future = expectLater(
        sessionsViewModel.stream,
        emitsInOrder([
          // Revoking
          isA<SessionsState>().having(
                (state) => state.revokingSessionId,
            'revokingSessionId',
            sessionId,
          ),

          // Success
          isA<SessionsState>()
              .having(
                (state) => state.revokingSessionId,
            'revokingSessionId',
            isNull,
          )
              .having(
                (state) => state.sessionsState.data,
            'sessions',
            [sessions[1]],
          ),
        ]),
      );

      // Act
      await sessionsViewModel.onEvent(
        RevokeSession(sessionId),
      );

      await future;

      // Assert
      verify(
        revokeSessionUseCase.call(
          sessionId: sessionId,
        ),
      ).called(1);
    });

    test('should keep sessions and emit error when revoke fails', () async {
      const sessionId = '1';
      const errorMessage = 'Failed to revoke session';

      when(getSessionsUseCase.call()).thenAnswer(
            (_) async => SuccessResponse<List<SessionEntity>>(sessions),
      );

      when(
        revokeSessionUseCase.call(sessionId: sessionId),
      ).thenAnswer(
            (_) async => ErrorResponse<bool>(
          appError: BadResponseError(errorMessage),
        ),
      );

      await sessionsViewModel.onEvent(LoadSessions());

      final future = expectLater(
        sessionsViewModel.stream,
        emitsInOrder([
          isA<SessionsState>().having(
                (state) => state.revokingSessionId,
            'revokingSessionId',
            sessionId,
          ),
          isA<SessionsState>()
              .having(
                (state) => state.revokingSessionId,
            'revokingSessionId',
            isNull,
          )
              .having(
                (state) => state.sessionsState.errorMessage,
            'errorMessage',
            errorMessage,
          )
              .having(
                (state) => state.sessionsState.data,
            'sessions',
            sessions,
          ),
        ]),
      );

      await sessionsViewModel.onEvent(RevokeSession(sessionId));
      await future;

      verify(
        revokeSessionUseCase.call(sessionId: sessionId),
      ).called(1);
    });
  });
}