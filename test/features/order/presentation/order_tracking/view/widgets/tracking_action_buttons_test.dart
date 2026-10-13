import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/tracking_action_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

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

// Custom pumpApp with larger screen for this test file
Future<void> pumpAppLarge(WidgetTester tester, Widget child) async {
  tester.view.physicalSize = const Size(414, 896);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(414, 896),
      builder: (_, _) => MaterialApp(
        home: child,
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('only Show Map by default', (tester) async {
    await pumpAppLarge(tester, _buttons(showDelivered: false));
    expect(find.text('Show Map'), findsOneWidget);
    expect(find.text('Order Delivered'), findsNothing);
  });

  testWidgets('both buttons when delivery can be confirmed', (tester) async {
    await pumpAppLarge(tester, _buttons(showDelivered: true));
    expect(find.text('Show Map'), findsOneWidget);
    expect(find.text('Order Delivered'), findsOneWidget);
  });

  testWidgets('taps call the right callbacks', (tester) async {
    var map = 0, delivered = 0;
    await pumpAppLarge(
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

  testWidgets('while confirming, the label stays same with spinner and tap does nothing', (tester) async {
    var delivered = 0;
    await pumpAppLarge(
      tester,
      _buttons(showDelivered: true, isConfirming: true, onDelivered: () => delivered++),
    );
    // Text stays the same, spinner is added
    expect(find.text('Order Delivered'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.text('Order Delivered'));
    expect(delivered, 0);
  });
}
