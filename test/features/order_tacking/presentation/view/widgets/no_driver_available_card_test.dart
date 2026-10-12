import 'package:flower_app/features/order_tracking/presentation/view/widgets/no_driver_available_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('explains that no driver is available yet', (tester) async {
    await pumpApp(tester, const Scaffold(body: NoDriverAvailableCard()));
    expect(find.text('No delivery driver available yet'), findsOneWidget);
    expect(find.textContaining("We're finding a driver"), findsOneWidget);
    expect(find.byIcon(Icons.delivery_dining), findsOneWidget);
  });

  testWidgets('pulses (FadeTransition) while waiting', (tester) async {
    await pumpApp(tester, const Scaffold(body: NoDriverAvailableCard()));
    expect(find.byType(FadeTransition), findsWidgets);
    await tester.pump(const Duration(milliseconds: 600));
    expect(tester.takeException(), isNull);
  });
}
