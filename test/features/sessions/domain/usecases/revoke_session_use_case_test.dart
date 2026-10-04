import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/sessions/domain/repo/session_repo.dart';
import 'package:flower_app/features/sessions/domain/usecases/revoke_session_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'revoke_session_use_case_test.mocks.dart';

@GenerateMocks([SessionRepo])
void main() {
  provideDummy<BaseResponse<bool>>(
    const SuccessResponse<bool>(false),
  );
  late MockSessionRepo sessionRepo;
  late RevokeSessionUseCase revokeSessionUseCase;

  setUp(() {
    sessionRepo = MockSessionRepo();
    revokeSessionUseCase = RevokeSessionUseCase(sessionRepo);
  });

  group('RevokeSessionUseCase', () {
    test('should revoke session successfully', () async {
      const sessionId = '1';

      const response = SuccessResponse<bool>(true);

      when(
        sessionRepo.revokeSession(sessionId: sessionId),
      ).thenAnswer(
            (_) async => response,
      );

      final result = await revokeSessionUseCase(
        sessionId: sessionId,
      );

      expect(result, response);

      verify(
        sessionRepo.revokeSession(sessionId: sessionId),
      ).called(1);
    });

    test('should return error response when revoke fails', () async {
      const sessionId = '1';

      final appError = BadResponseError('Failed to revoke session');

      final response = ErrorResponse<bool>(
        appError: appError,
      );

      when(
        sessionRepo.revokeSession(sessionId: sessionId),
      ).thenAnswer(
            (_) async => response,
      );

      final result = await revokeSessionUseCase(
        sessionId: sessionId,
      );

      expect(result, response);

      expect(
        (result as ErrorResponse<bool>).errorMessage,
        'Failed to revoke session',
      );

      verify(
        sessionRepo.revokeSession(sessionId: sessionId),
      ).called(1);
    });
  });
}