import 'package:flower_app/features/order/data/api/osrm_api_client.dart';
import 'package:flower_app/features/order/data/models/osrm_route_model.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/geo_point.dart';
import 'order_osrm_remote_data_source.dart';

@Injectable(as: OrderOsrmRemoteDataSource)
class OrderOsrmRemoteDataSourceImpl implements OrderOsrmRemoteDataSource {
  const OrderOsrmRemoteDataSourceImpl(this._osrmApiClient);

  final OsrmApiClient _osrmApiClient;

  @override
  Future<OsrmRouteModel> fetchRoute({
    required GeoPoint from,
    required GeoPoint to,
  }) {
    return _osrmApiClient.getRoute(coordinates: _coordinates(from, to));
  }

  String _coordinates(GeoPoint from, GeoPoint to) =>
      '${from.lng},${from.lat};${to.lng},${to.lat}';
}
