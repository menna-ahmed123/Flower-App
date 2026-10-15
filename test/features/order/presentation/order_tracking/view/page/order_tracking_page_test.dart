import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/theme/app_theme.dart';
import 'package:flower_app/features/order/domain/entities/order_status.dart';
import 'package:flower_app/features/order/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/page/order_tracking_page.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/waiting_for_driver_card.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view_model/order_tracking_event.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view_model/order_tracking_state.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view_model/order_tracking_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../fixtures/tracking_fixtures.dart';
import '../../../../../../helpers/pump_app.dart';

/// Lets a test put the screen on any state, the way the cart tests do.
class _TestViewModel extends OrderTrackingViewModel {
  void emitState(OrderTrackingState state) => emit(state);
}

Future<_TestViewModel> _pumpPage(
  WidgetTester tester, {
  TrackingEntity? tracking,
  String errorMessage = '',
  bool isConfirming = false,
  bool load = false,
}) async {
  final viewModel = _TestViewModel();
  addTearDown(viewModel.close);

  if (tracking != null || errorMessage.isNotEmpty) {
    viewModel.emitState(
      OrderTrackingState(
        trackingState: BaseState(data: tracking, errorMessage: errorMessage),
      ),
    );
  }
  if (isConfirming) {
    viewModel.emitState(viewModel.state.copyWith(isConfirmingDelivery: true));
  }
  if (load) await viewModel.onEvent(LoadOrderTracking('o1'));

  await pumpApp(
    tester,
    // The type is spelled out: the screen looks the view model up as
    // OrderTrackingViewModel, not as the test subclass.
    BlocProvider<OrderTrackingViewModel>.value(
      value: viewModel,
      child: const OrderTrackingPage(orderId: 'o1'),
    ),
  );
  return viewModel;
}

void main() {
  testWidgets('no data yet -> spinner', (tester) async {
    await _pumpPage(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('error with no data -> message + working Retry', (tester) async {
    await _pumpPage(tester, errorMessage: 'Network down');
    expect(find.text('Network down'), findsOneWidget);

    await tester.tap(find.text(AppString.retry));
    await tester.pump();
    // Retry goes through the view model, which answers with the order.
    expect(find.text('Network down'), findsNothing);
    expect(find.text('Ahmed Mohamed'), findsOneWidget);
  });

  testWidgets('the view model feeds the screen', (tester) async {
    await _pumpPage(tester, load: true);
    expect(find.text('Ahmed Mohamed'), findsOneWidget);
    expect(find.text(AppString.trackingStepOutForDelivery), findsOneWidget);
  });

  testWidgets('with data shows driver, timeline and Show Map only', (tester) async {
    await _pumpPage(tester, tracking: trackingFixture(status: OrderStatus.preparing));
    expect(find.text('Muhamed'), findsOneWidget);
    expect(find.text('Preparing your order'), findsOneWidget);
    expect(find.text(AppString.showMap), findsOneWidget);
    expect(find.text(AppString.orderDelivered), findsNothing);
  });

  testWidgets('awaiting confirmation -> Order Delivered confirms locally', (tester) async {
    await _pumpPage(
      tester,
      tracking: trackingFixture(status: OrderStatus.awaitingDeliveryConfirmation),
    );
    expect(find.text(AppString.orderDelivered), findsOneWidget);

    await tester.tap(find.text(AppString.orderDelivered));
    await tester.pump();
    // The order moved to delivered: the button is gone and the screen says so.
    expect(find.text(AppString.orderDelivered), findsNothing);
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('confirming delivery shows the busy label', (tester) async {
    await _pumpPage(
      tester,
      tracking: trackingFixture(status: OrderStatus.awaitingDeliveryConfirmation),
      isConfirming: true,
    );
    // Text stays the same, spinner is added
    expect(find.text(AppString.orderDelivered), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('no driver accepted yet -> the waiting view is shown', (tester) async {
    await _pumpPage(tester, tracking: trackingFixture(withDriver: false));
    expect(find.byType(WaitingForDriverCard), findsOneWidget);
    expect(find.text('Muhamed'), findsNothing);
  });

  // Show Map is navigation, so the screen pushes it and hands over its own
  // view model: the map reads the same order instead of fetching a second one.
  testWidgets('Show Map opens the full-screen map on its own', (tester) async {
    tester.view.physicalSize = const Size(414, 896);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final viewModel = _TestViewModel();
    addTearDown(viewModel.close);
    await viewModel.onEvent(LoadOrderTracking('o1'));

    final router = GoRouter(
      initialLocation: AppRoutesName.trackOrder,
      routes: [
        GoRoute(
          path: AppRoutesName.trackOrder,
          builder: (_, _) => BlocProvider<OrderTrackingViewModel>.value(
            value: viewModel,
            child: const OrderTrackingPage(orderId: 'o1'),
          ),
        ),
        GoRoute(
          path: AppRoutesName.orderTrackingMapPage,
          builder: (_, state) =>
              state.extra is OrderTrackingViewModel
                  ? const Text('full-map-page')
                  : const Text('map-without-order'),
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
    // Never pumpAndSettle: the tracking sheet loops forever.
    await tester.pump();

    await tester.tap(find.text(AppString.showMap));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.text('full-map-page'), findsOneWidget);
  });
}
