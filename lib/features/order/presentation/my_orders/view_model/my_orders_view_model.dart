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
  final GetAllOrdersUseCase getAllOrdersUseCase;

  late final PaginationController<OrderEntity> ordersPaginationController;

  bool _isAutoFilling = false;
  bool get isAutoFilling => _isAutoFilling;

  MyOrdersViewModel(this.getAllOrdersUseCase)
    : super(const MyOrdersState(selectedTab: MyOrdersTab.active)) {
    ordersPaginationController = PaginationController<OrderEntity>(
      pageSize: 10,
      fetchPage: _fetchOrdersPage,
    );
  }

  Future<void> onEvent(MyOrdersEvent event) async {
    switch (event) {
      case LoadMyOrders():
        ordersPaginationController.reset();
        await ordersPaginationController.loadNextPage();
        await ensureTabHasContent(state.selectedTab);
      case SwitchTab(:final tab):
        _switchTab(tab);
        await ensureTabHasContent(tab);
      case TrackOrder(:final orderId):
        emitUiEvent(TrackMyOrder(orderId: orderId));
    }
  }

  Future<void> ensureTabHasContent(MyOrdersTab tab) async {
    _isAutoFilling = true;
    try {
      while (ordersPaginationController.state.status ==
              PaginationStatus.success &&
          ordersPaginationController.state.hasMore &&
          ordersForTab(tab).isEmpty) {
        await ordersPaginationController.loadNextPage();
      }
    } finally {
      _isAutoFilling = false;
    }
  }

  List<OrderEntity> ordersForTab(MyOrdersTab tab) {
    final orders = ordersPaginationController.state.items;
    return tab == MyOrdersTab.active
        ? getAllOrdersUseCase.activeOrders(orders)
        : getAllOrdersUseCase.completedOrders(orders);
  }

  void _switchTab(MyOrdersTab tab) {
    emit(state.copyWith(selectedTab: tab));
  }

  Future<List<OrderEntity>> _fetchOrdersPage(int page, int pageSize) async {
    final response = await getAllOrdersUseCase(page: page, pageSize: pageSize);

    switch (response) {
      case SuccessResponse<List<OrderEntity>>():
        return response.data;
      case ErrorResponse<List<OrderEntity>>() :
        throw AppFailure(response.appError);
    }
  }

  @override
  Future<void> close() {
    ordersPaginationController.dispose();
    return super.close();
  }
}
