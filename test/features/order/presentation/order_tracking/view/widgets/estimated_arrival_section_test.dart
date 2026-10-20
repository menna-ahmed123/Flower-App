import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/estimated_arrival_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('null ETA shows a dash', (tester) async {
    await pumpApp(
      tester,
      const Scaffold(body: EstimatedArrivalSection(estimatedArrivalDateTime: null)),
    );
    expect(find.text('Estimated Arrival'), findsOneWidget);
    expect(find.text('--'), findsOneWidget);
  });

  testWidgets('shows the formatted ETA', (tester) async {
    await pumpApp(
      tester,
      Scaffold(
        body: EstimatedArrivalSection(
          estimatedArrivalDateTime: DateTime(2024, 9, 3, 11, 0),
        ),
      ),
    );
    expect(find.textContaining('3 September 2024'), findsOneWidget);
  });
}
