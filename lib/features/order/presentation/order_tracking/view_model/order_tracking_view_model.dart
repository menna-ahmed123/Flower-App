import 'dart:async';

import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/core/base/ui_event_cubit.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/order/domain/entities/timeline_step_entity.dart';
import 'package:flower_app/features/order/domain/entities/tracking_entity.dart';
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

  StreamSubscription<TrackingEntity>? _subscription;
  bool _routeLoaded = false;

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
    _subscription = _watchOrderTracking(orderId: orderId).listen(
      _onTracking,
      onError: _onFailure,
    );
  }

  void _onTracking(TrackingEntity tracking) {
    emit(
      state.copyWith(
        trackingState: BaseState<TrackingEntity>(data: tracking),
      ),
    );
    unawaited(_loadRoute(tracking));
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
    if (result case SuccessResponse(:final data) when data.isNotEmpty) {
      emit(state.copyWith(routePoints: data));
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

    if (result case SuccessResponse(:final data)) {
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
    } else if (result case ErrorResponse(:final appError)) {
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
