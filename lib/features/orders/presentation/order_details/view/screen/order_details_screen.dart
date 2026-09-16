import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/widgets/app_error_view.dart';
import 'package:flower_app/features/auth/login/presentation/view/pages/widgets/custom_app_bar.dart';
import 'package:flower_app/features/orders/domain/entities/order_details_entity.dart';
import 'package:flower_app/features/orders/presentation/order_details/view/widgets/order_delivery_info.dart';
import 'package:flower_app/features/orders/presentation/order_details/view/widgets/order_items_list.dart';
import 'package:flower_app/features/orders/presentation/order_details/view/widgets/order_payment_info.dart';
import 'package:flower_app/features/orders/presentation/order_details/view/widgets/order_price_summary.dart';
import 'package:flower_app/features/orders/presentation/order_details/view/widgets/order_progress_stepper.dart';
import 'package:flower_app/features/orders/presentation/order_details/view_model/order_details_event.dart';
import 'package:flower_app/features/orders/presentation/order_details/view_model/order_details_state.dart';
import 'package:flower_app/features/orders/presentation/order_details/view_model/order_details_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key, required this.orderId});

  final String orderId;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late final OrderDetailsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<OrderDetailsViewModel>();
    _viewModel.doEvent(OrderDetailsRequested(widget.orderId));
  }

  void _onBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutesName.myOrders);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppString.trackOrder, onBack: () => _onBack(context)),
      body: BlocBuilder<OrderDetailsViewModel, OrderDetailsState>(
        builder: (context, state) {
          final detailsState = state.orderDetailsState;

          if (detailsState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (detailsState.errorMessage.isNotEmpty) {
            return AppErrorView(
              message: detailsState.errorMessage,
              onRetry: () => _viewModel.doEvent(OrderDetailsRequested(widget.orderId)),
            );
          }

          final order = detailsState.data;
          if (order == null) {
            return const SizedBox.shrink();
          }

          return _OrderDetailsBody(order: order);
        },
      ),
    );
  }
}

class _OrderDetailsBody extends StatelessWidget {
  const _OrderDetailsBody({required this.order});

  final OrderDetailsEntity order;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrderProgressStepper(status: order.status),
          SizedBox(height: 24.h),
          OrderDeliveryInfo(
            recipientName: order.recipientName,
            recipientPhone: order.recipientPhone,
            addressLine: order.deliveryAddressLine,
            city: order.deliveryCity,
            area: order.deliveryArea,
          ),
          SizedBox(height: 24.h),
          OrderPaymentInfo(total: order.total, paymentMethod: order.paymentMethod),
          SizedBox(height: 24.h),
          OrderItemsList(items: order.items),
          SizedBox(height: 8.h),
          Divider(color: colors.grey.shade400),
          SizedBox(height: 16.h),
          OrderPriceSummary(subtotal: order.subtotal, deliveryFee: order.deliveryFee, total: order.total),
        ],
      ),
    );
  }
}
