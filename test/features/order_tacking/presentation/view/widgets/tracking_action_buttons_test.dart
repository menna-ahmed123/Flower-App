import 'package:flower_app/features/order_tracking/presentation/view/widgets/tracking_action_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/pump_app.dart';

Widget _buttons({
  required bool showDelivered,
  bool isConfirming = false,
  VoidCallback? onMap,
  VoidCallback? onDelivered,
}) {
  return Scaffold(
    body: TrackingActionButtons(
      onShowMap: onMap ?? () {},
      onOrderDelivered: onDelivered ?? () {},
      showOrderDelivered: showDelivered,
      isConfirming: isConfirming,
    ),
  );
}

void main() {
  testWidgets('only Show Map by default', (tester) async {
    await pumpApp(tester, _buttons(showDelivered: false));
    expect(find.text('Show Map'), findsOneWidget);
    expect(find.text('Order Delivered'), findsNothing);
  });

  testWidgets('both buttons when delivery can be confirmed', (tester) async {
    await pumpApp(tester, _buttons(showDelivered: true));
    expect(find.text('Show Map'), findsOneWidget);
    expect(find.text('Order Delivered'), findsOneWidget);
  });

  testWidgets('taps call the right callbacks', (tester) async {
    var map = 0, delivered = 0;
    await pumpApp(
      tester,
      _buttons(
        showDelivered: true,
        onMap: () => map++,
        onDelivered: () => delivered++,
      ),
    );
    await tester.tap(find.text('Show Map'));
    await tester.tap(find.text('Order Delivered'));
    expect([map, delivered], [1, 1]);
  });

  testWidgets('while confirming, the label changes and a tap does nothing', (tester) async {
    var delivered = 0;
    await pumpApp(
      tester,
      _buttons(showDelivered: true, isConfirming: true, onDelivered: () => delivered++),
    );
    expect(find.text('Confirming...'), findsOneWidget);
    await tester.tap(find.text('Confirming...'));
    expect(delivered, 0);
  });
}
