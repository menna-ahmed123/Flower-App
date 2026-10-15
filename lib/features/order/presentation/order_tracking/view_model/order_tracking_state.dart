import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/order/domain/entities/geo_point.dart';
import 'package:flower_app/features/order/domain/entities/tracking_entity.dart';

class OrderTrackingState extends Equatable {
  const OrderTrackingState({
    this.trackingState = const BaseState(),
    this.routePoints = const [],
    this.isConfirmingDelivery = false,
  });

  final BaseState<TrackingEntity> trackingState;

  final List<GeoPoint> routePoints;

  final bool isConfirmingDelivery;

  TrackingEntity? get tracking => trackingState.data;

  bool get isLoading => trackingState.isLoading;

  String get errorMessage => trackingState.errorMessage;

  OrderTrackingState copyWith({
    BaseState<TrackingEntity>? trackingState,
    List<GeoPoint>? routePoints,
    bool? isConfirmingDelivery,
  }) {
    return OrderTrackingState(
      trackingState: trackingState ?? this.trackingState,
      routePoints: routePoints ?? this.routePoints,
      isConfirmingDelivery: isConfirmingDelivery ?? this.isConfirmingDelivery,
    );
  }

  @override
  List<Object?> get props => [trackingState, routePoints, isConfirmingDelivery];
}
