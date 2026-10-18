import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/utils/pagination/pagination_controller.dart';
import 'package:flower_app/core/utils/pagination/pagination_state.dart';
import 'package:flower_app/core/widgets/app_shimmer/orders_list_shimmer.dart';
import 'package:flower_app/features/order/domain/entities/order_entity.dart';
import 'package:flower_app/features/order/presentation/my_orders/view/widgets/order_card.dart';
import 'package:flower_app/features/order/presentation/my_orders/view/widgets/orders_error_view.dart';
import 'package:flower_app/features/order/presentation/my_orders/view/widgets/orders_tabs.dart';
import 'package:flower_app/features/order/presentation/my_orders/view_model/my_orders_event.dart';
import 'package:flower_app/features/order/presentation/my_orders/view_model/my_orders_state.dart';
import 'package:flower_app/features/order/presentation/my_orders/view_model/my_orders_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyOrdersBody extends StatefulWidget {
  const MyOrdersBody({super.key});

  @override
  State<MyOrdersBody> createState() => _MyOrdersBodyState();
}

class _MyOrdersBodyState extends State<MyOrdersBody> {
  late final ScrollController _scrollController;
  late final MyOrdersViewModel _viewModel;
  late final PaginationController<OrderEntity> _controller;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<MyOrdersViewModel>();
    _controller = _viewModel.ordersPaginationController;
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_viewModel.isAutoFilling) return;
    final pagingState = _controller.state;
    if (!pagingState.hasMore) return;
    if (pagingState.status == PaginationStatus.loading ||
        pagingState.status == PaginationStatus.loadingMore) {
      return;
    }
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      _controller.loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<MyOrdersViewModel>();

    return Column(
      children: [
        BlocBuilder<MyOrdersViewModel, MyOrdersState>(
          buildWhen: (previous, current) =>
              previous.selectedTab != current.selectedTab,
          builder: (context, state) => OrdersTabs(
            selectedTab: state.selectedTab,
            onTabSelected: (tab) => viewModel.onEvent(SwitchTab(tab)),
          ),
        ),
        Expanded(
          child: BlocBuilder<MyOrdersViewModel, MyOrdersState>(
            builder: (context, state) {
              return ListenableBuilder(
                listenable: _controller,
                builder: (context, _) {
                  final pagination = _controller.state;
                  final orders = viewModel.ordersForTab(state.selectedTab);

                  if (pagination.status == PaginationStatus.loading &&
                      pagination.items.isEmpty) {
                    return const OrdersListShimmer();
                  }

                  if (pagination.status == PaginationStatus.error &&
                      pagination.items.isEmpty) {
                    return _pullToRefresh(
                      viewModel,
                      child: OrdersErrorView(
                        message: pagination.errorMessage ??
                            AppString.somethingWrong,
                        onRetry: _controller.retry,
                      ),
                    );
                  }

                  if (orders.isEmpty) {
                    return _pullToRefresh(
                      viewModel,
                      child: const Center(child: Text(AppString.noData)),
                    );
                  }

                  final showLoadingMore =
                      pagination.status == PaginationStatus.loadingMore;

                  return RefreshIndicator(
                    onRefresh: () => viewModel.onEvent(LoadMyOrders()),
                    child: ListView.separated(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      itemCount: orders.length + (showLoadingMore ? 1 : 0),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        if (index >= orders.length) {
                          return Padding(
                            padding: EdgeInsets.all(12.r),
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }
                        return _buildCard(viewModel, orders[index]);
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _pullToRefresh(
    MyOrdersViewModel viewModel, {
    required Widget child,
  }) {
    return RefreshIndicator(
      onRefresh: () => viewModel.onEvent(LoadMyOrders()),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        children: [
          SizedBox(height: 320.h, child: child),
        ],
      ),
    );
  }

  Widget _buildCard(MyOrdersViewModel viewModel, OrderEntity order) {
    return OrderCard(
      orderImageUrl: order.firstItemThumbnailUrl?.toString() ?? '',
      orderName: AppString.itemsCount(order.itemCount ?? 0),
      orderPrice: '${AppString.egp} ${(order.total ?? 0).toStringAsFixed(0)}',
      orderNumber: order.orderNumber ?? '',
      onTrackOrder: () => viewModel.onEvent(TrackOrder(order.id ?? '')),
    );
  }
}
