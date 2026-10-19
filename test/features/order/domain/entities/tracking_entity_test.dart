import 'package:flower_app/features/order/domain/entities/order_status.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/tracking_fixtures.dart';

void main() {
  test('maps the 5 backend statuses to the 4 Figma steps', () {
    int step(OrderStatus s) => trackingFixture(status: s).uiStepIndex;
    expect(step(OrderStatus.placed), 0);
    expect(step(OrderStatus.preparing), 1);
    expect(step(OrderStatus.pickedUp), 2);
    expect(step(OrderStatus.outForDelivery), 2);
    expect(step(OrderStatus.delivered), 4); // 4 means all steps completed
  });

  test('Order Delivered button only when awaiting delivery confirmation', () {
    expect(trackingFixture(status: OrderStatus.awaitingDeliveryConfirmation).canConfirmDelivery, isTrue);
    expect(trackingFixture(status: OrderStatus.outForDelivery).canConfirmDelivery, isFalse);
    expect(trackingFixture(status: OrderStatus.preparing).canConfirmDelivery, isFalse);
    expect(trackingFixture(status: OrderStatus.delivered).canConfirmDelivery, isFalse);
  });

  test('isFinished follows the status', () {
    expect(trackingFixture(status: OrderStatus.delivered).isFinished, isTrue);
    expect(trackingFixture().isFinished, isFalse);
  });
}
