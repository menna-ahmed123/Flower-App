import 'package:flower_app/features/order/domain/entities/order_status.dart';
import 'package:flower_app/features/order/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/page/order_tracking_map_page.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/no_driver_map_banner.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/staleness_badge.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/tracking_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../fixtures/tracking_fixtures.dart';
import '../../../../../../helpers/pump_app.dart';

OrderTrackingMapPage _page({
  TrackingEntity? tracking,
  VoidCallback? onBack,
  VoidCallback? onDetails,
}) {
  return OrderTrackingMapPage(
    tracking: tracking,
    onBack: onBack ?? () {},
    onOrderDetails: onDetails ?? () {},
    mapTileLayer: const SizedBox.shrink(), // no network tiles in tests
  );
}

void main() {
  testWidgets('no data yet -> spinner, no map', (tester) async {
    await pumpApp(tester, _page());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(TrackingMap), findsNothing);
  });

  testWidgets('shows map, staleness badge, driver and Order details', (tester) async {
    await pumpApp(
      tester,
      _page(tracking: trackingFixture(status: OrderStatus.outForDelivery, recordedAt: DateTime.now().toUtc())),
    );
    expect(find.byType(TrackingMap), findsOneWidget);
    expect(find.byType(StalenessBadge), findsOneWidget);
    expect(find.text('Live'), findsOneWidget);
    expect(find.text('Muhamed'), findsOneWidget);
    expect(find.text('Order details'), findsOneWidget);
  });

  testWidgets('no driver -> banner instead of the staleness badge', (tester) async {
    await pumpApp(tester, _page(tracking: trackingFixture(withDriver: false)));
    expect(find.byType(NoDriverMapBanner), findsOneWidget);
    expect(find.byType(StalenessBadge), findsNothing);
  });

  testWidgets('back button and Order details call their callbacks', (tester) async {
    var back = 0, details = 0;
    await pumpApp(
      tester,
      _page(tracking: trackingFixture(), onBack: () => back++, onDetails: () => details++),
    );
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.tap(find.text('Order details'));
    expect([back, details], [1, 1]);
  });
}
