import 'package:flower_app/features/order_tracking/domain/entities/order_status.dart';
import 'package:flower_app/features/order_tracking/presentation/view/widgets/no_driver_available_card.dart';
import 'package:flower_app/features/order_tracking/presentation/view/widgets/order_tracking_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../fixtures/tracking_fixtures.dart';
import '../../../../../helpers/pump_app.dart';

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

  testWidgets('no driver -> no-driver card, timeline still visible', (tester) async {
    await pumpApp(
      tester,
      Scaffold(body: OrderTrackingContent(tracking: trackingFixture(withDriver: false))),
    );
    expect(find.byType(NoDriverAvailableCard), findsOneWidget);
    expect(find.text('Preparing your order'), findsOneWidget);
  });
}
