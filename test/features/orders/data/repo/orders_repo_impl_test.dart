import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/orders/data/data_sources/orders_remote_data_source.dart';
import 'package:flower_app/features/orders/data/models/order_summary_dto.dart';
import 'package:flower_app/features/orders/data/models/orders_list_response.dart';
import 'package:flower_app/features/orders/data/repo/orders_repo_impl.dart';
import 'package:flower_app/features/orders/domain/entities/order_status.dart';
import 'package:flower_app/features/orders/domain/entities/order_summary_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'orders_repo_impl_test.mocks.dart';

@GenerateMocks([OrdersRemoteDataSource])
void main() {
  late MockOrdersRemoteDataSource remoteDataSource;
  late OrdersRepoImpl repo;

  setUp(() {
    remoteDataSource = MockOrdersRemoteDataSource();
    repo = OrdersRepoImpl(SafeCall(), remoteDataSource);
  });

  test('getOrders maps a successful response to domain entities', () async {
    final response = OrdersListResponse(
      success: true,
      statusCode: 200,
      message: '',
      messageLocalized: '',
      data: [OrderSummaryDto(id: '1', orderNumber: 'FL-1', status: 0, totalPrice: 100)],
    );
    when(remoteDataSource.getOrders(page: 1, pageSize: 50)).thenAnswer((_) async => response);

    final result = await repo.getOrders(page: 1, pageSize: 50);

    expect(result, isA<SuccessResponse<List<OrderSummaryEntity>>>());
    final orders = (result as SuccessResponse<List<OrderSummaryEntity>>).data;
    expect(orders.first.orderNumber, 'FL-1');
    expect(orders.first.status, OrderStatus.placed);
  });

  test('getOrders returns an error response when the data source throws', () async {
    when(remoteDataSource.getOrders(page: 1, pageSize: 50)).thenThrow(Exception('network error'));

    final result = await repo.getOrders(page: 1, pageSize: 50);

    expect(result, isA<ErrorResponse<List<OrderSummaryEntity>>>());
  });
}
