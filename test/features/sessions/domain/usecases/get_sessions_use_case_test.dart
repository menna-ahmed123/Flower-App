import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/sessions/domain/entities/session_entity.dart';
import 'package:flower_app/features/sessions/domain/repo/session_repo.dart';
import 'package:flower_app/features/sessions/domain/usecases/get_sessions_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_sessions_use_case_test.mocks.dart';

@GenerateMocks([SessionRepo])
void main() {
  provideDummy<BaseResponse<List<SessionEntity>>>(
    const SuccessResponse<List<SessionEntity>>([]),
  );
  late MockSessionRepo sessionRepo;
  late GetSessionsUseCase getSessionsUseCase;

  setUp(() {
    sessionRepo = MockSessionRepo();
    getSessionsUseCase = GetSessionsUseCase(sessionRepo);
  });

  group('GetSessionsUseCase', () {
    test('should return sessions from repository', () async {
      final sessions = [
        SessionEntity(
          id: '1',
          deviceName: 'Chrome',
          lastActiveAt: '2026-09-24T10:00:00Z',
        ),
      ];

      final response = SuccessResponse<List<SessionEntity>>(sessions);

      when(sessionRepo.getSessions()).thenAnswer(
            (_) async => response,
      );

      final result = await getSessionsUseCase();

      expect(result, response);

      verify(sessionRepo.getSessions()).called(1);
    });

    test('should return error response from repository', () async {
      final appError = BadResponseError('Failed to load sessions');

      final response = ErrorResponse<List<SessionEntity>>(
        appError: appError,
      );

      when(sessionRepo.getSessions()).thenAnswer(
            (_) async => response,
      );

      final result = await getSessionsUseCase();

      expect(result, response);

      expect(
        (result as ErrorResponse<List<SessionEntity>>).errorMessage,
        'Failed to load sessions',
      );

      verify(sessionRepo.getSessions()).called(1);
    });
  });
}