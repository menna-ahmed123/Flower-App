import 'package:flower_app/features/order/domain/entities/order_status.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/order_tracking_content.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/waiting_for_driver_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../fixtures/tracking_fixtures.dart';
import '../../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('shows ETA, driver and the whole timeline', (tester) async {
    await pumpApp(
      tester,
      Scaffold(body: OrderTrackingContent(tracking: trackingFixture(status: OrderStatus.preparing))),
    );
    expect(find.text('Estimated Arrival'), findsOneWidget);
    expect(find.text('Muhamed'), findsOneWidget);
    expect(find.text('Received your order'), findsOneWidget);
    expect(find.text('Delivered'), findsOneWidget);
  });

  testWidgets('no driver accepted yet -> the waiting view replaces the content',
      (tester) async {
    await pumpApp(
      tester,
      Scaffold(body: OrderTrackingContent(tracking: trackingFixture(withDriver: false))),
    );
    expect(find.byType(WaitingForDriverCard), findsOneWidget);
    expect(find.text('Estimated Arrival'), findsNothing);
    expect(find.text('Preparing your order'), findsNothing);
  });
}
