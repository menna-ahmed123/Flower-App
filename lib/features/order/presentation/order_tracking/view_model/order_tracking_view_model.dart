import 'dart:async';

import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/core/base/ui_event_cubit.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/order/domain/entities/geo_point.dart';
import 'package:flower_app/features/order/domain/entities/timeline_step_entity.dart';
import 'package:flower_app/features/order/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/order/domain/utils/geo_math.dart';
import 'package:flower_app/features/order/domain/use_cases/confirm_delivery_use_case.dart';
import 'package:flower_app/features/order/domain/use_cases/get_order_route_use_case.dart';
import 'package:flower_app/features/order/domain/use_cases/watch_order_tracking_use_case.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view_model/order_tracking_event.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view_model/order_tracking_state.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view_model/order_tracking_ui_event.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class OrderTrackingViewModel
    extends UiEventCubit<OrderTrackingState, OrderTrackingUiEvent> {
  OrderTrackingViewModel(
    this._watchOrderTracking,
    this._confirmDeliveryUseCase,
    this._getOrderRoute,
  ) : super(
        const OrderTrackingState(trackingState: BaseState(isLoading: true)),
      );

  final WatchOrderTrackingUseCase _watchOrderTracking;
  final ConfirmDeliveryUseCase _confirmDeliveryUseCase;
  final GetOrderRouteUseCase _getOrderRoute;

  StreamSubscription<BaseResponse<TrackingEntity>>? _subscription;
  bool _routeLoaded = false;
  int _offRouteStreak = 0;

  static const double _offRouteMeters = 50;
  static const int _offRouteUpdatesBeforeRefetch = 2;

  Future<void> onEvent(OrderTrackingEvent event) async {
    switch (event) {
      case LoadOrderTracking(:final orderId):
      case WatchOrderTracking(:final orderId):
        await _watch(orderId);

      case StopWatchingOrderTracking():
        await _cancelWatch();

      case ConfirmOrderDelivered():
        await _confirmDelivery();

      case OrderDetailsRequested():
        emitUiEvent(const TrackingNavigateBack());
    }
  }

  Future<void> _watch(String? orderId) async {
    if (orderId == null || orderId.isEmpty) {
      _emitFailure();
      return;
    }

    if (state.tracking == null) {
      emit(
        state.copyWith(
          trackingState: state.trackingState.copyWith(
            isLoading: true,
            errorMessage: '',
          ),
        ),
      );
    }

    await _cancelWatch();
    _routeLoaded = false;
    _offRouteStreak = 0;
    _subscription = _watchOrderTracking(orderId: orderId).listen(
      _onResponse,
      // Safety net only: the repository reports failures as data events,
      // so anything landing here is unexpected and gets a generic message.
      onError: _onFailure,
    );
  }

  void _onResponse(BaseResponse<TrackingEntity> response) {
    switch (response) {
      case SuccessResponse(:final data):
        _onTracking(data);
      case ErrorResponse(:final appError):
        _emitFailure(message: appError.message);
    }
  }

  void _onTracking(TrackingEntity tracking) {
    emit(
      state.copyWith(
        trackingState: BaseState<TrackingEntity>(data: tracking),
      ),
    );
    unawaited(_loadRoute(tracking));
    _checkRouteDeviation(tracking);
    if (tracking.isFinished) {
      unawaited(_cancelWatch());
    }
  }

  Future<void> _loadRoute(TrackingEntity tracking) async {
    if (_routeLoaded) return;
    final from = tracking.storeLocation;
    final to = tracking.destination;
    if (from == null || to == null) return;

    _routeLoaded = true;
    final result = await _getOrderRoute(from: from, to: to);
    if (isClosed) return;
    switch (result) {
      case SuccessResponse(:final data) when data.isNotEmpty:
        emit(state.copyWith(routePoints: data));
      case SuccessResponse():
        break;
      case ErrorResponse():
        break;
    }
  }

  /// The route is fetched once, but the driver may not follow it. When the
  /// last known position stays further than [_offRouteMeters] from the line
  /// for a couple of updates in a row, redraw the route from where the
  /// driver actually is.
  void _checkRouteDeviation(TrackingEntity tracking) {
    final location = tracking.driverLocation;
    final route = state.routePoints;
    if (location == null || location.isStale || route.length < 2) return;

    final offRoute =
        distanceToPolylineMeters(location.point, route) > _offRouteMeters;
    _offRouteStreak = offRoute ? _offRouteStreak + 1 : 0;
    if (_offRouteStreak < _offRouteUpdatesBeforeRefetch) return;

    _offRouteStreak = 0;
    final to = tracking.destination;
    if (to != null) {
      unawaited(_refetchRoute(from: location.point, to: to));
    }
  }

  Future<void> _refetchRoute({
    required GeoPoint from,
    required GeoPoint to,
  }) async {
    final result = await _getOrderRoute(from: from, to: to);
    if (isClosed) return;
    switch (result) {
      case SuccessResponse(:final data) when data.isNotEmpty:
        emit(state.copyWith(routePoints: data));
      case SuccessResponse():
        break;
      case ErrorResponse():
        // Keep the stale line: it beats an empty map.
        break;
    }
  }

  void _onFailure(Object error, StackTrace stackTrace) {
    _emitFailure(message: _resolveMessage(error));
  }

  void _emitFailure({String? message}) {
    emit(
      state.copyWith(
        trackingState: BaseState<TrackingEntity>(
          errorMessage:
              message ??
              (state.errorMessage.isEmpty ? AppString.unknown : state.errorMessage),
          data: state.tracking,
        ),
      ),
    );
  }

  String _resolveMessage(Object error) {
    if (error is AppError) return error.message;
    if (error is AppFailure) return error.message;
    return AppString.unknown;
  }

  Future<void> _cancelWatch() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  Future<void> _confirmDelivery() async {
    final TrackingEntity? current = state.tracking;
    if (current == null || !current.canConfirmDelivery) return;

    emit(state.copyWith(isConfirmingDelivery: true));

    final result = await _confirmDeliveryUseCase(orderId: current.orderId);

    switch (result) {
      case SuccessResponse(:final data):
        final confirmed = current.copyWith(
          status: data.status,
          timeline: [
            ...current.timeline,
            TimelineStepEntity(
              status: data.status,
              isCompleted: true,
              isCurrent: false,
              occurredAt: data.confirmedAt ?? DateTime.now().toUtc(),
            ),
          ],
        );

        await _cancelWatch();
        emit(
          state.copyWith(
            isConfirmingDelivery: false,
            trackingState: BaseState<TrackingEntity>(data: confirmed),
          ),
        );
        emitUiEvent(const ShowTrackingMessage(AppString.statusDelivered));
      case ErrorResponse(:final appError):
        emit(state.copyWith(isConfirmingDelivery: false));
        emitUiEvent(ShowTrackingMessage(appError.message));
    }
  }

  @override
  Future<void> close() {
    unawaited(_cancelWatch());
    return super.close();
  }
}
