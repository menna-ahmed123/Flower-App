import 'package:flower_app/core/widgets/app_shimmer/orders_list_shimmer.dart';
import 'package:flower_app/core/widgets/app_shimmer/shimmer_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('renders a shimmer skeleton without throwing', (tester) async {
    await pumpApp(tester, const Scaffold(body: OrdersListShimmer()));
    await tester.pump();

    expect(find.byType(OrdersListShimmer), findsOneWidget);
    expect(find.byType(AppShimmerEffect), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('respects the requested itemCount', (tester) async {
    await pumpApp(tester, const Scaffold(body: OrdersListShimmer(itemCount: 2)));
    await tester.pump();

    // One skeleton row per requested item (not a shallow "any ShimmerBox").
    expect(find.byType(OrderCardShimmer), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });
}
