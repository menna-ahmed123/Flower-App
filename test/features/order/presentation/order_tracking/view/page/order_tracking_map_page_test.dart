import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/theme/app_theme.dart';
import 'package:flower_app/features/order/domain/entities/delivery_confirmation_entity.dart';
import 'package:flower_app/features/order/domain/entities/order_entity.dart';
import 'package:flower_app/features/order/domain/entities/order_status.dart';
import 'package:flower_app/features/order/domain/entities/geo_point.dart';
import 'package:flower_app/features/order/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/order/domain/repos/order_repo.dart';
import 'package:flower_app/features/order/domain/use_cases/confirm_delivery_use_case.dart';
import 'package:flower_app/features/order/domain/use_cases/get_order_route_use_case.dart';
import 'package:flower_app/features/order/domain/use_cases/watch_order_tracking_use_case.dart';
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

/// The page reads whatever the view model above it holds; the watch source
/// stays silent because these tests drive the state directly.
class _SilentOrderRepo implements OrderRepo {
  @override
  Stream<TrackingEntity> watchTracking({required String orderId}) =>
      const Stream.empty();

  @override
  Future<BaseResponse<List<OrderEntity>>> getAllOrders({
    int? page,
    int? pageSize,
  }) => throw UnimplementedError();

  @override
  Future<BaseResponse<TrackingEntity>> orderTracking({
    required String orderId,
  }) => throw UnimplementedError();

  @override
  Future<BaseResponse<DeliveryConfirmationEntity>> confirmDelivery({
    required String orderId,
  }) async => SuccessResponse(
        DeliveryConfirmationEntity(
          orderId: orderId,
          status: OrderStatus.delivered,
          confirmedAt: DateTime.utc(2024, 9, 3, 12),
        ),
      );

  @override
  Future<BaseResponse<List<GeoPoint>>> fetchRoute({
    required GeoPoint from,
    required GeoPoint to,
  }) async => const SuccessResponse([]);
}

class _TestViewModel extends OrderTrackingViewModel {
  _TestViewModel() : super(
        WatchOrderTrackingUseCase(_SilentOrderRepo()),
        ConfirmDeliveryUseCase(_SilentOrderRepo()),
        GetOrderRouteUseCase(_SilentOrderRepo()),
      );

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

  testWidgets('assigned driver without a live location starts at the store', (tester) async {
    await _pumpMap(
      tester,
      tracking: trackingFixture(
        status: OrderStatus.outForDelivery,
        withDriverLocation: false,
      ),
    );
    final map = tester.widget<TrackingMap>(find.byType(TrackingMap));
    expect(map.driver, storePoint);
    expect(find.byType(StalenessBadge), findsOneWidget);
  });

  testWidgets('Order details is offered and tappable', (tester) async {
    // Pumped without a router: the screen guards its pop, so tapping here must
    // stay a safe no-op instead of throwing.
    await _pumpMap(tester, tracking: trackingFixture());
    expect(find.text('Order details'), findsOneWidget);
    await tester.tap(find.text('Order details'));
    expect(tester.takeException(), isNull);
  });

  // With a real router under it, "Order details" returns to the page the map
  // was pushed from (the order details live directly below in the stack).
  testWidgets('Order details pops back to the details page', (tester) async {
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
          builder: (_, _) => const Text('details-page'),
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

    await tester.tap(find.text('Order details'));
    await _pumpTransition(tester);
    expect(find.byType(OrderTrackingMapPage), findsNothing);
    expect(find.text('details-page'), findsOneWidget);
  });

  // The only way back is the bottom button; there is no top back arrow.
  testWidgets('no top back button on the map', (tester) async {
    await _pumpMap(tester, tracking: trackingFixture());
    expect(find.byIcon(Icons.arrow_back), findsNothing);
  });
}

/// Walks a route transition frame by frame, since pumpAndSettle is off limits
/// here (the marker animation never settles).
Future<void> _pumpTransition(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}
