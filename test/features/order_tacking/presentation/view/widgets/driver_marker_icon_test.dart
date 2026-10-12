import 'package:flower_app/features/order_tracking/presentation/view/widgets/driver_marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('renders the scooter icon at the requested size', (tester) async {
    await pumpApp(tester, const Scaffold(body: Center(child: DriverMarkerIcon(size: 60))));
    expect(find.byIcon(Icons.two_wheeler), findsOneWidget);
    expect(tester.getSize(find.byType(DriverMarkerIcon)), const Size(60, 60));
  });
}
