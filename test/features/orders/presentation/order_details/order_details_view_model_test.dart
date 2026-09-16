import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/orders/domain/entities/order_details_entity.dart';
import 'package:flower_app/features/orders/domain/entities/order_status.dart';
import 'package:flower_app/features/orders/domain/use_cases/get_order_details_use_case.dart';
import 'package:flower_app/features/orders/presentation/order_details/view_model/order_details_event.dart';
import 'package:flower_app/features/orders/presentation/order_details/view_model/order_details_state.dart';
import 'package:flower_app/features/orders/presentation/order_details/view_model/order_details_view_model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'order_details_view_model_test.mocks.dart';

@GenerateMocks([GetOrderDetailsUseCase])
void main() {
  provideDummy<BaseResponse<OrderDetailsEntity>>(const SuccessResponse<OrderDetailsEntity>(OrderDetailsEntity()));

  late MockGetOrderDetailsUseCase getOrderDetailsUseCase;

  const order = OrderDetailsEntity(id: '1', orderNumber: 'FL-1', status: OrderStatus.delivered);

  setUp(() {
    getOrderDetailsUseCase = MockGetOrderDetailsUseCase();
  });

  group('OrderDetailsViewModel', () {
    blocTest<OrderDetailsViewModel, OrderDetailsState>(
      'emits loading then success state when order details load successfully',
      setUp: () {
        when(getOrderDetailsUseCase.call('1')).thenAnswer((_) async => const SuccessResponse(order));
      },
      build: () => OrderDetailsViewModel(getOrderDetailsUseCase),
      act: (viewModel) => viewModel.doEvent(OrderDetailsRequested('1')),
      expect: () => [
        const OrderDetailsState(orderDetailsState: BaseState<OrderDetailsEntity>(isLoading: true, errorMessage: '')),
        const OrderDetailsState(
          orderDetailsState: BaseState<OrderDetailsEntity>(isLoading: false, errorMessage: '', data: order),
        ),
      ],
    );

    blocTest<OrderDetailsViewModel, OrderDetailsState>(
      'emits loading then error state when order details load fails',
      setUp: () {
        when(getOrderDetailsUseCase.call('1')).thenAnswer(
          (_) async => ErrorResponse<OrderDetailsEntity>(appError: BadResponseError('Not Found')),
        );
      },
      build: () => OrderDetailsViewModel(getOrderDetailsUseCase),
      act: (viewModel) => viewModel.doEvent(OrderDetailsRequested('1')),
      expect: () => [
        const OrderDetailsState(orderDetailsState: BaseState<OrderDetailsEntity>(isLoading: true, errorMessage: '')),
        const OrderDetailsState(
          orderDetailsState: BaseState<OrderDetailsEntity>(isLoading: false, errorMessage: 'Not Found'),
        ),
      ],
    );
  });
}
