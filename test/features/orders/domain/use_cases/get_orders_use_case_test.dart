import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/orders/domain/entities/order_status.dart';
import 'package:flower_app/features/orders/domain/entities/order_summary_entity.dart';
import 'package:flower_app/features/orders/domain/repo/orders_repo.dart';
import 'package:flower_app/features/orders/domain/use_cases/get_orders_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_orders_use_case_test.mocks.dart';

@GenerateMocks([OrdersRepo])
void main() {
  late MockOrdersRepo ordersRepo;
  late GetOrdersUseCase getOrdersUseCase;

  setUp(() {
    ordersRepo = MockOrdersRepo();
    getOrdersUseCase = GetOrdersUseCase(ordersRepo);
  });

  final orders = [
    const OrderSummaryEntity(id: '1', orderNumber: 'FL-1', status: OrderStatus.placed, totalPrice: 100),
  ];

  test('returns orders on success', () async {
    provideDummy<BaseResponse<List<OrderSummaryEntity>>>(SuccessResponse<List<OrderSummaryEntity>>(orders));
    when(ordersRepo.getOrders(page: 1, pageSize: 50)).thenAnswer((_) async => SuccessResponse(orders));

    final result = await getOrdersUseCase();

    expect(result, isA<SuccessResponse<List<OrderSummaryEntity>>>());
    verify(ordersRepo.getOrders(page: 1, pageSize: 50)).called(1);
  });

  test('returns error on failure', () async {
    final error = BadResponseError('Not Found');
    provideDummy<BaseResponse<List<OrderSummaryEntity>>>(ErrorResponse<List<OrderSummaryEntity>>(appError: error));
    when(ordersRepo.getOrders(page: 1, pageSize: 50)).thenAnswer((_) async => ErrorResponse(appError: error));

    final result = await getOrdersUseCase();

    expect(result, isA<ErrorResponse<List<OrderSummaryEntity>>>());
  });
}
