import 'package:equatable/equatable.dart';

import 'order_status.dart';

class TimelineStepEntity extends Equatable {
  const TimelineStepEntity({
    required this.status,
    required this.isCompleted,
    required this.isCurrent,
    this.occurredAt,
  });
  final OrderStatus status;
  final bool isCompleted;
  final bool isCurrent;
  final DateTime? occurredAt;

  @override
  List<Object?> get props => [status, isCompleted, isCurrent, occurredAt];
}
