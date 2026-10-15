import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/map_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('tap calls onPressed', (tester) async {
    var taps = 0;
    await pumpApp(tester, Scaffold(body: MapBackButton(onPressed: () => taps++)));
    await tester.tap(find.byIcon(Icons.arrow_back));
    expect(taps, 1);
  });
}
