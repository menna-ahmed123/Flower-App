import 'package:flower_app/features/order/domain/entities/tracking_driver_entity.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/delivery_information_card.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/no_driver_available_card.dart';
import 'package:flutter/material.dart';

/// Driver card when there is a driver, "no driver yet" card otherwise.
class TrackingDriverSection extends StatelessWidget {
  const TrackingDriverSection({super.key, required this.driver});

  final TrackingDriverEntity? driver;

  @override
  Widget build(BuildContext context) {
    final d = driver;
    if (d == null) return const NoDriverAvailableCard();
    return DeliveryInformationCard(
      deliveryName: d.name,
      deliveryPhoneNumber: d.phone,
    );
  }
}
