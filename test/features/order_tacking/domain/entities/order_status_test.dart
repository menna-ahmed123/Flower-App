import 'package:flower_app/features/order_tracking/domain/entities/order_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OrderStatus.fromApi', () {
    test('accepts both API spellings', () {
      expect(OrderStatus.fromApi('PLACED'), OrderStatus.placed);
      expect(OrderStatus.fromApi('Placed'), OrderStatus.placed);
      expect(OrderStatus.fromApi('OUT_FOR_DELIVERY'), OrderStatus.outForDelivery);
      expect(OrderStatus.fromApi('PICKED_UP'), OrderStatus.pickedUp);
      expect(OrderStatus.fromApi('DELIVERED'), OrderStatus.delivered);
    });

    test('ARRIVED is shown as out for delivery', () {
      expect(OrderStatus.fromApi('ARRIVED'), OrderStatus.outForDelivery);
    });

    test('unknown / null never throw', () {
      expect(OrderStatus.fromApi('whatever'), OrderStatus.unknown);
      expect(OrderStatus.fromApi(null), OrderStatus.unknown);
    });
  });

  group('tabs', () {
    test('finished = delivered or cancelled', () {
      expect(OrderStatus.delivered.isFinished, isTrue);
      expect(OrderStatus.cancelled.isFinished, isTrue);
      expect(OrderStatus.preparing.isFinished, isFalse);
    });

    test('unknown stays in Active so no order disappears', () {
      expect(OrderStatus.unknown.isActive, isTrue);
    });
  });
}
