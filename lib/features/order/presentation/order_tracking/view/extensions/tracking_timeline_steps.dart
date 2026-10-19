import 'package:flower_app/features/order/domain/entities/order_status.dart';
import 'package:flower_app/features/order/domain/entities/tracking_entity.dart';

import 'order_status_tracking_label.dart';

/// One visible timeline step: which backend status it stands for, and when it
/// happened.
///
/// It carries no title on purpose. The wording is read from
/// [OrderStatusTrackingLabel] where the step is painted, so the same step
/// renders in the customer's language.
typedef TrackingTimelineStep = ({OrderStatus status, DateTime? occurredAt});

/// The API statuses each displayed step covers. `pickedUp` happens inside
/// "Out for delivery", so its timestamp belongs to that step.
const Map<OrderStatus, List<OrderStatus>> _timelineCoverage = {
  OrderStatus.placed: [OrderStatus.placed],
  OrderStatus.preparing: [OrderStatus.preparing],
  OrderStatus.outForDelivery: [
    OrderStatus.outForDelivery,
    OrderStatus.pickedUp,
  ],
  OrderStatus.delivered: [OrderStatus.delivered],
};

/// The tracking timeline, built the way the screen shows it.
extension TrackingEntityTimeline on TrackingEntity {
  /// The four steps in display order, each with the timestamp the order
  /// actually reached it.
  List<TrackingTimelineStep> get trackingTimeline => [
    for (final step in trackingTimelineSteps)
      (
        status: step,
        occurredAt: _firstOccurrence(
          _timelineCoverage[step] ?? const [OrderStatus.unknown],
        ),
      ),
  ];

  DateTime? _firstOccurrence(List<OrderStatus> statuses) {
    for (final status in statuses) {
      for (final step in timeline) {
        if (step.status == status && step.occurredAt != null) {
          return step.occurredAt;
        }
      }
    }
    return null;
  }
}
