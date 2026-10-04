import 'package:flower_app/features/sessions/data/mapper/session_item_response_mapper.dart';
import 'package:flower_app/features/sessions/data/models/response/session_item_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SessionItemResponseMapper', () {
    test('should map SessionItemResponse to SessionEntity correctly', () {
      final response = SessionItemResponse(
        id: '1',
        deviceName: 'Chrome',
        lastActiveAt: '2026-09-24T10:00:00Z',
        approximateLocationOrIp: '192.168.1.1',
        expiresAt: '2026-10-24T10:00:00Z',
      );

      final result = response.toEntity();

      expect(result.id, response.id);
      expect(result.deviceName, response.deviceName);
      expect(result.lastActiveAt, response.lastActiveAt);
      expect(
        result.approximateLocationOrIp,
        response.approximateLocationOrIp,
      );
      expect(result.expiresAt, response.expiresAt);
    });

    test('should preserve null values when mapping', () {
      final response = SessionItemResponse();

      final result = response.toEntity();

      expect(result.id, isNull);
      expect(result.deviceName, isNull);
      expect(result.lastActiveAt, isNull);
      expect(result.approximateLocationOrIp, isNull);
      expect(result.expiresAt, isNull);
    });
  });
}