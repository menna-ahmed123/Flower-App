import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/staleness_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/pump_app.dart';

void main() {
  // A single fixed "now" makes every staleness branch deterministic; the
  // badge no longer reads the wall clock (review: injectable clock).
  final fixedNow = DateTime.utc(2026, 10, 13, 12, 0, 0);
  DateTime clock() => fixedNow;

  Widget badge(Duration age) => StalenessBadge(
        lastUpdate: fixedNow.subtract(age),
        now: clock,
      );

  testWidgets('no timestamp -> waiting for location', (tester) async {
    await pumpApp(tester, StalenessBadge(lastUpdate: null, now: clock));
    expect(find.text(AppString.waitingForLocation), findsOneWidget);
  });

  testWidgets('under a minute -> Live', (tester) async {
    await pumpApp(tester, badge(const Duration(seconds: 10)));
    expect(find.text('Live'), findsOneWidget);
  });

  testWidgets('1-3 minutes -> Updated X min ago', (tester) async {
    await pumpApp(tester, badge(const Duration(minutes: 2)));
    expect(find.text('Updated 2 min ago'), findsOneWidget);
  });

  testWidgets('over 3 minutes -> outdated warning', (tester) async {
    await pumpApp(tester, badge(const Duration(minutes: 10)));
    expect(find.textContaining('Location outdated'), findsOneWidget);
  });

  testWidgets('timestamp in the future is treated as Live, not negative',
      (tester) async {
    await pumpApp(tester, badge(const Duration(seconds: -30)));
    expect(find.text('Live'), findsOneWidget);
  });

  testWidgets('ageing past the thresholds re-labels on the periodic tick',
      (tester) async {
    var now = fixedNow;
    await pumpApp(
      tester,
      StalenessBadge(
        lastUpdate: fixedNow.subtract(const Duration(seconds: 30)),
        now: () => now,
      ),
    );
    expect(find.text('Live'), findsOneWidget);

    now = now.add(const Duration(seconds: 5)); // 35s -> still Live, no rebuild
    await tester.pump(const Duration(seconds: 5));
    expect(find.text('Live'), findsOneWidget);

    now = now.add(const Duration(minutes: 1)); // cross into "Updated"
    await tester.pump(const Duration(seconds: 5));
    expect(find.text('Updated 1 min ago'), findsOneWidget);
  });
}
