import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/theme/app_theme.dart';
import 'package:flower_app/core/widgets/app_shimmer/orders_shimmer.dart';
import 'package:flower_app/features/orders/domain/entities/order_details_entity.dart';
import 'package:flower_app/features/orders/domain/entities/order_status.dart';
import 'package:flower_app/features/orders/domain/entities/order_summary_entity.dart';
import 'package:flower_app/features/orders/domain/repo/orders_repo.dart';
import 'package:flower_app/features/orders/domain/use_cases/get_orders_use_case.dart';
import 'package:flower_app/features/orders/presentation/orders_list/view/screen/orders_screen.dart';
import 'package:flower_app/features/orders/presentation/orders_list/view_model/orders_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  setUpAll(() async {
    await EasyLocalization.ensureInitialized();
  });

  late GoRouter router;

  Future<void> pumpOrdersScreen(
    WidgetTester tester,
    OrdersListViewModel viewModel,
  ) async {
    router = GoRouter(
      initialLocation: '/my_orders',
      routes: [
        GoRoute(path: '/my_orders', builder: (_, _) => const OrdersScreen()),
        GoRoute(
          path: '/order-details/:orderId',
          builder: (_, state) =>
              Text('ORDER_DETAILS:${state.pathParameters['orderId']}'),
        ),
        GoRoute(path: '/profile', builder: (_, _) => const Text('PROFILE')),
      ],
    );
    addTearDown(router.dispose);

    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        startLocale: const Locale('en'),
        useOnlyLangCode: true,
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, _) => BlocProvider.value(
            value: viewModel,
            child: Builder(
              builder: (context) => MaterialApp.router(
                theme: AppTheme(lightThemeColors).themeData,
                routerConfig: router,
                locale: context.locale,
                supportedLocales: context.supportedLocales,
                localizationsDelegates: context.localizationDelegates,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String path() => router.routeInformationProvider.value.uri.path;

  testWidgets('shows the shimmer while the orders request is in flight', (
    tester,
  ) async {
    final repo = _ControllableOrdersRepo();
    final viewModel = OrdersListViewModel(GetOrdersUseCase(repo));
    addTearDown(viewModel.close);

    await pumpOrdersScreen(tester, viewModel);
    // A single frame, not pumpAndSettle: the shimmer animates continuously
    // while loading and would never "settle".
    await tester.pump();

    expect(find.byType(OrdersShimmer), findsWidgets);

    repo.complete(const SuccessResponse<List<OrderSummaryEntity>>([]));
    await tester.pumpAndSettle();
  });

  testWidgets(
    'splits orders into Active and Completed tabs by status',
    (tester) async {
      final activeOrder = const OrderSummaryEntity(
        id: '1',
        orderNumber: 'FL-1',
        status: OrderStatus.preparing,
        previewProductName: 'Rose Bouquet',
        totalPrice: 250,
      );
      final completedOrder = const OrderSummaryEntity(
        id: '2',
        orderNumber: 'FL-2',
        status: OrderStatus.delivered,
        previewProductName: 'Tulip Basket',
        totalPrice: 300,
      );
      final repo = _ControllableOrdersRepo();
      final viewModel = OrdersListViewModel(GetOrdersUseCase(repo));
      addTearDown(viewModel.close);

      await pumpOrdersScreen(tester, viewModel);
      repo.complete(SuccessResponse([activeOrder, completedOrder]));
      await tester.pumpAndSettle();

      expect(find.text('Rose Bouquet'), findsOneWidget);
      expect(find.text('Tulip Basket'), findsNothing);

      await tester.tap(find.text(AppString.completedOrders));
      await tester.pumpAndSettle();

      expect(find.text('Tulip Basket'), findsOneWidget);
      expect(find.text('Rose Bouquet'), findsNothing);
    },
  );

  testWidgets('shows the empty state when there are no orders', (
    tester,
  ) async {
    final repo = _ControllableOrdersRepo();
    final viewModel = OrdersListViewModel(GetOrdersUseCase(repo));
    addTearDown(viewModel.close);

    await pumpOrdersScreen(tester, viewModel);
    repo.complete(const SuccessResponse<List<OrderSummaryEntity>>([]));
    await tester.pumpAndSettle();

    expect(find.text(AppString.noOrdersFound), findsOneWidget);
  });

  testWidgets(
    'shows the error view with retry, and retrying reloads the orders',
    (tester) async {
      final repo = _ControllableOrdersRepo();
      final viewModel = OrdersListViewModel(GetOrdersUseCase(repo));
      addTearDown(viewModel.close);

      await pumpOrdersScreen(tester, viewModel);
      repo.complete(
        ErrorResponse<List<OrderSummaryEntity>>(
          appError: BadResponseError('Could not load orders'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Could not load orders'), findsOneWidget);
      expect(find.text(AppString.retry), findsOneWidget);

      repo.reset();
      await tester.tap(find.text(AppString.retry));
      await tester.pump();
      repo.complete(const SuccessResponse<List<OrderSummaryEntity>>([]));
      await tester.pumpAndSettle();

      expect(find.text('Could not load orders'), findsNothing);
      expect(find.text(AppString.noOrdersFound), findsOneWidget);
    },
  );

  testWidgets('tapping Track order navigates to order details with the '
      "order's id", (tester) async {
    final order = const OrderSummaryEntity(
      id: 'abc-123',
      orderNumber: 'FL-9',
      status: OrderStatus.placed,
      previewProductName: 'Lily Bunch',
      totalPrice: 150,
    );
    final repo = _ControllableOrdersRepo();
    final viewModel = OrdersListViewModel(GetOrdersUseCase(repo));
    addTearDown(viewModel.close);

    await pumpOrdersScreen(tester, viewModel);
    repo.complete(SuccessResponse([order]));
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppString.trackOrder));
    await tester.pumpAndSettle();

    expect(path(), '/order-details/abc-123');
    expect(find.text('ORDER_DETAILS:abc-123'), findsOneWidget);
  });
}

/// An OrdersRepo whose getOrders() call only resolves once [complete] is
/// called, so tests can assert on the in-between loading state. [reset]
/// swaps in a fresh, not-yet-resolved call for a retry.
class _ControllableOrdersRepo implements OrdersRepo {
  Completer<BaseResponse<List<OrderSummaryEntity>>> _completer = Completer();

  void complete(BaseResponse<List<OrderSummaryEntity>> response) {
    _completer.complete(response);
  }

  void reset() {
    _completer = Completer();
  }

  @override
  Future<BaseResponse<List<OrderSummaryEntity>>> getOrders({
    required int page,
    required int pageSize,
  }) => _completer.future;

  @override
  Future<BaseResponse<OrderDetailsEntity>> getOrderDetails(String id) {
    throw UnimplementedError('Not needed for OrdersScreen tests');
  }
}
