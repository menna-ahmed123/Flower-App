import 'package:flower_app/features/order_tracking/presentation/view/widgets/staleness_badge.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('no timestamp -> waiting for location', (tester) async {
    await pumpApp(tester, const StalenessBadge(lastUpdate: null));
    expect(find.text('Waiting for location…'), findsOneWidget);
  });

  testWidgets('recent update -> Live', (tester) async {
    await pumpApp(
      tester,
      StalenessBadge(
        lastUpdate: DateTime.now().toUtc().subtract(const Duration(seconds: 10)),
      ),
    );
    expect(find.text('Live'), findsOneWidget);
  });

  testWidgets('1-3 minutes old -> Updated X ago', (tester) async {
    await pumpApp(
      tester,
      StalenessBadge(
        lastUpdate: DateTime.now().toUtc().subtract(const Duration(minutes: 2)),
      ),
    );
    expect(find.text('Updated 2 min ago'), findsOneWidget);
  });

  testWidgets('older than 3 minutes -> outdated warning', (tester) async {
    await pumpApp(
      tester,
      StalenessBadge(
        lastUpdate: DateTime.now().toUtc().subtract(const Duration(minutes: 10)),
      ),
    );
    expect(find.textContaining('Location outdated'), findsOneWidget);
  });

  testWidgets('a timestamp slightly in the future does not crash', (tester) async {
    await pumpApp(
      tester,
      StalenessBadge(
        lastUpdate: DateTime.now().toUtc().add(const Duration(seconds: 30)),
      ),
    );
    expect(find.text('Live'), findsOneWidget);
  });

  testWidgets('ages by itself as time passes (5s ticker)', (tester) async {
    await pumpApp(
      tester,
      StalenessBadge(
        lastUpdate: DateTime.now().toUtc().subtract(const Duration(seconds: 58)),
      ),
    );
    expect(find.text('Live'), findsOneWidget);
    await tester.pump(const Duration(seconds: 10));
    expect(find.text('Live'), findsNothing);
  });
}
