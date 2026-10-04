import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/sessions/data/data_sources/remote/session_remote_data_source.dart';
import 'package:flower_app/features/sessions/data/models/response/session_item_response.dart';
import 'package:flower_app/features/sessions/data/models/response/session_response.dart';
import 'package:flower_app/features/sessions/data/repo/session_repo_impl.dart';
import 'package:flower_app/features/sessions/domain/entities/session_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'session_repo_impl_test.mocks.dart';

@GenerateMocks([
  SessionRemoteDataSource,
  SafeCall,
])
void main() {
  provideDummy<BaseResponse<List<SessionEntity>>>(
    const SuccessResponse<List<SessionEntity>>([]),
  );

  provideDummy<BaseResponse<bool>>(
    const SuccessResponse<bool>(true),
  );

  late MockSessionRemoteDataSource dataSource;
  late MockSafeCall safeCall;
  late SessionRepoImpl sessionRepo;

  setUp(() {
    dataSource = MockSessionRemoteDataSource();
    safeCall = MockSafeCall();

    sessionRepo = SessionRepoImpl(
      dataSource,
      safeCall,
    );
  });

  group('getSessions', () {
    test('should return mapped sessions when data source succeeds', () async {
      final response = SessionResponse(
        data: [
          SessionItemResponse(
            id: '1',
            deviceName: 'Chrome',
            lastActiveAt: '2026-09-24T10:00:00Z',
            approximateLocationOrIp: '192.168.1.1',
            expiresAt: '2026-10-24T10:00:00Z',
          ),
          SessionItemResponse(
            id: '2',
            deviceName: 'Android',
            lastActiveAt: '2026-09-24T11:00:00Z',
            approximateLocationOrIp: '192.168.1.2',
            expiresAt: '2026-10-24T11:00:00Z',
          ),
        ],
      );

      when(dataSource.getSessions()).thenAnswer(
            (_) async => response,
      );

      when(
        safeCall.safeApiCall<List<SessionEntity>>(any),
      ).thenAnswer((invocation) async {
        final callback = invocation.positionalArguments.first
        as Future<List<SessionEntity>> Function();

        final data = await callback();

        return SuccessResponse<List<SessionEntity>>(data);
      });

      final result = await sessionRepo.getSessions();

      expect(
        result,
        isA<SuccessResponse<List<SessionEntity>>>(),
      );

      final success = result as SuccessResponse<List<SessionEntity>>;

      expect(success.data, hasLength(2));
      expect(success.data[0].id, '1');
      expect(success.data[0].deviceName, 'Chrome');
      expect(success.data[0].lastActiveAt, '2026-09-24T10:00:00Z');
      expect(
        success.data[0].approximateLocationOrIp,
        '192.168.1.1',
      );
      expect(
        success.data[0].expiresAt,
        '2026-10-24T10:00:00Z',
      );

      expect(success.data[1].id, '2');
      expect(success.data[1].deviceName, 'Android');

      verify(dataSource.getSessions()).called(1);
      verify(
        safeCall.safeApiCall<List<SessionEntity>>(any),
      ).called(1);
    });

    test('should return empty list when response data is null', () async {
      when(dataSource.getSessions()).thenAnswer(
            (_) async => SessionResponse(data: null),
      );

      when(
        safeCall.safeApiCall<List<SessionEntity>>(any),
      ).thenAnswer((invocation) async {
        final callback = invocation.positionalArguments.first
        as Future<List<SessionEntity>> Function();

        final data = await callback();

        return SuccessResponse<List<SessionEntity>>(data);
      });

      final result = await sessionRepo.getSessions();

      expect(
        result,
        isA<SuccessResponse<List<SessionEntity>>>(),
      );

      final success = result as SuccessResponse<List<SessionEntity>>;

      expect(success.data, isEmpty);

      verify(dataSource.getSessions()).called(1);
    });
  });

  group('revokeSession', () {
    test('should return true when session is revoked successfully', () async {
      const sessionId = 'session-1';

      when(
        dataSource.revokeSession(sessionId: sessionId),
      ).thenAnswer((_) async {});

      when(
        safeCall.safeApiCall<bool>(any),
      ).thenAnswer((invocation) async {
        final callback = invocation.positionalArguments.first
        as Future<bool> Function();

        final data = await callback();

        return SuccessResponse<bool>(data);
      });

      final result = await sessionRepo.revokeSession(
        sessionId: sessionId,
      );

      expect(result, isA<SuccessResponse<bool>>());

      final success = result as SuccessResponse<bool>;

      expect(success.data, isTrue);

      verify(
        dataSource.revokeSession(sessionId: sessionId),
      ).called(1);

      verify(
        safeCall.safeApiCall<bool>(any),
      ).called(1);
    });

    test('should propagate error response from SafeCall', () async {
      const sessionId = 'session-1';

      final errorResponse = ErrorResponse<bool>(
        appError: BadResponseError('Failed to revoke session'),
      );

      when(
        safeCall.safeApiCall<bool>(any),
      ).thenAnswer(
            (_) async => errorResponse,
      );

      final result = await sessionRepo.revokeSession(
        sessionId: sessionId,
      );

      expect(result, errorResponse);

      verify(
        safeCall.safeApiCall<bool>(any),
      ).called(1);

      verifyNever(
        dataSource.revokeSession(
          sessionId: sessionId,
        ),
      );
    });
  });
}