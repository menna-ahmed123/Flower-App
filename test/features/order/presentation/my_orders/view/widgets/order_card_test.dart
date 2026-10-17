import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/order/presentation/my_orders/view/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/pump_app.dart';

void main() {
  OrderCard card({VoidCallback? onTrack}) => OrderCard(
        orderImageUrl: '',
        orderName: '3 items',
        orderPrice: 'EGP 155',
        orderNumber: 'ORD-20261011-AE0565',
        onTrackOrder: onTrack ?? () {},
      );

  testWidgets('shows name, price and order number', (tester) async {
    await pumpApp(tester, Scaffold(body: card()));

    expect(find.text('3 items'), findsOneWidget);
    expect(find.text('EGP 155'), findsOneWidget);
    expect(find.text('ORD-20261011-AE0565'), findsOneWidget);
  });

  testWidgets('track button fires the callback', (tester) async {
    var tapped = 0;
    await pumpApp(tester, Scaffold(body: card(onTrack: () => tapped++)));

    await tester.tap(find.text(AppString.trackOrder));

    expect(tapped, 1);
  });

  testWidgets('an empty image url falls back to a placeholder (no network)',
      (tester) async {
    await pumpApp(tester, Scaffold(body: card()));
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
