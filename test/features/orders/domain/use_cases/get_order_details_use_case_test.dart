import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/orders/domain/entities/order_details_entity.dart';
import 'package:flower_app/features/orders/domain/entities/order_status.dart';
import 'package:flower_app/features/orders/domain/repo/orders_repo.dart';
import 'package:flower_app/features/orders/domain/use_cases/get_order_details_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_order_details_use_case_test.mocks.dart';

@GenerateMocks([OrdersRepo])
void main() {
  late MockOrdersRepo ordersRepo;
  late GetOrderDetailsUseCase getOrderDetailsUseCase;

  setUp(() {
    ordersRepo = MockOrdersRepo();
    getOrderDetailsUseCase = GetOrderDetailsUseCase(ordersRepo);
  });

  const order = OrderDetailsEntity(id: '1', orderNumber: 'FL-1', status: OrderStatus.delivered);

  test('returns order details on success', () async {
    provideDummy<BaseResponse<OrderDetailsEntity>>(const SuccessResponse<OrderDetailsEntity>(order));
    when(ordersRepo.getOrderDetails('1')).thenAnswer((_) async => const SuccessResponse(order));

    final result = await getOrderDetailsUseCase('1');

    expect(result, isA<SuccessResponse<OrderDetailsEntity>>());
    verify(ordersRepo.getOrderDetails('1')).called(1);
  });

  test('returns error on failure', () async {
    final error = BadResponseError('Not Found');
    provideDummy<BaseResponse<OrderDetailsEntity>>(ErrorResponse<OrderDetailsEntity>(appError: error));
    when(ordersRepo.getOrderDetails('1')).thenAnswer((_) async => ErrorResponse(appError: error));

    final result = await getOrderDetailsUseCase('1');

    expect(result, isA<ErrorResponse<OrderDetailsEntity>>());
  });
}
