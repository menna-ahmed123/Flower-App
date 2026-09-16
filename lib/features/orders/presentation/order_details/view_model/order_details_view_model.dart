import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/orders/domain/entities/order_details_entity.dart';
import 'package:flower_app/features/orders/domain/use_cases/get_order_details_use_case.dart';
import 'package:flower_app/features/orders/presentation/order_details/view_model/order_details_event.dart';
import 'package:flower_app/features/orders/presentation/order_details/view_model/order_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class OrderDetailsViewModel extends Cubit<OrderDetailsState> {
  final GetOrderDetailsUseCase getOrderDetailsUseCase;

  OrderDetailsViewModel(this.getOrderDetailsUseCase) : super(const OrderDetailsState());

  void doEvent(OrderDetailsEvent event) {
    switch (event) {
      case OrderDetailsRequested(:final orderId):
        _getOrderDetails(orderId);
        break;
    }
  }

  Future<void> _getOrderDetails(String orderId) async {
    emit(state.copyWith(orderDetailsState: state.orderDetailsState.copyWith(isLoading: true, errorMessage: '')));
    final response = await getOrderDetailsUseCase(orderId);
    switch (response) {
      case SuccessResponse<OrderDetailsEntity>():
        emit(state.copyWith(orderDetailsState: state.orderDetailsState.copyWith(isLoading: false, data: response.data, errorMessage: '')));
        break;
      case ErrorResponse():
        emit(state.copyWith(orderDetailsState: state.orderDetailsState.copyWith(isLoading: false, errorMessage: response.errorMessage)));
        break;
    }
  }
}
