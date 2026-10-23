import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/waiting_for_driver_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('shows the waiting title and the finding-driver hint',
      (tester) async {
    await pumpApp(tester, const Scaffold(body: WaitingForDriverCard()));

    expect(find.text(AppString.waitingForDriver), findsOneWidget);
    expect(find.text(AppString.findingDriver), findsOneWidget);
    // A friendly delivery icon replaces the old bare spinner.
    expect(find.byIcon(Icons.delivery_dining), findsOneWidget);
  });
}
