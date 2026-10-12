import 'package:flower_app/features/order_tracking/domain/entities/order_status.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/tracking_fixtures.dart';

void main() {
  test('maps the 5 backend statuses to the 4 Figma steps', () {
    int step(OrderStatus s) => trackingFixture(status: s).uiStepIndex;
    expect(step(OrderStatus.placed), 0);
    expect(step(OrderStatus.preparing), 1);
    expect(step(OrderStatus.pickedUp), 2);
    expect(step(OrderStatus.outForDelivery), 2);
    expect(step(OrderStatus.delivered), 3);
  });

  test('Order Delivered button only when out for delivery', () {
    expect(trackingFixture(status: OrderStatus.outForDelivery).canConfirmDelivery, isTrue);
    expect(trackingFixture(status: OrderStatus.preparing).canConfirmDelivery, isFalse);
    expect(trackingFixture(status: OrderStatus.delivered).canConfirmDelivery, isFalse);
  });

  test('uiSteps has 4 titled steps and picks the matching timestamps', () {
    final steps = trackingFixture(status: OrderStatus.outForDelivery).uiSteps;
    expect(steps.map((s) => s.title), [
      'Received your order',
      'Preparing your order',
      'Out for delivery',
      'Delivered',
    ]);
    expect(steps[0].time, isNotNull);
    expect(steps[3].time, isNull); // not delivered yet
  });

  test('isFinished follows the status', () {
    expect(trackingFixture(status: OrderStatus.delivered).isFinished, isTrue);
    expect(trackingFixture().isFinished, isFalse);
  });
}
