import 'package:equatable/equatable.dart';

import 'geo_point.dart';

/// `lastKnownLocation` of the tracking response:
/// { lat, lng, recordedAt, ageSeconds, isStale }.
class DriverLocationEntity extends Equatable {
  const DriverLocationEntity({
    required this.point,
    this.recordedAt,
    this.ageSeconds,
    this.isStale = false,
  });

  final GeoPoint point;

  /// UTC time the driver app recorded this position.
  final DateTime? recordedAt;

  /// Age of the position *at the moment the server answered*. Computed by the
  /// server, so it doesn't depend on the phone's clock being right.
  final int? ageSeconds;

  /// The server's own verdict (its threshold is not documented).
  final bool isStale;

  @override
  List<Object?> get props => [point, recordedAt, ageSeconds, isStale];
}
