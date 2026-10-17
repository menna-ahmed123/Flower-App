import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/core/utils/pagination/pagination_state.dart';
import 'package:flower_app/features/order/domain/entities/order_entity.dart';
import 'package:flower_app/features/order/domain/entities/order_status.dart';
import 'package:flower_app/features/order/domain/repos/order_repo.dart';
import 'package:flower_app/features/order/domain/use_cases/get_all_orders_use_case.dart';
import 'package:flower_app/features/order/presentation/my_orders/view/models/my_orders_tab.dart';
import 'package:flower_app/features/order/presentation/my_orders/view_model/my_orders_event.dart';
import 'package:flower_app/features/order/presentation/my_orders/view_model/my_orders_ui_event.dart';
import 'package:flower_app/features/order/presentation/my_orders/view_model/my_orders_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

/// A repo the use case never reaches: the ViewModel only drives the `call`
/// operator, which [FakeGetAllOrdersUseCase] overrides below.
class _StubOrderRepo implements OrderRepo {
  @override
  Future<BaseResponse<List<OrderEntity>>> getAllOrders({
    int? page,
    int? pageSize,
  }) =>
      throw UnimplementedError();
}

/// Serves scripted pages instead of the network and records the requests,
/// while the real filtering (`activeOrders`/`completedOrders`) stays inherited.
class FakeGetAllOrdersUseCase extends GetAllOrdersUseCase {
  FakeGetAllOrdersUseCase({
    Map<int, List<OrderEntity>> pages = const {},
    this.shouldFail = false,
  })  : _pages = pages,
        super(_StubOrderRepo());

  final Map<int, List<OrderEntity>> _pages;
  final bool shouldFail;

  final List<int?> requestedPages = [];

  @override
  Future<BaseResponse<List<OrderEntity>>> call({
    int? page,
    int? pageSize,
  }) async {
    requestedPages.add(page);
    if (shouldFail) {
      return ErrorResponse<List<OrderEntity>>(
        appError: BadResponseError('boom'),
      );
    }
    return SuccessResponse<List<OrderEntity>>(_pages[page] ?? const []);
  }
}

OrderEntity _order(String id, OrderStatus? status) =>
    OrderEntity(id: id, status: status);

/// Two active (placed, arrived), two completed (delivered, cancelled), one null.
List<OrderEntity> _mixedPage() => [
      _order('a', OrderStatus.placed),
      _order('b', OrderStatus.delivered),
      _order('c', OrderStatus.arrived),
      _order('d', OrderStatus.cancelled),
      _order('e', null),
    ];

void main() {
  group('LoadMyOrders', () {
    test('loads the first page into the pagination controller', () async {
      final useCase = FakeGetAllOrdersUseCase(pages: {1: _mixedPage()});
      final viewModel = MyOrdersViewModel(useCase);
      addTearDown(viewModel.close);

      await viewModel.onEvent(LoadMyOrders());

      expect(useCase.requestedPages, [1]);
      expect(viewModel.ordersPaginationController.state.items.length, 5);
      expect(
        viewModel.ordersPaginationController.state.status,
        PaginationStatus.success,
      );
    });

    test('surfaces an error status when the source fails', () async {
      final viewModel = MyOrdersViewModel(FakeGetAllOrdersUseCase(
        shouldFail: true,
      ));
      addTearDown(viewModel.close);

      await viewModel.onEvent(LoadMyOrders());

      expect(
        viewModel.ordersPaginationController.state.status,
        PaginationStatus.error,
      );
      expect(viewModel.ordersPaginationController.state.items, isEmpty);
    });

    test('reset before loading so refresh starts from page 1', () async {
      final useCase = FakeGetAllOrdersUseCase(pages: {1: _mixedPage()});
      final viewModel = MyOrdersViewModel(useCase);
      addTearDown(viewModel.close);

      await viewModel.onEvent(LoadMyOrders());
      await viewModel.onEvent(LoadMyOrders());

      expect(useCase.requestedPages, [1, 1]);
      expect(viewModel.ordersPaginationController.state.items.length, 5);
    });
  });

  group('ordersForTab', () {
    test('splits the loaded page by status, dropping nulls', () async {
      final viewModel = MyOrdersViewModel(
        FakeGetAllOrdersUseCase(pages: {1: _mixedPage()}),
      );
      addTearDown(viewModel.close);
      await viewModel.onEvent(LoadMyOrders());

      final active = viewModel.ordersForTab(MyOrdersTab.active);
      final completed = viewModel.ordersForTab(MyOrdersTab.completed);

      expect(active.map((o) => o.id), ['a', 'c']);
      expect(completed.map((o) => o.id), ['b', 'd']);
      expect(active.every((o) => o.status!.isActive), isTrue);
      expect(completed.every((o) => o.status!.isFinished), isTrue);
    });

    test('is empty for a tab with no matching orders', () async {
      final viewModel = MyOrdersViewModel(
        FakeGetAllOrdersUseCase(pages: {
          1: [_order('a', OrderStatus.placed)],
        }),
      );
      addTearDown(viewModel.close);
      await viewModel.onEvent(LoadMyOrders());

      expect(viewModel.ordersForTab(MyOrdersTab.completed), isEmpty);
    });
  });

  group('SwitchTab', () {
    test('updates the selected tab in state', () async {
      final viewModel = MyOrdersViewModel(FakeGetAllOrdersUseCase());
      addTearDown(viewModel.close);
      expect(viewModel.state.selectedTab, MyOrdersTab.active);

      await viewModel.onEvent(SwitchTab(MyOrdersTab.completed));

      expect(viewModel.state.selectedTab, MyOrdersTab.completed);
    });
  });

  group('TrackOrder', () {
    test('emits a TrackMyOrder ui event carrying the id', () async {
      final viewModel = MyOrdersViewModel(FakeGetAllOrdersUseCase());
      addTearDown(viewModel.close);
      final effects = <MyOrdersUiEvent>[];
      viewModel.uiEvents.listen(effects.add);

      await viewModel.onEvent(TrackOrder('o1'));
      await Future<void>.delayed(Duration.zero);

      expect(effects, [const TrackMyOrder(orderId: 'o1')]);
    });
  });

  group('ensureTabHasContent (client filter + server paging)', () {
    test('switching to completed pulls later pages until a finished order shows',
        () async {
      final useCase = FakeGetAllOrdersUseCase(pages: {
        1: List.generate(10, (i) => _order('a$i', OrderStatus.placed)),
        2: [_order('d1', OrderStatus.delivered)],
      });
      final viewModel = MyOrdersViewModel(useCase);
      addTearDown(viewModel.close);

      await viewModel.onEvent(LoadMyOrders());
      expect(viewModel.ordersForTab(MyOrdersTab.completed), isEmpty);

      await viewModel.onEvent(SwitchTab(MyOrdersTab.completed));

      expect(useCase.requestedPages, [1, 2]);
      expect(
        viewModel.ordersForTab(MyOrdersTab.completed).map((o) => o.id),
        ['d1'],
      );
    });

    test('auto-fill stops when no page holds a matching order', () async {
      final useCase = FakeGetAllOrdersUseCase(pages: {
        1: List.generate(10, (i) => _order('a$i', OrderStatus.placed)),
      });
      final viewModel = MyOrdersViewModel(useCase);
      addTearDown(viewModel.close);

      await viewModel.onEvent(LoadMyOrders());
      await viewModel.onEvent(SwitchTab(MyOrdersTab.completed));

      expect(viewModel.ordersForTab(MyOrdersTab.completed), isEmpty);
      expect(useCase.requestedPages, [1, 2]);
    });
  });
}
