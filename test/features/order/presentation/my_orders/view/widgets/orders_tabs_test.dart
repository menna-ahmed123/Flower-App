import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/order/presentation/my_orders/view/models/my_orders_tab.dart';
import 'package:flower_app/features/order/presentation/my_orders/view/widgets/orders_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('renders both tab labels', (tester) async {
    await pumpApp(
      tester,
      Scaffold(
        body: OrdersTabs(
          selectedTab: MyOrdersTab.active,
          onTabSelected: (_) {},
        ),
      ),
    );

    expect(find.text(AppString.active), findsOneWidget);
    expect(find.text(AppString.completed), findsOneWidget);
  });

  testWidgets('tapping a tab reports that tab', (tester) async {
    MyOrdersTab? selected;
    await pumpApp(
      tester,
      Scaffold(
        body: OrdersTabs(
          selectedTab: MyOrdersTab.active,
          onTabSelected: (tab) => selected = tab,
        ),
      ),
    );

    await tester.tap(find.text(AppString.completed));

    expect(selected, MyOrdersTab.completed);
  });

  testWidgets('tapping the already-selected tab is still reported',
      (tester) async {
    MyOrdersTab? selected;
    await pumpApp(
      tester,
      Scaffold(
        body: OrdersTabs(
          selectedTab: MyOrdersTab.completed,
          onTabSelected: (tab) => selected = tab,
        ),
      ),
    );

    await tester.tap(find.text(AppString.completed));

    expect(selected, MyOrdersTab.completed);
  });
}
