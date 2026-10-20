import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/theme/app_theme.dart';
import 'package:flower_app/features/order/domain/entities/order_status.dart';
import 'package:flower_app/features/order/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/page/order_tracking_map_page.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/no_driver_map_banner.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/staleness_badge.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/tracking_map.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view_model/order_tracking_state.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view_model/order_tracking_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../fixtures/tracking_fixtures.dart';
import '../../../../../../helpers/pump_app.dart';

/// The page reads whatever the view model above it holds.
class _TestViewModel extends OrderTrackingViewModel {
  void emitState(OrderTrackingState state) => emit(state);
}

Widget _mapPage(OrderTrackingViewModel viewModel) {
  // Spelled out so the provider matches the type the page reads up.
  return BlocProvider<OrderTrackingViewModel>.value(
    value: viewModel,
    // no network tiles in tests
    child: const OrderTrackingMapPage(mapTileLayer: SizedBox.shrink()),
  );
}

Future<_TestViewModel> _pumpMap(
  WidgetTester tester, {
  TrackingEntity? tracking,
}) async {
  final viewModel = _TestViewModel();
  addTearDown(viewModel.close);
  if (tracking != null) {
    viewModel.emitState(
      OrderTrackingState(
        trackingState: BaseState(data: tracking),
        routePoints: const [storePoint, homePoint],
      ),
    );
  }
  await pumpApp(tester, _mapPage(viewModel));
  return viewModel;
}

void main() {
  testWidgets('no data yet -> spinner, no map', (tester) async {
    await _pumpMap(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(TrackingMap), findsNothing);
  });

  testWidgets('shows map, staleness badge, driver and Order details', (tester) async {
    await _pumpMap(
      tester,
      tracking: trackingFixture(
        status: OrderStatus.outForDelivery,
        recordedAt: DateTime.now().toUtc(),
      ),
    );
    expect(find.byType(TrackingMap), findsOneWidget);
    expect(find.byType(StalenessBadge), findsOneWidget);
    expect(find.text('Live'), findsOneWidget);
    expect(find.text('Muhamed'), findsOneWidget);
    expect(find.text('Order details'), findsOneWidget);
  });

  testWidgets('no driver -> banner instead of the staleness badge', (tester) async {
    await _pumpMap(tester, tracking: trackingFixture(withDriver: false));
    expect(find.byType(NoDriverMapBanner), findsOneWidget);
    expect(find.byType(StalenessBadge), findsNothing);
  });

  testWidgets('Order details is offered and tappable', (tester) async {
    // There is no order-details route yet, so the screen handles it in private:
    // tapping must not throw anything.
    await _pumpMap(tester, tracking: trackingFixture());
    expect(find.text('Order details'), findsOneWidget);
    await tester.tap(find.text('Order details'));
    expect(tester.takeException(), isNull);
  });

  // The back button is not a callback: the screen pops its own route.
  testWidgets('back button pops the route it was pushed on', (tester) async {
    tester.view.physicalSize = const Size(414, 896);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final viewModel = _TestViewModel();
    addTearDown(viewModel.close);
    viewModel.emitState(
      OrderTrackingState(
        trackingState: BaseState(data: trackingFixture()),
        routePoints: const [storePoint, homePoint],
      ),
    );

    final router = GoRouter(
      initialLocation: AppRoutesName.home,
      routes: [
        GoRoute(
          path: AppRoutesName.home,
          builder: (_, _) => const Text('home-page'),
        ),
        GoRoute(
          path: AppRoutesName.orderTrackingMapPage,
          builder: (_, _) => _mapPage(viewModel),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(414, 896),
        builder: (_, _) => MaterialApp.router(
          theme: AppTheme(lightThemeColors).themeData,
          routerConfig: router,
        ),
      ),
    );

    router.push(AppRoutesName.orderTrackingMapPage);
    await _pumpTransition(tester);
    expect(find.byType(OrderTrackingMapPage), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await _pumpTransition(tester);
    expect(find.byType(OrderTrackingMapPage), findsNothing);
    expect(find.text('home-page'), findsOneWidget);
  });
}

/// Walks a route transition frame by frame, since pumpAndSettle is off limits
/// here (the marker animation never settles).
Future<void> _pumpTransition(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}
