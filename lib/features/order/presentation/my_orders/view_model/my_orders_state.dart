import 'package:equatable/equatable.dart';
import 'package:flower_app/core/utils/pagination/pagination_state.dart';

import '../../../domain/entities/order_entity.dart';
import '../view/models/my_orders_tab.dart';

class MyOrdersState extends Equatable {
  const MyOrdersState({
    this.selectedTab = MyOrdersTab.active,
    this.pagination = const PaginationState<OrderEntity>(),
    this.orders = const <OrderEntity>[],
  });

  final MyOrdersTab selectedTab;
  final PaginationState<OrderEntity> pagination;
  final List<OrderEntity> orders;

  PaginationStatus get status => pagination.status;
  bool get hasMore => pagination.hasMore;
  String? get errorMessage => pagination.errorMessage;

  bool get isInitialLoading =>
      pagination.items.isEmpty &&
      (status == PaginationStatus.initial ||
          status == PaginationStatus.loading);

  bool get isInitialError =>
      pagination.items.isEmpty && status == PaginationStatus.error;

  bool get showLoadMore =>
      hasMore &&
      !isInitialLoading &&
      !isInitialError &&
      status != PaginationStatus.loadingMore;

  MyOrdersState copyWith({
    MyOrdersTab? selectedTab,
    PaginationState<OrderEntity>? pagination,
    List<OrderEntity>? orders,
  }) {
    return MyOrdersState(
      selectedTab: selectedTab ?? this.selectedTab,
      pagination: pagination ?? this.pagination,
      orders: orders ?? this.orders,
    );
  }

  @override
  List<Object?> get props => [selectedTab, pagination, orders];
}
