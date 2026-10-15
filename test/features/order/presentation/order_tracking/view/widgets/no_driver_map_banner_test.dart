import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/no_driver_map_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('shows Waiting for a driver', (tester) async {
    await pumpApp(tester, const Scaffold(body: NoDriverMapBanner()));
    expect(find.text('Waiting for a driver'), findsOneWidget);
  });
}
