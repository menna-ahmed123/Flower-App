import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/no_driver_available_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('explains that no driver is available yet', (tester) async {
    await pumpApp(tester, const Scaffold(body: NoDriverAvailableCard()));
    expect(find.text('No delivery driver available yet'), findsOneWidget);
    expect(find.textContaining("We're finding a driver"), findsOneWidget);
    expect(find.byIcon(Icons.delivery_dining), findsOneWidget);
  });

  testWidgets('pulses (FadeTransition) while waiting', (tester) async {
    await pumpApp(tester, const Scaffold(body: NoDriverAvailableCard()));

    // Bound to the card: the route transition brings its own FadeTransition.
    final finder = find.descendant(
      of: find.byType(NoDriverAvailableCard),
      matching: find.byType(FadeTransition),
    );
    expect(finder, findsOneWidget);

    double opacityAt() =>
        tester.widget<FadeTransition>(finder.first).opacity.value;

    final start = opacityAt();
    // Half a pulse later the opacity must have actually moved (the tween runs
    // 0.45 -> 1), proving the animation drives the widget over time.
    await tester.pump(const Duration(milliseconds: 600));
    final later = opacityAt();

    expect(later, isNot(equals(start)));
    expect(later, inInclusiveRange(0.45, 1.0));
    expect(tester.takeException(), isNull);
  });
}
