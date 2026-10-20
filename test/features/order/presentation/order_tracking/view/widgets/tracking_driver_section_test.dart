import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/delivery_information_card.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/no_driver_available_card.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/tracking_driver_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../fixtures/tracking_fixtures.dart';
import '../../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('with a driver -> driver card with name', (tester) async {
    await pumpApp(tester, const Scaffold(body: TrackingDriverSection(driver: driver)));
    expect(find.byType(DeliveryInformationCard), findsOneWidget);
    expect(find.text('Muhamed'), findsOneWidget);
    expect(find.byType(NoDriverAvailableCard), findsNothing);
  });

  testWidgets('without a driver -> no-driver card', (tester) async {
    await pumpApp(tester, const Scaffold(body: TrackingDriverSection(driver: null)));
    expect(find.byType(NoDriverAvailableCard), findsOneWidget);
    expect(find.byType(DeliveryInformationCard), findsNothing);
  });
}
