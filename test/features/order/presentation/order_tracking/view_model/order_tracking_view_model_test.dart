import 'dart:async';

import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/order/domain/entities/delivery_confirmation_entity.dart';
import 'package:flower_app/features/order/domain/entities/order_entity.dart';
import 'package:flower_app/features/order/domain/entities/order_status.dart';
import 'package:flower_app/features/order/domain/entities/geo_point.dart';
import 'package:flower_app/features/order/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/order/domain/repos/order_repo.dart';
import 'package:flower_app/features/order/domain/use_cases/confirm_delivery_use_case.dart';
import 'package:flower_app/features/order/domain/use_cases/get_order_route_use_case.dart';
import 'package:flower_app/features/order/domain/use_cases/watch_order_tracking_use_case.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view_model/order_tracking_event.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view_model/order_tracking_ui_event.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view_model/order_tracking_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../fixtures/tracking_fixtures.dart';

/// Hands the view model a stream the test pushes values and errors into,
/// the way the repository would through the watch use case.
class _FakeOrderRepo implements OrderRepo {
  final controller = StreamController<TrackingEntity>.broadcast();

  /// What the repo answers confirmDelivery with; tests can swap in a failure.
  BaseResponse<DeliveryConfirmationEntity> confirmDeliveryResult =
      SuccessResponse(
        DeliveryConfirmationEntity(
          orderId: 'o1',
          status: OrderStatus.delivered,
          confirmedAt: DateTime.utc(2024, 9, 3, 12),
        ),
      );

  @override
  Stream<TrackingEntity> watchTracking({required String orderId}) =>
      controller.stream;

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
  }) async => confirmDeliveryResult;

  // Route fetching is the OSRM leg of the repo; the view model only needs it
  // to resolve quietly so tracking tests stay focused on the stream.
  @override
  Future<BaseResponse<List<GeoPoint>>> fetchRoute({
    required GeoPoint from,
    required GeoPoint to,
  }) async => const SuccessResponse([]);
}

class _Harness {
  _Harness() {
    repo = _FakeOrderRepo();
    addTearDown(repo.controller.close);
    viewModel = OrderTrackingViewModel(
      WatchOrderTrackingUseCase(repo),
      ConfirmDeliveryUseCase(repo),
      GetOrderRouteUseCase(repo),
    );
    addTearDown(viewModel.close);
  }

  late final _FakeOrderRepo repo;
  late final OrderTrackingViewModel viewModel;

  Future<void> emit(TrackingEntity tracking) async {
    repo.controller.add(tracking);
    await pumpEventQueue();
  }

  Future<void> fail(Object error) async {
    repo.controller.addError(error);
    await pumpEventQueue();
  }
}

