import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/core/utils/pagination/pagination_state.dart';
import 'package:flower_app/features/order/domain/entities/delivery_confirmation_entity.dart';
import 'package:flower_app/features/order/domain/entities/order_entity.dart';
import 'package:flower_app/features/order/domain/entities/order_status.dart';
import 'package:flower_app/features/order/domain/entities/geo_point.dart';
import 'package:flower_app/features/order/domain/entities/tracking_entity.dart';
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

  @override
  Future<BaseResponse<TrackingEntity>> orderTracking({
    required String orderId,
  }) =>
      throw UnimplementedError();

  @override
  Stream<BaseResponse<TrackingEntity>> watchTracking({
    required String orderId,
  }) =>
      throw UnimplementedError();

  @override
  Future<BaseResponse<DeliveryConfirmationEntity>> confirmDelivery({
    required String orderId,
  }) =>
      throw UnimplementedError();

  @override
  Future<BaseResponse<List<GeoPoint>>> fetchRoute({
    required GeoPoint from,
    required GeoPoint to,
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
    test('loads the first page into the state', () async {
      final viewModel = MyOrdersViewModel(
        FakeGetAllOrdersUseCase(pages: {1: _mixedPage()}),
      );
      addTearDown(viewModel.close);

      await viewModel.onEvent(LoadMyOrders());

      expect(viewModel.state.pagination.items.length, 5);
      expect(viewModel.state.status, PaginationStatus.success);
      // Default tab is active -> only the non-finished, non-null orders.
      expect(viewModel.state.orders.map((o) => o.id), ['a', 'c']);
    });

    test('surfaces an error status when the source fails', () async {
      final viewModel = MyOrdersViewModel(
        FakeGetAllOrdersUseCase(shouldFail: true),
      );
      addTearDown(viewModel.close);

      await viewModel.onEvent(LoadMyOrders());

      expect(viewModel.state.isInitialError, isTrue);
      expect(viewModel.state.status, PaginationStatus.error);
      expect(viewModel.state.orders, isEmpty);
      // Typed AppFailure message surfaces cleanly (no "Exception:" leak).
      expect(viewModel.state.errorMessage, 'boom');
    });

    test('reset before loading so refresh starts from page 1', () async {
      final useCase = FakeGetAllOrdersUseCase(pages: {1: _mixedPage()});
      final viewModel = MyOrdersViewModel(useCase);
      addTearDown(viewModel.close);

      await viewModel.onEvent(LoadMyOrders());
      await viewModel.onEvent(LoadMyOrders());

      expect(useCase.requestedPages, [1, 1]);
      expect(viewModel.state.pagination.items.length, 5);
    });
  });

  group('tab filtering', () {
    test('exposes the visible orders for the selected tab', () async {
      final viewModel = MyOrdersViewModel(
        FakeGetAllOrdersUseCase(pages: {1: _mixedPage()}),
      );
      addTearDown(viewModel.close);
      await viewModel.onEvent(LoadMyOrders());

      expect(viewModel.state.orders.map((o) => o.id), ['a', 'c']);

      await viewModel.onEvent(SwitchTab(MyOrdersTab.completed));

      expect(viewModel.state.orders.map((o) => o.id), ['b', 'd']);
    });

    test('is empty for a tab with no matching orders', () async {
      final viewModel = MyOrdersViewModel(
        FakeGetAllOrdersUseCase(pages: {
          1: [_order('a', OrderStatus.placed)],
        }),
      );
      addTearDown(viewModel.close);
      await viewModel.onEvent(LoadMyOrders());
      await viewModel.onEvent(SwitchTab(MyOrdersTab.completed));

      expect(viewModel.state.orders, isEmpty);
    });
  });

  group('SwitchTab', () {
    test('updates the selected tab without requesting a page', () async {
      final useCase = FakeGetAllOrdersUseCase(pages: {1: _mixedPage()});
      final viewModel = MyOrdersViewModel(useCase);
      addTearDown(viewModel.close);
      await viewModel.onEvent(LoadMyOrders());
      expect(viewModel.state.selectedTab, MyOrdersTab.active);

      await viewModel.onEvent(SwitchTab(MyOrdersTab.completed));

      expect(viewModel.state.selectedTab, MyOrdersTab.completed);
      expect(useCase.requestedPages, [1]); // no extra network on tab switch
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

  group('LoadMoreOrders', () {
    test('pulls the next page for the current tab on demand', () async {
      final useCase = FakeGetAllOrdersUseCase(pages: {
        1: List.generate(10, (i) => _order('a$i', OrderStatus.placed)),
        2: [_order('d1', OrderStatus.delivered)],
      });
      final viewModel = MyOrdersViewModel(useCase);
      addTearDown(viewModel.close);

      await viewModel.onEvent(LoadMyOrders());
      await viewModel.onEvent(SwitchTab(MyOrdersTab.completed));

      // page1 is all active, so completed is empty but Load More is offered.
      expect(viewModel.state.orders, isEmpty);
      expect(viewModel.state.showLoadMore, isTrue);

      await viewModel.onEvent(LoadMoreOrders());

      expect(useCase.requestedPages, [1, 2]);
      expect(viewModel.state.orders.map((o) => o.id), ['d1']);
    });

    test('does nothing once the last page is reached', () async {
      final useCase = FakeGetAllOrdersUseCase(pages: {
        1: [_order('a', OrderStatus.placed)], // one short page -> hasMore false
      });
      final viewModel = MyOrdersViewModel(useCase);
      addTearDown(viewModel.close);

      await viewModel.onEvent(LoadMyOrders());
      await viewModel.onEvent(SwitchTab(MyOrdersTab.completed));

      expect(viewModel.state.hasMore, isFalse);
      expect(viewModel.state.showLoadMore, isFalse);

      await viewModel.onEvent(LoadMoreOrders());

      expect(useCase.requestedPages, [1]); // guarded: no page 2 request
    });
  });
}
