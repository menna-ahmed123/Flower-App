import 'dart:async';

import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/core/base/ui_event_cubit.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/order/domain/entities/order_status.dart';
import 'package:flower_app/features/order/domain/entities/timeline_step_entity.dart';
import 'package:flower_app/features/order/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/mock/order_tracking_mock_data.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view_model/order_tracking_event.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view_model/order_tracking_state.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view_model/order_tracking_ui_event.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class OrderTrackingViewModel
    extends UiEventCubit<OrderTrackingState, OrderTrackingUiEvent> {
  OrderTrackingViewModel()
    : super(
        const OrderTrackingState(trackingState: BaseState(isLoading: true)),
      );

  static const _pollEvery = Duration(seconds: 5);

  Timer? _polling;
  String? _orderId;

  Future<void> onEvent(OrderTrackingEvent event) async {
    switch (event) {
      case LoadOrderTracking(:final orderId):
        await _load(orderId);

      case WatchOrderTracking(:final orderId):
        _orderId = orderId;
        await _load(orderId);
        _watchWhileOpen();

      case StopWatchingOrderTracking():
        _polling?.cancel();

      case ConfirmOrderDelivered():
        await _confirmDelivery();
    }
  }

  Future<void> _load(String? orderId) async {
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

    final TrackingEntity? tracking = await fetchTracking(orderId);

    if (tracking == null) {
      emit(
        state.copyWith(
          trackingState: BaseState<TrackingEntity>(
            errorMessage: state.errorMessage.isEmpty
                ? AppString.unknown
                : state.errorMessage,
            data: state.tracking,
          ),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        trackingState: BaseState<TrackingEntity>(data: tracking),
        routePoints: OrderTrackingMockData.routePoints,
      ),
    );
  }

  void _watchWhileOpen() {
    _polling?.cancel();
    if (state.tracking?.isFinished ?? false) return;
    _polling = Timer.periodic(_pollEvery, (_) => _load(_orderId));
  }

  Future<void> _confirmDelivery() async {
    final TrackingEntity? current = state.tracking;
    if (current == null || !current.canConfirmDelivery) return;

    emit(state.copyWith(isConfirmingDelivery: true));

    final confirmed = current.copyWith(
      status: OrderStatus.delivered,
      timeline: [
        ...current.timeline,
        TimelineStepEntity(
          status: OrderStatus.delivered,
          isCompleted: true,
          isCurrent: false,
          occurredAt: DateTime.now().toUtc(),
        ),
      ],
    );

    emit(
      state.copyWith(
        isConfirmingDelivery: false,
        trackingState: BaseState<TrackingEntity>(data: confirmed),
      ),
    );
    _polling?.cancel();
    emitUiEvent(const ShowTrackingMessage(AppString.statusDelivered));
  }

  Future<TrackingEntity?> fetchTracking(String? orderId) async =>
      OrderTrackingMockData.tracking;

  @override
  Future<void> close() {
    _polling?.cancel();
    return super.close();
  }
}
