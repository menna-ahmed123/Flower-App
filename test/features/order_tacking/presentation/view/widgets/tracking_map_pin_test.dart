import 'package:flower_app/features/order_tracking/presentation/view/widgets/tracking_map_pin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('shows the label, its icon and the pin', (tester) async {
    await pumpApp(
      tester,
      const Scaffold(
        body: Center(child: TrackingMapPin(label: 'Flowery', icon: Icons.storefront)),
      ),
    );
    expect(find.text('Flowery'), findsOneWidget);
    expect(find.byIcon(Icons.storefront), findsOneWidget);
    expect(find.byIcon(Icons.location_on), findsOneWidget);
  });
}
