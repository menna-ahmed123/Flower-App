import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/orders/domain/entities/order_details_entity.dart';

class OrderDetailsState extends Equatable {
  final BaseState<OrderDetailsEntity> orderDetailsState;

  const OrderDetailsState({this.orderDetailsState = const BaseState()});

  OrderDetailsState copyWith({BaseState<OrderDetailsEntity>? orderDetailsState}) {
    return OrderDetailsState(orderDetailsState: orderDetailsState ?? this.orderDetailsState);
  }

  @override
  List<Object?> get props => [orderDetailsState];
}
