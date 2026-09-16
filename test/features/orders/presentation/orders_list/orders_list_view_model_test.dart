import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/orders/domain/entities/order_status.dart';
import 'package:flower_app/features/orders/domain/entities/order_summary_entity.dart';
import 'package:flower_app/features/orders/domain/use_cases/get_orders_use_case.dart';
import 'package:flower_app/features/orders/presentation/orders_list/view_model/orders_list_event.dart';
import 'package:flower_app/features/orders/presentation/orders_list/view_model/orders_list_state.dart';
import 'package:flower_app/features/orders/presentation/orders_list/view_model/orders_list_view_model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'orders_list_view_model_test.mocks.dart';

@GenerateMocks([GetOrdersUseCase])
void main() {
  provideDummy<BaseResponse<List<OrderSummaryEntity>>>(const SuccessResponse<List<OrderSummaryEntity>>([]));

  late MockGetOrdersUseCase getOrdersUseCase;

  final orders = [
    const OrderSummaryEntity(id: '1', orderNumber: 'FL-1', status: OrderStatus.placed, totalPrice: 100),
  ];

  setUp(() {
    getOrdersUseCase = MockGetOrdersUseCase();
  });

  group('OrdersListViewModel', () {
    blocTest<OrdersListViewModel, OrdersListState>(
      'emits loading then success state when orders load successfully',
      setUp: () {
        when(getOrdersUseCase.call()).thenAnswer((_) async => SuccessResponse(orders));
      },
      build: () => OrdersListViewModel(getOrdersUseCase),
      act: (viewModel) => viewModel.doEvent(OrdersRequested()),
      expect: () => [
        const OrdersListState(ordersState: BaseState<List<OrderSummaryEntity>>(isLoading: true, errorMessage: '')),
        OrdersListState(
          ordersState: BaseState<List<OrderSummaryEntity>>(isLoading: false, errorMessage: '', data: orders),
        ),
      ],
    );

    blocTest<OrdersListViewModel, OrdersListState>(
      'emits loading then error state when orders load fails',
      setUp: () {
        when(getOrdersUseCase.call()).thenAnswer(
          (_) async => ErrorResponse<List<OrderSummaryEntity>>(appError: BadResponseError('Not Found')),
        );
      },
      build: () => OrdersListViewModel(getOrdersUseCase),
      act: (viewModel) => viewModel.doEvent(OrdersRequested()),
      expect: () => [
        const OrdersListState(ordersState: BaseState<List<OrderSummaryEntity>>(isLoading: true, errorMessage: '')),
        const OrdersListState(
          ordersState: BaseState<List<OrderSummaryEntity>>(isLoading: false, errorMessage: 'Not Found'),
        ),
      ],
    );
  });
}
