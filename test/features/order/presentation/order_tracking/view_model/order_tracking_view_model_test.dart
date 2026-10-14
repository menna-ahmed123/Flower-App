import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/order/domain/entities/order_status.dart';
import 'package:flower_app/features/order/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view_model/order_tracking_event.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view_model/order_tracking_ui_event.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view_model/order_tracking_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../fixtures/tracking_fixtures.dart';

/// Answers from a fixture instead of the mock, and counts how many times the
/// screen asked for data — that count is how the polling is observed.
class _ScriptedViewModel extends OrderTrackingViewModel {
  _ScriptedViewModel({this.response, this.fail = false});

  TrackingEntity? response;
  bool fail;
  int calls = 0;

  @override
  Future<TrackingEntity?> fetchTracking(String? orderId) async {
    calls++;
    return fail ? null : response;
  }
}

void main() {
  group('LoadOrderTracking', () {
    testWidgets('starts with no data, so the screen can spin', (tester) async {
      final viewModel = _ScriptedViewModel();
      addTearDown(viewModel.close);

      expect(viewModel.state.isLoading, isTrue);
      expect(viewModel.state.tracking, isNull);
      expect(viewModel.state.errorMessage, isEmpty);
    });

    testWidgets('fills the order and the route the map drives', (tester) async {
      final viewModel = _ScriptedViewModel(
        response: trackingFixture(status: OrderStatus.outForDelivery),
      );
      addTearDown(viewModel.close);

      await viewModel.onEvent(LoadOrderTracking('o1'));

      expect(viewModel.state.tracking?.status, OrderStatus.outForDelivery);
      expect(viewModel.state.routePoints, isNotEmpty);
      expect(viewModel.state.isLoading, isFalse);
    });

    testWidgets('a failing source leaves a message to retry from', (tester) async {
      final viewModel = _ScriptedViewModel(fail: true);
      addTearDown(viewModel.close);

      await viewModel.onEvent(LoadOrderTracking('o1'));

      expect(viewModel.state.tracking, isNull);
      expect(viewModel.state.errorMessage, isNotEmpty);
    });

    testWidgets('a failed refresh keeps what the customer already sees', (
      tester,
    ) async {
      final viewModel = _ScriptedViewModel(
        response: trackingFixture(status: OrderStatus.outForDelivery),
      );
      addTearDown(viewModel.close);
      await viewModel.onEvent(LoadOrderTracking('o1'));

      // The next read breaks: the order stays on screen, the error is recorded.
      viewModel.fail = true;
      final stale = viewModel.state.tracking;
      await viewModel.onEvent(LoadOrderTracking('o1'));

      expect(viewModel.state.tracking, stale);
      expect(viewModel.state.errorMessage, isNotEmpty);
    });

    testWidgets('reload over data does not blank the screen', (tester) async {
      final viewModel = _ScriptedViewModel(
        response: trackingFixture(status: OrderStatus.outForDelivery),
      );
      addTearDown(viewModel.close);
      await viewModel.onEvent(LoadOrderTracking('o1'));
      final callsBeforeReload = viewModel.calls;

      await viewModel.onEvent(LoadOrderTracking('o1'));

      expect(viewModel.calls, greaterThan(callsBeforeReload));
      expect(viewModel.state.isLoading, isFalse);
    });
  });

  group('WatchOrderTracking', () {
    testWidgets('loads once and keeps asking while the order is on its way', (
      tester,
    ) async {
      final viewModel = _ScriptedViewModel(
        response: trackingFixture(status: OrderStatus.outForDelivery),
      );
      addTearDown(viewModel.close);

      await viewModel.onEvent(WatchOrderTracking('o1'));
      expect(viewModel.calls, 1);

      await tester.pump(const Duration(seconds: 5));
      expect(viewModel.calls, 2);
      await tester.pump(const Duration(seconds: 5));
      expect(viewModel.calls, 3);

      // Leave no timer behind: the binding checks that when the test ends.
      await viewModel.onEvent(StopWatchingOrderTracking());
    });

    testWidgets('a finished order is not polled', (tester) async {
      final viewModel = _ScriptedViewModel(
        response: trackingFixture(status: OrderStatus.delivered),
      );
      addTearDown(viewModel.close);

      await viewModel.onEvent(WatchOrderTracking('o1'));
      await tester.pump(const Duration(seconds: 30));

      expect(viewModel.calls, 1);
    });

    testWidgets('StopWatchingOrderTracking ends the polling', (tester) async {
      final viewModel = _ScriptedViewModel(
        response: trackingFixture(status: OrderStatus.outForDelivery),
      );
      addTearDown(viewModel.close);

      await viewModel.onEvent(WatchOrderTracking('o1'));
      await viewModel.onEvent(StopWatchingOrderTracking());
      await tester.pump(const Duration(seconds: 30));

      expect(viewModel.calls, 1);
    });
  });

  group('ConfirmOrderDelivered', () {
    testWidgets('moves the order to delivered and closes the timeline', (
      tester,
    ) async {
      final viewModel = _ScriptedViewModel(
        response: trackingFixture(status: OrderStatus.awaitingDeliveryConfirmation),
      );
      addTearDown(viewModel.close);
      await viewModel.onEvent(LoadOrderTracking('o1'));

      await viewModel.onEvent(ConfirmOrderDelivered());

      final confirmed = viewModel.state.tracking!;
      expect(confirmed.status, OrderStatus.delivered);
      expect(confirmed.timeline.last.status, OrderStatus.delivered);
      expect(confirmed.timeline.last.isCompleted, isTrue);
      // The button is gone with it.
      expect(confirmed.canConfirmDelivery, isFalse);
      expect(viewModel.state.isConfirmingDelivery, isFalse);
    });

    testWidgets('announces itself once as a ui event', (tester) async {
      final viewModel = _ScriptedViewModel(
        response: trackingFixture(status: OrderStatus.awaitingDeliveryConfirmation),
      );
      addTearDown(viewModel.close);
      final effects = <OrderTrackingUiEvent>[];
      viewModel.uiEvents.listen(effects.add);
      await viewModel.onEvent(LoadOrderTracking('o1'));

      await viewModel.onEvent(ConfirmOrderDelivered());
      await tester.pump();

      expect(effects, [const ShowTrackingMessage(AppString.statusDelivered)]);
    });

    testWidgets('stops the polling', (tester) async {
      final viewModel = _ScriptedViewModel(
        response: trackingFixture(status: OrderStatus.awaitingDeliveryConfirmation),
      );
      addTearDown(viewModel.close);

      await viewModel.onEvent(WatchOrderTracking('o1'));
      await viewModel.onEvent(ConfirmOrderDelivered());
      await tester.pump(const Duration(seconds: 30));

      expect(viewModel.calls, 1);
    });

    testWidgets('a status that is not waiting for the customer ignores it', (
      tester,
    ) async {
      final viewModel = _ScriptedViewModel(
        response: trackingFixture(status: OrderStatus.preparing),
      );
      addTearDown(viewModel.close);
      final effects = <OrderTrackingUiEvent>[];
      viewModel.uiEvents.listen(effects.add);

      await viewModel.onEvent(LoadOrderTracking('o1'));
      await viewModel.onEvent(ConfirmOrderDelivered());
      await tester.pump();

      expect(viewModel.state.tracking?.status, OrderStatus.preparing);
      expect(effects, isEmpty);
    });

    testWidgets('nothing to confirm while the order has not loaded', (
      tester,
    ) async {
      final viewModel = _ScriptedViewModel(fail: true);
      addTearDown(viewModel.close);

      await viewModel.onEvent(ConfirmOrderDelivered());

      expect(viewModel.state.tracking, isNull);
      expect(viewModel.state.isConfirmingDelivery, isFalse);
    });
  });
}
