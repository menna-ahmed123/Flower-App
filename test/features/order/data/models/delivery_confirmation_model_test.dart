import 'package:flower_app/features/order/data/models/delivery_confirmation_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DeliveryConfirmationModel.fromJson', () {
    test('reads the real backend payload', () {
      final model = DeliveryConfirmationModel.fromJson(const {
        'orderId': 'd82c0bdb-0632-4119-a6d2-63b693ac3e9a',
        'status': 'DELIVERED',
        'confirmedAt': '2026-09-12T23:05:38.5826968Z',
      });

      expect(model.orderId, 'd82c0bdb-0632-4119-a6d2-63b693ac3e9a');
      expect(model.status, 'DELIVERED');
      expect(model.confirmedAt, isNotNull);
      // Round-trips without throwing, and keeps the instant in UTC.
      final parsed = DateTime.parse(model.confirmedAt!);
      expect(parsed.isUtc, isTrue);
      expect(parsed.year, 2026);
      expect(parsed.month, 9);
      expect(parsed.day, 12);
    });

    test('survives a missing data body', () {
      final model = DeliveryConfirmationModel.fromJson(const {});

      expect(model.orderId, isNull);
      expect(model.status, isNull);
      expect(model.confirmedAt, isNull);
    });
  });
}
