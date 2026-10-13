import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/tracking_error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('shows message and a working Retry', (tester) async {
    var retries = 0;
    await pumpApp(
      tester,
      Scaffold(body: TrackingErrorView(message: 'Boom', onRetry: () => retries++)),
    );
    expect(find.text('Boom'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    expect(retries, 1);
  });

  testWidgets('no Retry button without a callback', (tester) async {
    await pumpApp(tester, const Scaffold(body: TrackingErrorView(message: 'Boom')));
    expect(find.text('Retry'), findsNothing);
  });
}
