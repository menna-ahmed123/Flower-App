import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/orders/domain/entities/order_summary_entity.dart';

class OrdersListState extends Equatable {
  final BaseState<List<OrderSummaryEntity>> ordersState;

  const OrdersListState({this.ordersState = const BaseState()});

  OrdersListState copyWith({BaseState<List<OrderSummaryEntity>>? ordersState}) {
    return OrdersListState(ordersState: ordersState ?? this.ordersState);
  }

  @override
  List<Object?> get props => [ordersState];
}
