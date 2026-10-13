import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/order_time_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../fixtures/tracking_fixtures.dart';
import '../../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('renders the four step titles', (tester) async {
    final t = trackingFixture();
    await pumpApp(
      tester,
      Scaffold(
        body: SingleChildScrollView(
          child: OrderTimeLine(steps: t.uiSteps, currentStep: t.uiStepIndex),
        ),
      ),
    );
    expect(find.text('Received your order'), findsOneWidget);
    expect(find.text('Preparing your order'), findsOneWidget);
    expect(find.text('Out for delivery'), findsOneWidget);
    expect(find.text('Delivered'), findsOneWidget);
  });

  testWidgets('steps without a timestamp render no date/time text', (tester) async {
    await pumpApp(
      tester,
      Scaffold(
        body: SingleChildScrollView(
          child: OrderTimeLine(
            steps: [
              (title: 'Received your order', time: null),
              (title: 'Preparing your order', time: null),
              (title: 'Out for delivery', time: null),
              (title: 'Delivered', time: null),
            ],
            currentStep: 0,
          ),
        ),
      ),
    );

    // Titles are present...
    expect(find.text('Received your order'), findsOneWidget);
    expect(find.text('Delivered'), findsOneWidget);
    // ...but a null time renders the empty string, never a formatted date,
    // so nothing on screen should contain a digit (dd/MMMM/yyyy/h:mm).
    expect(find.textContaining(RegExp(r'\d')), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
