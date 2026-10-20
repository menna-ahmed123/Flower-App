import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/order/domain/entities/order_status.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/extensions/order_status_tracking_label.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OrderStatus.trackingLabel', () {
    test('every status resolves to a wording, never a raw enum name', () {
      for (final status in OrderStatus.values) {
        expect(status.trackingLabel, isNotEmpty);
        expect(status.trackingLabel, isNot(status.name));
      }
    });

    test('reuses the status keys that already exist', () {
      expect(OrderStatus.delivered.trackingLabel, AppString.statusDelivered);
      expect(OrderStatus.cancelled.trackingLabel, AppString.statusCancelled);
      expect(OrderStatus.unknown.trackingLabel, AppString.unknown);
    });

    test('maps each backend status to its own label', () {
      expect(OrderStatus.placed.trackingLabel, AppString.trackingStepReceived);
      expect(
        OrderStatus.preparing.trackingLabel,
        AppString.trackingStepPreparing,
      );
      expect(OrderStatus.pickedUp.trackingLabel, AppString.statusPickedUp);
      expect(
        OrderStatus.outForDelivery.trackingLabel,
        AppString.trackingStepOutForDelivery,
      );
      expect(OrderStatus.arrived.trackingLabel, AppString.statusArrived);
      expect(
        OrderStatus.awaitingDeliveryConfirmation.trackingLabel,
        AppString.statusAwaitingDeliveryConfirmation,
      );
    });
  });

  group('trackingTimelineSteps', () {
    test('keeps the four Figma steps, in order', () {
      expect(trackingTimelineSteps, const [
        OrderStatus.placed,
        OrderStatus.preparing,
        OrderStatus.outForDelivery,
        OrderStatus.delivered,
      ]);
    });

    test('every step reads as its own timeline title', () {
      expect(
        trackingTimelineSteps.map((status) => status.trackingLabel).toList(),
        const [
          'Received your order',
          'Preparing your order',
          'Out for delivery',
          'Delivered',
        ],
      );
    });
  });
}
