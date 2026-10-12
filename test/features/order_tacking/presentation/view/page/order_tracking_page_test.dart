import 'package:flower_app/features/order_tracking/domain/entities/order_status.dart';
import 'package:flower_app/features/order_tracking/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/order_tracking/presentation/view/page/order_tracking_page.dart';
import 'package:flower_app/features/order_tracking/presentation/view/widgets/no_driver_available_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../fixtures/tracking_fixtures.dart';
import '../../../../../helpers/pump_app.dart';

OrderTrackingPage _page({
  TrackingEntity? tracking,
  bool isLoading = false,
  String? errorMessage,
  bool isConfirming = false,
  VoidCallback? onShowMap,
  VoidCallback? onDelivered,
  VoidCallback? onRetry,
}) {
  return OrderTrackingPage(
    tracking: tracking,
    isLoading: isLoading,
    errorMessage: errorMessage,
    isConfirmingDelivery: isConfirming,
    onShowMap: onShowMap ?? () {},
    onOrderDelivered: onDelivered ?? () {},
    onRetry: onRetry,
  );
}

void main() {
  testWidgets('no data yet -> spinner', (tester) async {
    await pumpApp(tester, _page(isLoading: true));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('error with no data -> message + working Retry', (tester) async {
    var retries = 0;
    await pumpApp(tester, _page(errorMessage: 'Network down', onRetry: () => retries++));
    expect(find.text('Network down'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    expect(retries, 1);
  });

  testWidgets('with data shows driver, timeline and Show Map only', (tester) async {
    await pumpApp(tester, _page(tracking: trackingFixture(status: OrderStatus.preparing)));
    expect(find.text('Muhamed'), findsOneWidget);
    expect(find.text('Preparing your order'), findsOneWidget);
    expect(find.text('Show Map'), findsOneWidget);
    expect(find.text('Order Delivered'), findsNothing);
  });

  testWidgets('out for delivery -> Order Delivered appears and works', (tester) async {
    var delivered = 0;
    await pumpApp(
      tester,
      _page(
        tracking: trackingFixture(status: OrderStatus.outForDelivery),
        onDelivered: () => delivered++,
      ),
    );
    await tester.tap(find.text('Order Delivered'));
    expect(delivered, 1);
  });

  testWidgets('Show Map fires its callback', (tester) async {
    var maps = 0;
    await pumpApp(tester, _page(tracking: trackingFixture(), onShowMap: () => maps++));
    await tester.tap(find.text('Show Map'));
    expect(maps, 1);
  });

  testWidgets('no driver available -> the no-driver state is shown', (tester) async {
    await pumpApp(tester, _page(tracking: trackingFixture(withDriver: false)));
    expect(find.byType(NoDriverAvailableCard), findsOneWidget);
    expect(find.text('Muhamed'), findsNothing);
  });

  testWidgets('confirming delivery shows the busy label', (tester) async {
    await pumpApp(
      tester,
      _page(
        tracking: trackingFixture(status: OrderStatus.outForDelivery),
        isConfirming: true,
      ),
    );
    expect(find.text('Confirming...'), findsOneWidget);
  });
}
