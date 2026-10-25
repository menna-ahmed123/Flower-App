import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/core/constants/api_request_params.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../models/osrm_route_model.dart';
part 'osrm_api_client.g.dart';

@RestApi()
abstract class OsrmApiClient {
  factory OsrmApiClient(Dio dio, {String baseUrl}) = _OsrmApiClient;

  @GET(ApiEndpoints.osrmRoute)
  Future<OsrmRouteModel> getRoute({
    @Path(ApiRequestParams.osrmCoordinates) required String coordinates,
    @Query(ApiRequestParams.osrmOverview)
    String overview = ApiRequestParams.osrmOverviewFull,
    @Query(ApiRequestParams.osrmGeometries)
    String geometries = ApiRequestParams.osrmGeometriesGeoJson,
  });
}
