import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/utils/pagination/pagination_state.dart';
import 'package:flower_app/core/widgets/app_shimmer/orders_list_shimmer.dart';
import 'package:flower_app/features/order/presentation/my_orders/view/widgets/load_more_button.dart';
import 'package:flower_app/features/order/presentation/my_orders/view/widgets/my_order_card.dart';
import 'package:flower_app/features/order/presentation/my_orders/view/widgets/orders_error_view.dart';
import 'package:flower_app/features/order/presentation/my_orders/view/widgets/pull_to_refresh_view.dart';
import 'package:flower_app/features/order/presentation/my_orders/view_model/my_orders_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrdersContent extends StatelessWidget {
  const OrdersContent({
    super.key,
    required this.state,
    required this.onRefresh,
    required this.onLoadMore,
    required this.onRetry,
    required this.onTrackOrder,
  });

  final MyOrdersState state;
  final RefreshCallback onRefresh;
  final VoidCallback onLoadMore;
  final VoidCallback onRetry;
  final void Function(String orderId) onTrackOrder;

  @override
  Widget build(BuildContext context) {
    if (state.isInitialLoading) {
      return const OrdersListShimmer();
    }

    if (state.isInitialError) {
      return PullToRefreshView(
        onRefresh: onRefresh,
        child: OrdersErrorView(
          message: state.errorMessage ?? AppString.somethingWrong,
          onRetry: onRetry,
        ),
      );
    }

    final orders = state.orders;
    if (orders.isEmpty) {
      return PullToRefreshView(
        onRefresh: onRefresh,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(AppString.noData),
            if (state.showLoadMore) ...[
              SizedBox(height: 12.h),
              LoadMoreButton(onPressed: onLoadMore),
            ],
          ],
        ),
      );
    }

    final showFooter = state.hasMore || state.status == PaginationStatus.loadingMore;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        itemCount: orders.length + (showFooter ? 1 : 0),
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          if (index >= orders.length) {
            if (state.status == PaginationStatus.loadingMore) {
              return Padding(
                padding: EdgeInsets.all(12.r),
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: LoadMoreButton(onPressed: onLoadMore),
            );
          }
          final order = orders[index];
          return MyOrderCard(
            order: order,
            onTrackOrder: () => onTrackOrder(order.id ?? ''),
          );
        },
      ),
    );
  }
}
