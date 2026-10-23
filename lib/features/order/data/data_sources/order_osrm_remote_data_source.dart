import '../../domain/entities/geo_point.dart';
import '../models/osrm_route_model.dart';

abstract interface class OrderOsrmRemoteDataSource {
  Future<OsrmRouteModel> fetchRoute({
    required GeoPoint from,
    required GeoPoint to,
  });
}
