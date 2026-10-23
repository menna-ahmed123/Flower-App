import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/order/domain/entities/order_status.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/extensions/order_status_tracking_label.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/extensions/tracking_timeline_steps.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../fixtures/tracking_fixtures.dart';

void main() {
  test('the four steps come in display order', () {
    final steps = trackingFixture(
      status: OrderStatus.outForDelivery,
    ).trackingTimeline;

    expect(steps.map((s) => s.status), [
      OrderStatus.placed,
      OrderStatus.preparing,
      OrderStatus.outForDelivery,
      OrderStatus.delivered,
    ]);
  });

  test('each step carries the moment its own status happened', () {
    final steps = trackingFixture(
      status: OrderStatus.outForDelivery,
    ).trackingTimeline;

    expect(steps[0].occurredAt, DateTime.utc(2024, 9, 3, 10));
    expect(steps[2].occurredAt, DateTime.utc(2024, 9, 3, 13));
    expect(steps[3].occurredAt, isNull); // not delivered yet
  });

  test('pickedUp keeps the order on preparing, not out for delivery', () {
    // Picking up is not a delivery trip yet: the out-for-delivery step stays
    // undated and unlit until the driver is actually on the way.
    final t = trackingFixture(status: OrderStatus.pickedUp);
    final steps = t.trackingTimeline;

    expect(t.uiStepIndex, 1); // preparing is the current step
    expect(steps[2].status, OrderStatus.outForDelivery);
    expect(steps[2].occurredAt, isNull);
    expect(steps[1].occurredAt, DateTime.utc(2024, 9, 3, 11));
  });

  test('awaiting confirmation reaches the final (delivered) step', () {
    final t = trackingFixture(status: OrderStatus.awaitingDeliveryConfirmation);
    final steps = t.trackingTimeline;

    expect(t.uiStepIndex, 3); // the last step is now lit
    expect(t.canConfirmDelivery, isTrue); // and the customer can confirm
    expect(steps[3].occurredAt, DateTime.utc(2024, 9, 3, 15));
  });

  test('a delivered order closes every step', () {
    final steps = trackingFixture(status: OrderStatus.delivered).trackingTimeline;

    expect(steps.every((s) => s.occurredAt != null), isTrue);
  });

  test('an order with no timeline yet leaves every step undated', () {
    final steps = realPlacedSampleFixture().trackingTimeline;

    expect(steps.every((s) => s.occurredAt == null), isTrue);
  });

  test('the wording is read from the localized label of the status', () {
    final steps = trackingFixture().trackingTimeline;

    expect(steps[0].status.trackingLabel, AppString.trackingStepReceived);
    expect(steps[3].status.trackingLabel, AppString.statusDelivered);
  });
}
