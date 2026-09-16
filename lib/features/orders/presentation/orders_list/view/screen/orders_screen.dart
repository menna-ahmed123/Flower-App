import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/widgets/app_error_view.dart';
import 'package:flower_app/core/widgets/app_shimmer/orders_shimmer.dart';
import 'package:flower_app/features/auth/login/presentation/view/pages/widgets/custom_app_bar.dart';
import 'package:flower_app/features/orders/domain/entities/order_status.dart';
import 'package:flower_app/features/orders/domain/entities/order_summary_entity.dart';
import 'package:flower_app/features/orders/presentation/orders_list/view/widgets/order_card.dart';
import 'package:flower_app/features/orders/presentation/orders_list/view_model/orders_list_event.dart';
import 'package:flower_app/features/orders/presentation/orders_list/view_model/orders_list_state.dart';
import 'package:flower_app/features/orders/presentation/orders_list/view_model/orders_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late final OrdersListViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<OrdersListViewModel>();
    _viewModel.doEvent(OrdersRequested());
  }

  void _onBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutesName.profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(
          title: AppString.myOrders,
          onBack: () => _onBack(context),
          bottom: TabBar(
            labelColor: colors.pink,
            unselectedLabelColor: colors.grey.shade700,
            indicatorColor: colors.pink,
            tabs: [
              Tab(text: AppString.activeOrders),
              Tab(text: AppString.completedOrders),
            ],
          ),
        ),
        body: BlocBuilder<OrdersListViewModel, OrdersListState>(
          builder: (context, state) {
            final ordersState = state.ordersState;

            if (ordersState.isLoading) {
              return const TabBarView(children: [OrdersShimmer(), OrdersShimmer()]);
            }

            if (ordersState.errorMessage.isNotEmpty) {
              return AppErrorView(
                message: ordersState.errorMessage,
                onRetry: () => _viewModel.doEvent(OrdersRequested()),
              );
            }

            final orders = ordersState.data ?? [];
            final activeOrders = orders.where((order) => order.status.isActive).toList();
            final completedOrders = orders.where((order) => order.status.isCompleted).toList();

            return TabBarView(
              children: [
                _OrdersTab(orders: activeOrders),
                _OrdersTab(orders: completedOrders),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OrdersTab extends StatelessWidget {
  const _OrdersTab({required this.orders});

  final List<OrderSummaryEntity> orders;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const _EmptyView();
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 16.h),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderCard(
          order: order,
          onTrackOrder: () => context.push(
            AppRoutesName.orderDetails.replaceFirst(':orderId', order.id),
          ),
        );
      },
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, color: colors.grey.shade600, size: 60),
          SizedBox(height: 16.h),
          Text(
            AppString.noOrdersFound,
            style: TextStyle(fontSize: 16.sp, color: colors.grey.shade600, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
