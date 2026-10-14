import 'package:equatable/equatable.dart';

import 'geo_point.dart';

class DriverLocationEntity extends Equatable {
  const DriverLocationEntity({
    required this.point,
    this.recordedAt,
    this.ageSeconds,
    this.isStale = false,
  });

  final GeoPoint point;
  final DateTime? recordedAt;
  final int? ageSeconds;
  final bool isStale;

  @override
  List<Object?> get props => [point, recordedAt, ageSeconds, isStale];
}
