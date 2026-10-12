import 'package:equatable/equatable.dart';

import 'geo_point.dart';

class DriverLocationEntity extends Equatable {
  const DriverLocationEntity({required this.point, this.recordedAt});
  final GeoPoint point;

  /// UTC time the driver app recorded this position (drives the staleness badge).
  final DateTime? recordedAt;

  @override
  List<Object?> get props => [point, recordedAt];
}
