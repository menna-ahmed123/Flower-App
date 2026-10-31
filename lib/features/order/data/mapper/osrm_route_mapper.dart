import 'package:flower_app/features/order/data/models/osrm_route_model.dart';

import '../../domain/entities/geo_point.dart';

extension OsrmRouteMapper on OsrmRouteModel {
  List<GeoPoint> toDomain() {
    final route = (routes != null && routes!.isNotEmpty) ? routes!.first : null;
    final coordinates = route?.geometry?.coordinates;
    if (coordinates == null) return const [];

    return [
      for (final pair in coordinates)
        if (pair.length >= 2) GeoPoint(pair[1], pair[0]),
    ];
  }
}
