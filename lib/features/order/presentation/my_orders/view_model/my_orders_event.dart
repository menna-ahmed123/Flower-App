
import 'package:equatable/equatable.dart';

import '../view/models/my_orders_tab.dart';

sealed class MyOrdersEvent extends Equatable {}

class LoadMyOrders extends MyOrdersEvent {
  @override
  List<Object?> get props => [];
}
class SwitchTab extends MyOrdersEvent {
  final MyOrdersTab tab;
  SwitchTab(this.tab);

  @override
  List<Object?> get props => [tab];
}

class TrackOrder extends MyOrdersEvent {
  final String orderId;
  TrackOrder(this.orderId);

  @override
  List<Object?> get props => [orderId];
}
