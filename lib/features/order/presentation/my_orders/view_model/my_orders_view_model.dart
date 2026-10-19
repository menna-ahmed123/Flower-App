import 'package:flower_app/core/base/ui_event_cubit.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/core/utils/pagination/pagination_controller.dart';
import 'package:flower_app/core/utils/pagination/pagination_state.dart';
import 'package:flower_app/features/order/presentation/my_orders/view_model/my_orders_event.dart';
import 'package:flower_app/features/order/presentation/my_orders/view_model/my_orders_state.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/base/base_response.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../domain/use_cases/get_all_orders_use_case.dart';
import '../view/models/my_orders_tab.dart';
import 'my_orders_ui_event.dart';

@Injectable()
class MyOrdersViewModel extends UiEventCubit<MyOrdersState, MyOrdersUiEvent> {
  final GetAllOrdersUseCase _getAllOrdersUseCase;

  late final PaginationController<OrderEntity> _controller;

  MyOrdersViewModel(this._getAllOrdersUseCase) : super(const MyOrdersState()) {
    _controller = PaginationController<OrderEntity>(
      pageSize: 10,
      fetchPage: _fetchOrdersPage,
    )..addListener(_onPaginationChanged);
  }

  Future<void> onEvent(MyOrdersEvent event) async {
    switch (event) {
      case LoadMyOrders():
        _controller.reset();
        await _controller.loadNextPage();
        _emitForTab(state.selectedTab);
      case SwitchTab(:final tab):
        _emitForTab(tab);
      case LoadMoreOrders():
        await _loadMore();
      case TrackOrder(:final orderId):
        emitUiEvent(TrackMyOrder(orderId: orderId));
    }
  }

  Future<void> _loadMore() async {
    if (!_controller.state.hasMore) return;
    final status = _controller.state.status;
    if (status == PaginationStatus.loading ||
        status == PaginationStatus.loadingMore) {
      return;
    }
    await _controller.loadNextPage();
    _emitForTab(state.selectedTab);
  }

  void _onPaginationChanged() {
    if (isClosed) return;
    _emitForTab(state.selectedTab);
  }

  void _emitForTab(MyOrdersTab tab) {
    emit(
      state.copyWith(
        selectedTab: tab,
        pagination: _controller.state,
        orders: _visibleOrders(tab),
      ),
    );
  }

  List<OrderEntity> _visibleOrders(MyOrdersTab tab) {
    final items = _controller.state.items;
    return tab == MyOrdersTab.active
        ? _getAllOrdersUseCase.activeOrders(items)
        : _getAllOrdersUseCase.completedOrders(items);
  }

  Future<List<OrderEntity>> _fetchOrdersPage(int page, int pageSize) async {
    final response = await _getAllOrdersUseCase(page: page, pageSize: pageSize);

    switch (response) {
      case SuccessResponse<List<OrderEntity>>():
        return response.data;
      case ErrorResponse<List<OrderEntity>>():
        throw AppFailure(response.appError);
    }
  }

  @override
  Future<void> close() {
    _controller
      ..removeListener(_onPaginationChanged)
      ..dispose();
    return super.close();
  }
}
