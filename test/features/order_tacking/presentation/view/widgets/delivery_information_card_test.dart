import 'package:flower_app/features/order_tracking/presentation/view/widgets/delivery_information_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('shows driver name and the hero subtitle', (tester) async {
    await pumpApp(
      tester,
      const Scaffold(
        body: DeliveryInformationCard(
          deliveryName: 'Muhamed',
          deliveryPhoneNumber: '01012345678',
        ),
      ),
    );
    expect(find.text('Muhamed'), findsOneWidget);
    expect(find.text('Is your delivery hero for today'), findsOneWidget);
  });

  testWidgets('a very long name is ellipsized, no overflow', (tester) async {
    await pumpApp(
      tester,
      Scaffold(
        body: DeliveryInformationCard(
          deliveryName: 'A' * 120,
          deliveryPhoneNumber: '01012345678',
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });
}
