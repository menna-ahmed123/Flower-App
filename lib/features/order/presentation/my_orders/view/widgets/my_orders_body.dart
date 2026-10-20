import 'package:flower_app/features/order/presentation/my_orders/view/widgets/orders_content.dart';
import 'package:flower_app/features/order/presentation/my_orders/view/widgets/orders_tabs.dart';
import 'package:flower_app/features/order/presentation/my_orders/view_model/my_orders_event.dart';
import 'package:flower_app/features/order/presentation/my_orders/view_model/my_orders_state.dart';
import 'package:flower_app/features/order/presentation/my_orders/view_model/my_orders_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyOrdersBody extends StatelessWidget {
  const MyOrdersBody({super.key});

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
            builder: (context, state) => OrdersContent(
              state: state,
              onRefresh: () => viewModel.onEvent(LoadMyOrders()),
              onLoadMore: () => viewModel.onEvent(LoadMoreOrders()),
              onRetry: () => viewModel.onEvent(LoadMyOrders()),
              onTrackOrder: (orderId) => viewModel.onEvent(TrackOrder(orderId)),
            ),
          ),
        ),
      ],
    );
  }
}
