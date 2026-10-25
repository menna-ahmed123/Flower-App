import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/order/domain/entities/delivery_confirmation_entity.dart';
import 'package:flower_app/features/order/domain/entities/order_entity.dart';
import 'package:flower_app/features/order/domain/entities/order_status.dart';
import 'package:flower_app/features/order/domain/entities/geo_point.dart';
import 'package:flower_app/features/order/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/order/domain/repos/order_repo.dart';
import 'package:flower_app/features/order/domain/use_cases/get_all_orders_use_case.dart';
import 'package:flower_app/features/order/presentation/my_orders/view/models/my_orders_tab.dart';
import 'package:flower_app/features/order/presentation/my_orders/view/widgets/my_orders_body.dart';
import 'package:flower_app/features/order/presentation/my_orders/view_model/my_orders_event.dart';
import 'package:flower_app/features/order/presentation/my_orders/view_model/my_orders_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/pump_app.dart';

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

class _FakeUseCase extends GetAllOrdersUseCase {
  _FakeUseCase([this.pages = const {}]) : super(_StubOrderRepo());

  final Map<int, List<OrderEntity>> pages;

  @override
  Future<BaseResponse<List<OrderEntity>>> call({
    int? page,
    int? pageSize,
  }) async =>
      SuccessResponse<List<OrderEntity>>(pages[page] ?? const []);
}

class _FailingUseCase extends GetAllOrdersUseCase {
  _FailingUseCase() : super(_StubOrderRepo());

  @override
  Future<BaseResponse<List<OrderEntity>>> call({
    int? page,
    int? pageSize,
  }) async =>
      ErrorResponse<List<OrderEntity>>(appError: BadResponseError('boom'));
}

OrderEntity _order(String number, OrderStatus status) => OrderEntity(
      id: number,
      orderNumber: number,
      status: status,
      itemCount: 2,
      total: 100,
    );

Future<MyOrdersViewModel> _loaded(
  WidgetTester tester,
  Map<int, List<OrderEntity>> pages,
) async {
  final viewModel = MyOrdersViewModel(_FakeUseCase(pages));
  addTearDown(viewModel.close);
  await viewModel.onEvent(LoadMyOrders());

  await pumpApp(
    tester,
    BlocProvider.value(
      value: viewModel,
      child: const Scaffold(body: MyOrdersBody()),
    ),
  );
  return viewModel;
}

void main() {
  testWidgets('shows the active/completed tabs', (tester) async {
    await _loaded(tester, {});

    expect(find.text(AppString.active), findsOneWidget);
    expect(find.text(AppString.completed), findsOneWidget);
  });

  testWidgets('renders a card per active order', (tester) async {
    await _loaded(tester, {
      1: [_order('ORD-A', OrderStatus.placed), _order('ORD-B', OrderStatus.arrived)],
    });

    expect(find.text('ORD-A'), findsOneWidget);
    expect(find.text('ORD-B'), findsOneWidget);
  });

  testWidgets('shows no-data when there are no orders', (tester) async {
    await _loaded(tester, {});

    expect(find.text(AppString.noData), findsOneWidget);
  });

  testWidgets('shows Load More when a tab is empty but pages remain',
      (tester) async {
    final viewModel = MyOrdersViewModel(_FakeUseCase({
      1: List.generate(10, (i) => _order('A$i', OrderStatus.placed)),
    }));
    addTearDown(viewModel.close);
    await viewModel.onEvent(LoadMyOrders());
    await viewModel.onEvent(SwitchTab(MyOrdersTab.completed));

    await pumpApp(
      tester,
      BlocProvider.value(
        value: viewModel,
        child: const Scaffold(body: MyOrdersBody()),
      ),
    );

    expect(find.text(AppString.noData), findsOneWidget);
    expect(find.text(AppString.loadMore), findsOneWidget);
  });

  testWidgets('switching tabs filters the same loaded page by status',
      (tester) async {
    final viewModel = MyOrdersViewModel(_FakeUseCase({
      1: [_order('A1', OrderStatus.placed), _order('C1', OrderStatus.delivered)],
    }));
    addTearDown(viewModel.close);
    await viewModel.onEvent(LoadMyOrders());

    await pumpApp(
      tester,
      BlocProvider.value(
        value: viewModel,
        child: const Scaffold(body: MyOrdersBody()),
      ),
    );

    // Active tab: only the not-yet-finished order is visible.
    expect(find.text('A1'), findsOneWidget);
    expect(find.text('C1'), findsNothing);

    await tester.tap(find.text(AppString.completed));
    await tester.pump();

    // Completed tab: same page, opposite filter, without a new request.
    expect(find.text('C1'), findsOneWidget);
    expect(find.text('A1'), findsNothing);
  });

  testWidgets('Load More pulls the next page into the current tab',
      (tester) async {
    final viewModel = MyOrdersViewModel(_FakeUseCase({
      1: List.generate(10, (i) => _order('A$i', OrderStatus.placed)),
      2: [_order('D1', OrderStatus.delivered)],
    }));
    addTearDown(viewModel.close);
    await viewModel.onEvent(LoadMyOrders());
    await viewModel.onEvent(SwitchTab(MyOrdersTab.completed));

    await pumpApp(
      tester,
      BlocProvider.value(
        value: viewModel,
        child: const Scaffold(body: MyOrdersBody()),
      ),
    );

    // Completed is empty from page 1 only, and offers Load More.
    expect(find.text('D1'), findsNothing);
    expect(find.text(AppString.loadMore), findsOneWidget);

    await tester.tap(find.text(AppString.loadMore));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Page 2 arrives -> the delivered order shows and the button disappears
    // (page 2 is short, so hasMore flips to false).
    expect(find.text('D1'), findsOneWidget);
    expect(find.text(AppString.loadMore), findsNothing);
  });

  testWidgets('shows the error view with a retry action when loading fails',
      (tester) async {
    final viewModel = MyOrdersViewModel(_FailingUseCase());
    addTearDown(viewModel.close);
    await viewModel.onEvent(LoadMyOrders());

    await pumpApp(
      tester,
      BlocProvider.value(
        value: viewModel,
        child: const Scaffold(body: MyOrdersBody()),
      ),
    );

    expect(find.text('boom'), findsOneWidget);
    expect(find.text(AppString.retry), findsOneWidget);
  });
}