void main() {
  group('WatchOrderTracking', () {
    test('starts with no data, so the screen can spin', () async {
      final harness = _Harness();

      expect(harness.viewModel.state.isLoading, isTrue);
      expect(harness.viewModel.state.tracking, isNull);
      expect(harness.viewModel.state.errorMessage, isEmpty);
    });

    test('a value on the stream fills the screen', () async {
      final harness = _Harness();

      await harness.viewModel.onEvent(WatchOrderTracking('o1'));
      await harness.emit(trackingFixture(status: OrderStatus.outForDelivery));

      expect(
        harness.viewModel.state.tracking?.status,
        OrderStatus.outForDelivery,
      );
      expect(harness.viewModel.state.isLoading, isFalse);
    });

    test('later values keep replacing the state', () async {
      final harness = _Harness();

      await harness.viewModel.onEvent(WatchOrderTracking('o1'));
      await harness.emit(trackingFixture(status: OrderStatus.preparing));
      await harness.emit(trackingFixture(status: OrderStatus.outForDelivery));

      expect(
        harness.viewModel.state.tracking?.status,
        OrderStatus.outForDelivery,
      );
    });

    test('a stream error leaves a message to retry from', () async {
      final harness = _Harness();

      await harness.viewModel.onEvent(WatchOrderTracking('o1'));
      await harness.fail(BadResponseError('Network down'));

      expect(harness.viewModel.state.tracking, isNull);
      expect(harness.viewModel.state.errorMessage, 'Network down');
    });

    test('a failure after data keeps what the customer sees', () async {
      final harness = _Harness();

      await harness.viewModel.onEvent(WatchOrderTracking('o1'));
      await harness.emit(trackingFixture(status: OrderStatus.outForDelivery));
      final stale = harness.viewModel.state.tracking;

      await harness.fail(BadResponseError('Network down'));

      expect(harness.viewModel.state.tracking, stale);
      expect(harness.viewModel.state.errorMessage, 'Network down');
    });

    test('re-watching replaces the stream being listened to', () async {
      final harness = _Harness();

      await harness.viewModel.onEvent(WatchOrderTracking('o1'));
      await harness.viewModel.onEvent(WatchOrderTracking('o1'));
      await harness.emit(trackingFixture(status: OrderStatus.outForDelivery));

      // One listener kept: the value arrives exactly once without piling up.
      expect(harness.repo.controller.hasListener, isTrue);
      expect(
        harness.viewModel.state.tracking?.status,
        OrderStatus.outForDelivery,
      );
    });

    test('a finished order closes the watch', () async {
      final harness = _Harness();

      await harness.viewModel.onEvent(WatchOrderTracking('o1'));
      await harness.emit(trackingFixture(status: OrderStatus.delivered));

      expect(harness.repo.controller.hasListener, isFalse);
      expect(harness.viewModel.state.tracking?.status, OrderStatus.delivered);
    });

    test('StopWatchingOrderTracking ends the listening', () async {
      final harness = _Harness();

      await harness.viewModel.onEvent(WatchOrderTracking('o1'));
      await harness.viewModel.onEvent(StopWatchingOrderTracking());

      await harness.emit(trackingFixture(status: OrderStatus.outForDelivery));

      expect(harness.viewModel.state.tracking, isNull);
    });

    test('LoadOrderTracking watches the same way', () async {
      final harness = _Harness();

      await harness.viewModel.onEvent(LoadOrderTracking('o1'));
      await harness.emit(trackingFixture(status: OrderStatus.outForDelivery));

      expect(
        harness.viewModel.state.tracking?.status,
        OrderStatus.outForDelivery,
      );
    });

    test('a missing order id fails instead of hanging', () async {
      final harness = _Harness();

      await harness.viewModel.onEvent(WatchOrderTracking(null));

      expect(harness.viewModel.state.tracking, isNull);
      expect(harness.viewModel.state.errorMessage, isNotEmpty);
      expect(harness.repo.controller.hasListener, isFalse);
    });
  });

  group('ConfirmOrderDelivered', () {
    Future<_Harness> loadAwaitingConfirmation() async {
      final harness = _Harness();
      await harness.viewModel.onEvent(WatchOrderTracking('o1'));
      await harness.emit(
        trackingFixture(status: OrderStatus.awaitingDeliveryConfirmation),
      );
      return harness;
    }

    test('moves the order to delivered and closes the timeline', () async {
      final harness = await loadAwaitingConfirmation();

      await harness.viewModel.onEvent(ConfirmOrderDelivered());

      final confirmed = harness.viewModel.state.tracking!;
      expect(confirmed.status, OrderStatus.delivered);
      expect(confirmed.timeline.last.status, OrderStatus.delivered);
      expect(confirmed.timeline.last.isCompleted, isTrue);
      // The server's confirmation time wins over a locally made-up one.
      expect(confirmed.timeline.last.occurredAt, DateTime.utc(2024, 9, 3, 12));
      // The button is gone with it.
      expect(confirmed.canConfirmDelivery, isFalse);
      expect(harness.viewModel.state.isConfirmingDelivery, isFalse);
    });

    test('announces itself once as a ui event', () async {
      final harness = await loadAwaitingConfirmation();
      final effects = <OrderTrackingUiEvent>[];
      harness.viewModel.uiEvents.listen(effects.add);

      await harness.viewModel.onEvent(ConfirmOrderDelivered());
      await pumpEventQueue();

      expect(effects, [const ShowTrackingMessage(AppString.statusDelivered)]);
    });

    test('a status that is not waiting for the customer ignores it', () async {
      final harness = _Harness();
      await harness.viewModel.onEvent(WatchOrderTracking('o1'));
      await harness.emit(trackingFixture(status: OrderStatus.preparing));
      final effects = <OrderTrackingUiEvent>[];
      harness.viewModel.uiEvents.listen(effects.add);

      await harness.viewModel.onEvent(ConfirmOrderDelivered());
      await pumpEventQueue();

      expect(harness.viewModel.state.tracking?.status, OrderStatus.preparing);
      expect(effects, isEmpty);
    });

    test('nothing to confirm while the order has not loaded', () async {
      final harness = _Harness();

      await harness.viewModel.onEvent(ConfirmOrderDelivered());

      expect(harness.viewModel.state.tracking, isNull);
      expect(harness.viewModel.state.isConfirmingDelivery, isFalse);
    });

    test('a failing confirm keeps the order and announces the error', () async {
      final harness = await loadAwaitingConfirmation();
      harness.repo.confirmDeliveryResult = ErrorResponse(
        appError: BadResponseError('Backend said no'),
      );
      final effects = <OrderTrackingUiEvent>[];
      harness.viewModel.uiEvents.listen(effects.add);

      await harness.viewModel.onEvent(ConfirmOrderDelivered());
      await pumpEventQueue();

      expect(harness.viewModel.state.tracking?.status,
          OrderStatus.awaitingDeliveryConfirmation);
      expect(harness.viewModel.state.isConfirmingDelivery, isFalse);
      expect(effects, [const ShowTrackingMessage('Backend said no')]);
    });
  });

  group('OrderDetailsRequested', () {
    test('announces a navigate-back ui event', () async {
      final harness = _Harness();
      final effects = <OrderTrackingUiEvent>[];
      harness.viewModel.uiEvents.listen(effects.add);

      await harness.viewModel.onEvent(OrderDetailsRequested());
      await pumpEventQueue();

      expect(effects, [const TrackingNavigateBack()]);
    });
  });
}
