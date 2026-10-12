import 'package:flower_app/core/widgets/app_button.dart';
import 'package:flower_app/features/order_tacking/presentation/view/widgets/delivery_information_card.dart';
import 'package:flower_app/features/order_tacking/presentation/view/widgets/estimated_arrival_section.dart';
import 'package:flower_app/features/order_tacking/presentation/view/widgets/staleness_badge.dart';
import 'package:flower_app/features/order_tacking/presentation/view/widgets/tracking_map_view.dart';
import 'package:flower_app/features/order_tacking/presentation/view/widgets/waiting_for_driver_card.dart';
import 'package:flower_app/features/order_tacking/presentation/view_model/order_tracking_state.dart';
import 'package:flower_app/features/order_tacking/presentation/view_model/order_tracking_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Must be built under a BlocProvider.value for the SAME OrderTrackingViewModel
/// as the tracking page (see router snippet).
class OrderTrackingMapPage extends StatelessWidget {
  const OrderTrackingMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: BlocBuilder<OrderTrackingViewModel, OrderTrackingState>(
        builder: (context, state) {
          final t = state.tracking;
          if (t == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: TrackingMapView(
                        driver: t.driverLocation?.point,
                        store: t.pickup,
                        home: t.destination,
                        route: state.routePoints,
                      ),
                    ),
                    Positioned(
                      top: topPad + 8,
                      left: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () => context.pop(),
                        ),
                      ),
                    ),
                    Positioned(
                      top: topPad + 12,
                      right: 16,
                      // Only meaningful once there is a driver position.
                      child: StalenessBadge(
                        lastUpdate: t.driverLocation?.recordedAt,
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      EstimatedArrivalSection(
                        estimatedArrivalDateTime: t.estimatedArrival,
                      ),
                      SizedBox(height: 12.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: t.driver == null
                            ? const WaitingForDriverCard()
                            : DeliveryInformationCard(
                          deliveryName: t.driver!.name,
                          deliveryPhoneNumber: t.driver!.phone,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: AppButton(
                          text: 'Order details',
                          onPressed: () {
                            // TODO: navigate to order details (GET /api/orders/{id})
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}