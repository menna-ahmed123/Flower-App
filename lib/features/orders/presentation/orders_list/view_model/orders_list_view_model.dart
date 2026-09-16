import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/orders/domain/entities/order_summary_entity.dart';
import 'package:flower_app/features/orders/domain/use_cases/get_orders_use_case.dart';
import 'package:flower_app/features/orders/presentation/orders_list/view_model/orders_list_event.dart';
import 'package:flower_app/features/orders/presentation/orders_list/view_model/orders_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class OrdersListViewModel extends Cubit<OrdersListState> {
  final GetOrdersUseCase getOrdersUseCase;

  OrdersListViewModel(this.getOrdersUseCase) : super(const OrdersListState());

  void doEvent(OrdersListEvent event) {
    switch (event) {
      case OrdersRequested():
        _getOrders();
        break;
    }
  }

  Future<void> _getOrders() async {
    emit(state.copyWith(ordersState: state.ordersState.copyWith(isLoading: true, errorMessage: '')));
    final response = await getOrdersUseCase();
    switch (response) {
      case SuccessResponse<List<OrderSummaryEntity>>():
        emit(state.copyWith(ordersState: state.ordersState.copyWith(isLoading: false, data: response.data, errorMessage: '')));
        break;
      case ErrorResponse():
        emit(state.copyWith(ordersState: state.ordersState.copyWith(isLoading: false, errorMessage: response.errorMessage)));
        break;
    }
  }
}
