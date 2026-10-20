import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/order/domain/entities/order_entity.dart';
import 'package:flower_app/features/order/domain/entities/order_status.dart';
import 'package:flower_app/features/order/domain/repos/order_repo.dart';
import 'package:flower_app/features/order/domain/use_cases/get_all_orders_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_all_orders_use_case_test.mocks.dart';

@GenerateMocks([OrderRepo])
void main() {
  provideDummy<BaseResponse<List<OrderEntity>>>(
    const SuccessResponse<List<OrderEntity>>([]),
  );

  late MockOrderRepo orderRepo;
  late GetAllOrdersUseCase useCase;

  setUp(() {
    orderRepo = MockOrderRepo();
    useCase = GetAllOrdersUseCase(orderRepo);
  });

  OrderEntity orderWith(OrderStatus? status) =>
      OrderEntity(id: 'x', status: status);

  group('activeOrders', () {
    test('keeps every non-finished status and preserves order', () {
      final orders = [
        orderWith(OrderStatus.placed),
        orderWith(OrderStatus.preparing),
        orderWith(OrderStatus.pickedUp),
        orderWith(OrderStatus.outForDelivery),
        orderWith(OrderStatus.arrived),
        orderWith(OrderStatus.awaitingDeliveryConfirmation),
        orderWith(OrderStatus.unknown),
        orderWith(OrderStatus.delivered),
        orderWith(OrderStatus.cancelled),
      ];

      final result = useCase.activeOrders(orders);

      expect(result.map((o) => o.status), [
        OrderStatus.placed,
        OrderStatus.preparing,
        OrderStatus.pickedUp,
        OrderStatus.outForDelivery,
        OrderStatus.arrived,
        OrderStatus.awaitingDeliveryConfirmation,
        OrderStatus.unknown,
      ]);
    });

    test('excludes finished orders', () {
      final orders = [
        orderWith(OrderStatus.delivered),
        orderWith(OrderStatus.cancelled),
      ];

      expect(useCase.activeOrders(orders), isEmpty);
    });
  });

  group('completedOrders', () {
    test('keeps only delivered and cancelled', () {
      final orders = [
        orderWith(OrderStatus.placed),
        orderWith(OrderStatus.arrived),
        orderWith(OrderStatus.delivered),
        orderWith(OrderStatus.cancelled),
      ];

      final result = useCase.completedOrders(orders);

      expect(result.map((o) => o.status), [
        OrderStatus.delivered,
        OrderStatus.cancelled,
      ]);
    });

    test('returns empty when nothing is finished', () {
      final orders = [
        orderWith(OrderStatus.placed),
        orderWith(OrderStatus.outForDelivery),
      ];

      expect(useCase.completedOrders(orders), isEmpty);
    });
  });

  group('null status', () {
    test('is dropped from both tabs', () {
      final orders = [
        orderWith(null),
        orderWith(OrderStatus.placed),
        orderWith(OrderStatus.delivered),
      ];

      final active = useCase.activeOrders(orders);
      final completed = useCase.completedOrders(orders);

      expect(active.every((o) => o.status != null), isTrue);
      expect(completed.every((o) => o.status != null), isTrue);
      expect(active.map((o) => o.status), [OrderStatus.placed]);
      expect(completed.map((o) => o.status), [OrderStatus.delivered]);
    });
  });

  group('partition', () {
    test('active + completed + nulls covers the input with no overlap', () {
      final orders = [
        orderWith(OrderStatus.placed),
        orderWith(OrderStatus.delivered),
        orderWith(null),
        orderWith(OrderStatus.cancelled),
        orderWith(OrderStatus.arrived),
      ];

      final active = useCase.activeOrders(orders);
      final completed = useCase.completedOrders(orders);
      final nulls = orders.where((o) => o.status == null).length;

      expect(active.length + completed.length + nulls, orders.length);
      expect(active.any((o) => completed.contains(o)), isFalse);
    });

    test('empty input yields empty output', () {
      expect(useCase.activeOrders(const []), isEmpty);
      expect(useCase.completedOrders(const []), isEmpty);
    });
  });

  group('call', () {
    test('forwards page/pageSize to the repo and returns its response',
        () async {
      const response = SuccessResponse<List<OrderEntity>>([]);
      when(
        orderRepo.getAllOrders(page: 3, pageSize: 7),
      ).thenAnswer((_) async => response);

      final result = await useCase(page: 3, pageSize: 7);

      expect(result, response);
      verify(orderRepo.getAllOrders(page: 3, pageSize: 7)).called(1);
    });

    test('passes null page/pageSize straight through', () async {
      const response = SuccessResponse<List<OrderEntity>>([]);
      when(
        orderRepo.getAllOrders(page: null, pageSize: null),
      ).thenAnswer((_) async => response);

      final result = await useCase();

      expect(result, response);
      verify(orderRepo.getAllOrders(page: null, pageSize: null)).called(1);
    });
  });
}
