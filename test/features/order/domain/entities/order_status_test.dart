import 'package:flower_app/features/order/domain/entities/order_status.dart';
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

    test('ARRIVED is shown as arrived', () {
      expect(OrderStatus.fromApi('ARRIVED'), OrderStatus.arrived);
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

  group('timelineStep', () {
    test('maps the nine statuses onto the four timeline steps', () {
      expect(OrderStatus.placed.timelineStep, 0);
      expect(OrderStatus.unknown.timelineStep, 0);
      expect(OrderStatus.cancelled.timelineStep, 0);
      expect(OrderStatus.preparing.timelineStep, 1);
      // Picking up is not "out for delivery" yet: it stays on preparing.
      expect(OrderStatus.pickedUp.timelineStep, 1);
      expect(OrderStatus.outForDelivery.timelineStep, 2);
      expect(OrderStatus.arrived.timelineStep, 2);
      // Awaiting confirmation reaches the final (delivered) step.
      expect(OrderStatus.awaitingDeliveryConfirmation.timelineStep, 3);
      expect(OrderStatus.delivered.timelineStep, 4);
    });

    test('resolves for every status, none left out', () {
      for (final status in OrderStatus.values) {
        expect(status.timelineStep, inInclusiveRange(0, 4));
      }
    });
  });
}
