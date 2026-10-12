import 'package:flower_app/features/order_tracking/presentation/view/widgets/no_driver_available_card.dart';
import 'package:flower_app/features/order_tracking/presentation/view/widgets/tracking_bottom_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../fixtures/tracking_fixtures.dart';
import '../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('shows ETA, driver and Order details', (tester) async {
    await pumpApp(
      tester,
      Scaffold(
        body: TrackingBottomPanel(tracking: trackingFixture(), onOrderDetails: () {}),
      ),
    );
    expect(find.text('Estimated Arrival'), findsOneWidget);
    expect(find.text('Muhamed'), findsOneWidget);
    expect(find.text('Order details'), findsOneWidget);
  });

  testWidgets('Order details tap fires the callback', (tester) async {
    var taps = 0;
    await pumpApp(
      tester,
      Scaffold(
        body: TrackingBottomPanel(tracking: trackingFixture(), onOrderDetails: () => taps++),
      ),
    );
    await tester.tap(find.text('Order details'));
    expect(taps, 1);
  });

  testWidgets('no driver -> the no-driver card instead', (tester) async {
    await pumpApp(
      tester,
      Scaffold(
        body: TrackingBottomPanel(
          tracking: trackingFixture(withDriver: false),
          onOrderDetails: () {},
        ),
      ),
    );
    expect(find.byType(NoDriverAvailableCard), findsOneWidget);
    expect(find.text('Muhamed'), findsNothing);
  });
}
